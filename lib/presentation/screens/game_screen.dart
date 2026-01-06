import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/haptic_helper.dart';
import '../../data/services/audio_service.dart';
import '../../logic/providers/game_provider.dart';
import '../widgets/answer_option.dart';
import 'result_screen.dart';

/// Tela principal do jogo
class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _feedbackController;
  bool _showingFeedback = false;
  bool _lastAnswerCorrect = false;

  @override
  void initState() {
    super.initState();
    _feedbackController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  Future<void> _handleAnswer(BuildContext context, int answer) async {
    if (_showingFeedback) return;

    final gameProvider = context.read<GameProvider>();
    final isCorrect = await gameProvider.submitAnswer(answer);

    setState(() {
      _showingFeedback = true;
      _lastAnswerCorrect = isCorrect;
    });

    if (isCorrect) {
      HapticHelper.success();
      _feedbackController.forward().then((_) => _feedbackController.reverse());
    } else {
      HapticHelper.error();
    }

    await Future.delayed(const Duration(milliseconds: 800));

    if (mounted) {
      setState(() {
        _showingFeedback = false;
      });

      // Verifica se o jogo terminou
      if (gameProvider.state == GameState.finished) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ResultScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        
        final gameProvider = context.read<GameProvider>();
        gameProvider.pauseGame();
        
        final shouldExit = await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Pausar Jogo?'),
            content: const Text('Você quer sair do jogo atual?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Continuar'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: const Text('Sair'),
              ),
            ],
          ),
        );

        if (shouldExit == false) {
          gameProvider.resumeGame();
        } else if (shouldExit == true) {
          // Para a música completamente ao sair
          AudioService().stopBackgroundMusic();
          if (context.mounted) {
            Navigator.of(context).pop();
          }
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            // Fundo com feedback de cor
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                gradient: _showingFeedback
                    ? (_lastAnswerCorrect
                        ? AppColors.successGradient
                        : LinearGradient(
                            colors: [
                              AppColors.error.withOpacity(0.3),
                              AppColors.errorLight.withOpacity(0.3),
                            ],
                          ))
                    : AppColors.backgroundGradient,
              ),
            ),

            // Conteúdo principal
            SafeArea(
              child: Column(
                children: [
                  // Header com progresso e timer
                  _buildHeader(),

                  const SizedBox(height: 20),

                  // Área da questão
                  Expanded(
                    child: Consumer<GameProvider>(
                      builder: (context, provider, _) {
                        final question = provider.currentQuestion;

                        if (question == null) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Pontuação atual
                            _buildScoreDisplay(provider),

                            const SizedBox(height: 40),

                            // Questão
                            _buildQuestionDisplay(question.questionText),

                            const SizedBox(height: 60),

                            // Opções de resposta
                            _buildAnswerOptions(context, question.options),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Feedback visual animado
            if (_showingFeedback)
              Center(
                child: ScaleTransition(
                  scale: _feedbackController,
                  child: Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: _lastAnswerCorrect
                          ? AppColors.success
                          : AppColors.error,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: (_lastAnswerCorrect
                                  ? AppColors.success
                                  : AppColors.error)
                              .withOpacity(0.5),
                          blurRadius: 40,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: Icon(
                      _lastAnswerCorrect ? Icons.check : Icons.close,
                      size: 80,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Consumer<GameProvider>(
      builder: (context, provider, _) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              // Botão voltar
              IconButton(
                icon: const Icon(Icons.pause_rounded, size: 28),
                onPressed: () {
                  provider.pauseGame();
                  Navigator.pop(context);
                },
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.primary,
                ),
              ),

              const SizedBox(width: 16),

              // Barra de progresso
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Questão ${provider.currentQuestionNumber}/${provider.totalQuestions}',
                          style: AppTextStyles.caption.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (provider.mode == GameMode.timeAttack)
                          Row(
                            children: [
                              Icon(
                                Icons.timer,
                                size: 16,
                                color: provider.isTimeCritical
                                    ? AppColors.error
                                    : AppColors.primary,
                              ),
                              const SizedBox(width: 4),
                              AnimatedDefaultTextStyle(
                                duration: const Duration(milliseconds: 100),
                                style: AppTextStyles.caption.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: provider.isTimeCritical ? 16 : 14,
                                  color: provider.isTimeCritical
                                      ? AppColors.error
                                      : AppColors.primary,
                                ),
                                child: Text(
                                  provider.isTimeCritical
                                      ? '${provider.remainingSeconds}.${provider.remainingTenths}s'
                                      : '${provider.remainingSeconds}s',
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: provider.mode == GameMode.timeAttack
                            ? provider.remainingMilliseconds / 60000
                            : provider.progress,
                        backgroundColor: Colors.white.withOpacity(0.3),
                        color: provider.isTimeCritical 
                            ? AppColors.error 
                            : AppColors.secondary,
                        minHeight: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildScoreDisplay(GameProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        gradient: AppColors.secondaryGradient,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.stars, color: Colors.white, size: 24),
          const SizedBox(width: 8),
          Text(
            '${provider.score} pontos',
            style: AppTextStyles.score.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionDisplay(String questionText) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.15),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Text(
        questionText,
        style: AppTextStyles.numberLarge,
        textAlign: TextAlign.center,
      ),
    ).animate().fadeIn(duration: 400.ms).scale();
  }

  Widget _buildAnswerOptions(BuildContext context, List<int> options) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.5,
        ),
        itemCount: options.length,
        itemBuilder: (context, index) {
          return AnswerOption(
            answer: options[index],
            onTap: () => _handleAnswer(context, options[index]),
            isDisabled: _showingFeedback,
            index: index,
          );
        },
      ),
    );
  }
}
