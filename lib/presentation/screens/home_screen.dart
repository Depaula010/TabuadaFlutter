import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/parental_gate.dart';
import '../../logic/providers/progress_provider.dart';
import '../widgets/custom_button.dart';
import 'mode_selection_screen.dart';
import 'trophies_screen.dart';
import 'settings_screen.dart';

/// Tela inicial do app
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // Header com estatísticas
                _buildHeader(),

                const SizedBox(height: 40),

                // Personagem e título
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Placeholder para personagem (usar asset real depois)
                      Icon(
                        Icons.emoji_events,
                        size: 140,
                        color: AppColors.secondary,
                      )
                          .animate(onPlay: (controller) => controller.repeat())
                          .shimmer(duration: 2000.ms, color: AppColors.secondaryLight)
                          .shake(hz: 0.5, curve: Curves.easeInOut),

                      const SizedBox(height: 24),

                      Text(
                        'Mestres do Cálculo',
                        style: AppTextStyles.h1.copyWith(
                          foreground: Paint()
                            ..shader = AppColors.primaryGradient.createShader(
                              const Rect.fromLTWH(0, 0, 300, 70),
                            ),
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 4),

                      Text(
                        'Escolha um modo e comece a jogar!',
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                // Botões de ação
                _buildActionButtons(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Consumer<ProgressProvider>(
      builder: (context, progressProvider, _) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                icon: Icons.star,
                label: 'Estrelas',
                value: '${progressProvider.totalStars}',
                color: AppColors.secondary,
              ),
              Container(width: 1, height: 40, color: AppColors.divider),
              _buildStatItem(
                icon: Icons.emoji_events,
                label: 'Troféus',
                value: '${progressProvider.unlockedTrophies.length}/${progressProvider.allTrophies.length}',
                color: AppColors.accent,
              ),
              Container(width: 1, height: 40, color: AppColors.divider),
              _buildStatItem(
                icon: Icons.check_circle,
                label: 'Completas',
                value: '${progressProvider.completedTablesCount}/10',
                color: AppColors.success,
              ),
            ],
          ),
        ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2, end: 0);
      },
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 4),
        Text(value, style: AppTextStyles.h3.copyWith(color: color)),
        Text(
          label,
          style: AppTextStyles.caption,
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        CustomButton(
          text: 'JOGAR',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ModeSelectionScreen()),
            );
          },
          gradient: AppColors.primaryGradient,
          icon: Icons.play_arrow_rounded,
        ).animate().fadeIn(delay: 200.ms).scale(),

        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: CustomButton(
                text: 'Troféus',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const TrophiesScreen()),
                  );
                },
                gradient: AppColors.accentGradient,
                icon: Icons.emoji_events,
                isSecondary: true,
              ).animate().fadeIn(delay: 300.ms).slideX(begin: -0.2, end: 0),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomButton(
                text: 'Config',
                onPressed: () async {
                  // Parental Gate para proteger configurações
                  final allowed = await ParentalGate.show(context);
                  if (allowed && context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SettingsScreen()),
                    );
                  } else if (!allowed && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('❌ Resposta incorreta'),
                        backgroundColor: AppColors.error,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                },
                gradient: AppColors.secondaryGradient,
                icon: Icons.settings,
                isSecondary: true,
              ).animate().fadeIn(delay: 400.ms).slideX(begin: 0.2, end: 0),
            ),
          ],
        ),

        const SizedBox(height: 20),
      ],
    );
  }
}
