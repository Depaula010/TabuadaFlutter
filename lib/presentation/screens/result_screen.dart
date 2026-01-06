import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:confetti/confetti.dart';
import '../../core/constants/app_assets.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../data/services/audio_service.dart';
import '../../logic/providers/game_provider.dart';
import '../../logic/providers/progress_provider.dart';
import '../widgets/custom_button.dart';
import 'mode_selection_screen.dart';

/// Tela de resultados após o jogo
class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    
    // Calcula precisão
    final gameProvider = context.read<GameProvider>();
    final accuracy = gameProvider.totalQuestions > 0
        ? (gameProvider.correctCount / gameProvider.totalQuestions)
        : 0.0;

    // Celebração graduada baseada na precisão
    if (gameProvider.wrongCount == 0) {
      // 100% - Explosão total + som de troféu
      _confettiController.play();
      AudioService().playTrophyUnlockedSound();
    } else if (accuracy >= 0.8) {
      // 80-99% - Confetti menor + som de sucesso
      _confettiController.play();
      AudioService().playCorrectSound();
    }
    // Abaixo de 80% - sem confetti, apenas feedback visual

    // Recarrega o progresso
    context.read<ProgressProvider>().loadProgress();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.of(context).popUntil((route) => route.isFirst);
      },
      child: Scaffold(
        body: Stack(
          children: [
            // Fundo
            Container(
              decoration: const BoxDecoration(
                gradient: AppColors.backgroundGradient,
              ),
            ),

            // Conteúdo
            SafeArea(
              child: Consumer<GameProvider>(
                builder: (context, gameProvider, _) {
                  final accuracy = gameProvider.totalQuestions > 0
                      ? (gameProvider.correctCount / gameProvider.totalQuestions) * 100
                      : 0.0;

                  return Column(
                    children: [
                      const SizedBox(height: 40),

                      // Título
                      Text(
                        gameProvider.wrongCount == 0
                            ? '🎉 PERFEITO! 🎉'
                            : accuracy >= 80
                                ? '👏 Muito Bem! 👏'
                                : '✨ Bom Trabalho! ✨',
                        style: AppTextStyles.h1.copyWith(fontSize: 36),
                        textAlign: TextAlign.center,
                      ).animate().fadeIn(duration: 600.ms).scale(),

                      const SizedBox(height: 20),

                      // Personagem celebrando
                      Image.asset(
                        accuracy >= 70 
                            ? AppAssets.characterExcited 
                            : AppAssets.characterHappy,
                        height: 150,
                      ).animate().slideY(
                        begin: 0.5, 
                        end: 0, 
                        duration: 600.ms, 
                        curve: Curves.easeOutBack,
                      ),

                      const SizedBox(height: 20),

                      // Cards de estatísticas
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              // Score principal
                              _buildScoreCard(gameProvider.score),

                              const SizedBox(height: 20),

                              // Estatísticas detalhadas
                              _buildStatsGrid(gameProvider, accuracy),

                              const SizedBox(height: 20),

                              // Estrelas conquistadas (ambos os modos)
                              _buildStarsDisplay(accuracy),

                              const SizedBox(height: 30),
                            ],
                          ),
                        ),
                      ),

                      // Botões de ação
                      _buildActionButtons(context, gameProvider),
                    ],
                  );
                },
              ),
            ),

            // Confetti
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                emissionFrequency: 0.02,
                numberOfParticles: 30,
                colors: const [
                  AppColors.primary,
                  AppColors.secondary,
                  AppColors.accent,
                  AppColors.success,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreCard(int score) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: AppColors.secondaryGradient,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withOpacity(0.4),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(Icons.stars, size: 60, color: Colors.white),
          const SizedBox(height: 16),
          Text(
            '$score',
            style: AppTextStyles.h1.copyWith(
              color: Colors.white,
              fontSize: 72,
            ),
          ),
          Text(
            'PONTOS',
            style: AppTextStyles.h3.copyWith(
              color: Colors.white.withOpacity(0.9),
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms).scale();
  }

  Widget _buildStatsGrid(GameProvider provider, double accuracy) {
    final stats = [
      {'icon': Icons.check_circle, 'label': 'Acertos', 'value': '${provider.correctCount}', 'color': AppColors.success},
      {'icon': Icons.cancel, 'label': 'Erros', 'value': '${provider.wrongCount}', 'color': AppColors.error},
      {'icon': Icons.analytics, 'label': 'Precisão', 'value': '${accuracy.toStringAsFixed(0)}%', 'color': AppColors.primary},
      if (provider.mode == GameMode.timeAttack)
        {'icon': Icons.timer, 'label': 'Tempo', 'value': '${60 - provider.remainingSeconds}s', 'color': AppColors.accent},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.0,
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) {
        final stat = stats[index];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: (stat['color'] as Color).withOpacity(0.15),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                stat['icon'] as IconData,
                size: 32,
                color: stat['color'] as Color,
              ),
              const SizedBox(height: 8),
              Text(
                stat['value'] as String,
                style: AppTextStyles.h2.copyWith(
                  color: stat['color'] as Color,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                stat['label'] as String,
                style: AppTextStyles.caption,
              ),
            ],
          ),
        ).animate().fadeIn(delay: ((index + 1) * 150).ms).scale();
      },
    );
  }

  Widget _buildStarsDisplay(double accuracy) {
    int stars = 0;
    if (accuracy >= 95) stars = 3;
    else if (accuracy >= 80) stars = 2;
    else if (accuracy >= 60) stars = 1;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Estrelas Conquistadas',
            style: AppTextStyles.h3,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              3,
              (i) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Icon(
                  i < stars ? Icons.star : Icons.star_border,
                  size: 50,
                  color: AppColors.secondary,
                )
                    .animate()
                    .fadeIn(delay: ((i + 1) * 200).ms)
                    .scale(curve: Curves.elasticOut),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, GameProvider provider) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          CustomButton(
            text: 'JOGAR NOVAMENTE',
            onPressed: () {
              // Volta para a tela de seleção de modo
              Navigator.of(context).popUntil((route) => route.isFirst);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ModeSelectionScreen(),
                ),
              );
            },
            gradient: AppColors.primaryGradient,
            icon: Icons.replay,
          ),
          const SizedBox(height: 12),
          CustomButton(
            text: 'Menu Principal',
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            gradient: AppColors.accentGradient,
            icon: Icons.home,
            isSecondary: true,
          ),
        ],
      ),
    );
  }
}
