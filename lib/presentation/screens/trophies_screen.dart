import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../logic/providers/progress_provider.dart';

/// Tela de troféus e conquistas
class TrophiesScreen extends StatelessWidget {
  const TrophiesScreen({super.key});

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

              // Lista de troféus
              Expanded(
                child: Consumer<ProgressProvider>(
                  builder: (context, provider, _) {
                    final trophies = provider.allTrophies;

                    if (trophies.isEmpty) {
                      return Center(
                        child: Text(
                          'Nenhum troféu ainda...',
                          style: AppTextStyles.h3,
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(20),
                      itemCount: trophies.length,
                      itemBuilder: (context, index) {
                        final trophy = trophies[index];
                        return _buildTrophyCard(trophy, index);
                      },
                    );
                  },
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
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Troféus', style: AppTextStyles.h2),
              Consumer<ProgressProvider>(
                builder: (context, provider, _) {
                  return Text(
                    '${provider.unlockedTrophies.length} de ${provider.allTrophies.length} desbloqueados',
                    style: AppTextStyles.caption,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTrophyCard(trophy, int index) {
    final isUnlocked = trophy.isUnlocked;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isUnlocked ? Colors.white : Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isUnlocked ? AppColors.secondary : AppColors.divider,
          width: isUnlocked ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isUnlocked
                ? AppColors.secondary.withOpacity(0.2)
                : Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          // Ícone do troféu
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: isUnlocked
                  ? AppColors.secondaryGradient
                  : const LinearGradient(colors: [Colors.grey, Colors.grey]),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.emoji_events,
              size: 32,
              color: Colors.white,
            ),
          ),

          const SizedBox(width: 16),

          // Informações do troféu
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  trophy.title,
                  style: AppTextStyles.h3.copyWith(
                    color: isUnlocked ? AppColors.textPrimary : AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  trophy.description,
                  style: AppTextStyles.caption.copyWith(
                    color: isUnlocked ? AppColors.textSecondary : AppColors.textSecondary.withOpacity(0.6),
                  ),
                ),
                if (isUnlocked && trophy.unlockedAt != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 14,
                        color: AppColors.success,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Desbloqueado!',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.success,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          // Badge de categoria
          if (isUnlocked)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _getCategoryColor(trophy.category),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _getCategoryName(trophy.category),
                style: AppTextStyles.caption.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
            ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: (index * 100).ms)
        .slideX(begin: 0.3, end: 0);
  }

  Color _getCategoryColor(category) {
    switch (category.toString()) {
      case 'TrophyCategory.speed':
        return AppColors.error;
      case 'TrophyCategory.perfectionist':
        return AppColors.accent;
      case 'TrophyCategory.master':
        return AppColors.primary;
      default:
        return AppColors.success;
    }
  }

  String _getCategoryName(category) {
    switch (category.toString()) {
      case 'TrophyCategory.speed':
        return 'VELOCIDADE';
      case 'TrophyCategory.perfectionist':
        return 'PERFEIÇÃO';
      case 'TrophyCategory.master':
        return 'MESTRE';
      case 'TrophyCategory.beginner':
        return 'INICIANTE';
      default:
        return 'COLECIONADOR';
    }
  }
}
