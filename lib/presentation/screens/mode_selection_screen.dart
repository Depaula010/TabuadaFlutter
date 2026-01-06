import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../logic/providers/game_provider.dart';
import '../widgets/custom_button.dart';
import 'difficulty_screen.dart';

/// Tela de seleção de modo de jogo
class ModeSelectionScreen extends StatelessWidget {
  const ModeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(context),

              const SizedBox(height: 20),

              // Título
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Escolha o Modo de Jogo',
                  style: AppTextStyles.h2,
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 30),

              // Modos de jogo
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    _buildModeCard(
                      context,
                      title: 'Treino Livre',
                      description: 'Aprenda no seu ritmo, sem pressão de tempo',
                      icon: Icons.school_rounded,
                      gradient: AppColors.successGradient,
                      mode: GameMode.training,
                      features: [
                        'Sem limite de tempo',
                        'Escolha a tabuada',
                        'Acompanhe seu progresso',
                      ],
                      index: 0,
                    ),

                    _buildModeCard(
                      context,
                      title: 'Desafio Relâmpago',
                      description: 'Acerte o máximo que puder em 60 segundos!',
                      icon: Icons.flash_on_rounded,
                      gradient: AppColors.secondaryGradient,
                      mode: GameMode.timeAttack,
                      features: [
                        '60 segundos de adrenalina',
                        'Questões aleatórias',
                        'Bônus por sequência',
                      ],
                      index: 1,
                    ),

                    _buildModeCard(
                      context,
                      title: 'Duelo de Balões',
                      description: 'Estoure os balões com as respostas corretas!',
                      icon: Icons.celebration_rounded,
                      gradient: AppColors.accentGradient,
                      mode: GameMode.balloonDuel,
                      features: [
                        'Balões flutuantes',
                        'Interação divertida',
                        'Modo visual',
                      ],
                      index: 2,
                      comingSoon: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_rounded, size: 28),
            onPressed: () => Navigator.pop(context),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Gradient gradient,
    required GameMode mode,
    required List<String> features,
    required int index,
    bool comingSoon = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: gradient.colors.first.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header do card com gradiente
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 40, color: Colors.white),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              title,
                              style: AppTextStyles.h3.copyWith(color: Colors.white),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (comingSoon) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'EM BREVE',
                                style: AppTextStyles.caption.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: AppTextStyles.body.copyWith(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Features
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                ...features.map((feature) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: gradient.colors.first,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              feature,
                              style: AppTextStyles.body.copyWith(fontSize: 15),
                            ),
                          ),
                        ],
                      ),
                    )),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    text: comingSoon ? 'EM BREVE' : 'JOGAR AGORA',
                    onPressed: comingSoon
                        ? () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Row(
                                  children: const [
                                    Icon(Icons.construction, color: Colors.white),
                                    SizedBox(width: 12),
                                    Flexible(
                                      child: Text('Este modo estará disponível em breve!'),
                                    ),
                                  ],
                                ),
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: gradient.colors.first,
                                duration: const Duration(seconds: 2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            );
                          }
                        : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DifficultyScreen(mode: mode),
                              ),
                            );
                          },
                    gradient: gradient,
                    icon: comingSoon ? Icons.lock_clock : Icons.play_arrow_rounded,
                    isDisabled: comingSoon,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: (index * 150).ms)
        .slideY(begin: 0.3, end: 0);
  }
}
