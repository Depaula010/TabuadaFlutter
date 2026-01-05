import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../logic/providers/game_provider.dart';
import '../../logic/providers/progress_provider.dart';
import 'game_screen.dart';

/// Tela de seleção de dificuldade (escolha da tabuada)
class DifficultyScreen extends StatelessWidget {
  final GameMode mode;

  const DifficultyScreen({super.key, required this.mode});

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
                child: Column(
                  children: [
                    Text(
                      'Escolha a Tabuada',
                      style: AppTextStyles.h2,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      mode == GameMode.timeAttack
                          ? 'Questões aleatórias de todas as tabuadas'
                          : 'Selecione qual tabuada quer praticar',
                      style: AppTextStyles.caption,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Grid de tabuadas
              Expanded(
                child: mode == GameMode.timeAttack
                    ? _buildTimeAttackOption(context)
                    : _buildTablesGrid(context),
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

  Widget _buildTimeAttackOption(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: GestureDetector(
          onTap: () => _startGame(context, 0), // 0 indica modo aleatório
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              gradient: AppColors.secondaryGradient,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: AppColors.secondary.withOpacity(0.4),
                  blurRadius: 25,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shuffle_rounded,
                  size: 80,
                  color: Colors.white,
                ),
                const SizedBox(height: 16),
                Text(
                  'MODO ALEATÓRIO',
                  style: AppTextStyles.h2.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  'Todas as tabuadas de 1 a 10',
                  style: AppTextStyles.body.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
        ),
      ),
    );
  }

  Widget _buildTablesGrid(BuildContext context) {
    return Consumer<ProgressProvider>(
      builder: (context, progressProvider, _) {
        return GridView.builder(
          padding: const EdgeInsets.all(20),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.1,
          ),
          itemCount: 10,
          itemBuilder: (context, index) {
            final tableNumber = index + 1;
            final progress = progressProvider.getTableProgress(tableNumber);
            final stars = progressProvider.getTableStars(tableNumber);
            final isCompleted = progressProvider.isTableCompleted(tableNumber);

            return _buildTableCard(
              context,
              tableNumber,
              stars,
              isCompleted,
              progress,
              index,
            );
          },
        );
      },
    );
  }

  Widget _buildTableCard(
    BuildContext context,
    int tableNumber,
    int stars,
    bool isCompleted,
    progress,
    int index,
  ) {
    final accuracy = progress?.accuracy ?? 0.0;

    return GestureDetector(
      onTap: () => _startGame(context, tableNumber),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isCompleted ? AppColors.success : AppColors.divider,
            width: isCompleted ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isCompleted
                  ? AppColors.success.withOpacity(0.2)
                  : Colors.black.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Conteúdo principal
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Número da tabuada
                Text(
                  '$tableNumber',
                  style: AppTextStyles.numberLarge.copyWith(
                    fontSize: 56,
                    foreground: Paint()
                      ..shader = AppColors.primaryGradient.createShader(
                        const Rect.fromLTWH(0, 0, 100, 100),
                      ),
                  ),
                ),

                const SizedBox(height: 8),

                // Texto
                Text(
                  'Tabuada do $tableNumber',
                  style: AppTextStyles.body.copyWith(fontSize: 14),
                ),

                const SizedBox(height: 12),

                // Estrelas
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    3,
                    (i) => Icon(
                      i < stars ? Icons.star : Icons.star_border,
                      color: AppColors.secondary,
                      size: 20,
                    ),
                  ),
                ),

                // Precisão
                if (progress != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    '${accuracy.toStringAsFixed(0)}% precisão',
                    style: AppTextStyles.caption.copyWith(
                      color: accuracy >= 80
                          ? AppColors.success
                          : AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),

            // Badge de completo
            if (isCompleted)
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
          ],
        ),
      )
          .animate()
          .fadeIn(delay: (index * 80).ms)
          .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1)),
    );
  }

  void _startGame(BuildContext context, int tableNumber) {
    final gameProvider = context.read<GameProvider>();

    // Para Time Attack, usa questões aleatórias
    final selectedTable = mode == GameMode.timeAttack
        ? (tableNumber == 0 ? 1 : tableNumber) // Temporário, depois implementar lógica aleatória
        : tableNumber;

    gameProvider.startGame(
      mode: mode,
      tableNumber: selectedTable,
      questionCount: mode == GameMode.timeAttack ? 999 : 10, // Time Attack não tem limite de questões
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const GameScreen(),
      ),
    );
  }
}
