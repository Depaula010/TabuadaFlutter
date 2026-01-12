import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../data/models/question.dart';
import '../../data/services/learning_content_service.dart';
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
      floatingActionButton: _buildLearnButton(context),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(context),

              const SizedBox(height: 12),

              // Título
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Text(
                      'Escolha a Operação',
                      style: AppTextStyles.h2,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Selecione a operação matemática',
                      style: AppTextStyles.caption,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Seleção de Operação
              _buildOperationSelector(context),

              const SizedBox(height: 20),

              // Título da tabuada
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Text(
                      'Escolha o Número',
                      style: AppTextStyles.h2.copyWith(fontSize: 22),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      mode == GameMode.timeAttack
                          ? 'Questões aleatórias de todas as tabuadas'
                          : 'Selecione qual número quer praticar',
                      style: AppTextStyles.caption,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

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

  /// Botão flutuante "Aprender"
  Widget _buildLearnButton(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, _) {
        return FloatingActionButton.extended(
          onPressed: () => _showLearningBottomSheet(context, gameProvider),
          backgroundColor: AppColors.secondary,
          icon: const Text('💡', style: TextStyle(fontSize: 24)),
          label: Text(
            'Aprender',
            style: AppTextStyles.button.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ).animate().fadeIn(delay: 500.ms).slideY(begin: 1, end: 0);
      },
    );
  }

  /// Modal Bottom Sheet com conteúdo educativo
  void _showLearningBottomSheet(BuildContext context, GameProvider gameProvider) {
    final operation = gameProvider.selectedOperation;
    // Usar operação intro se não houver número selecionado
    final content = LearningContentService.getOperationIntro(operation);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Título
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: _getOperationGradient(operation),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    operation.symbol,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    content.title,
                    style: AppTextStyles.h2.copyWith(fontSize: 22),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Explicação
            Text(
              content.explanation,
              style: AppTextStyles.body,
            ),
            const SizedBox(height: 16),

            // Dica Visual
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.divider),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('💡', style: TextStyle(fontSize: 18)),
                      const SizedBox(width: 8),
                      Text(
                        'Dica Visual',
                        style: AppTextStyles.body.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    content.visualTip,
                    style: AppTextStyles.body.copyWith(fontSize: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Exemplos
            Text(
              'Exemplos:',
              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...content.examples.map((example) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  const Text('✨', style: TextStyle(fontSize: 14)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(example, style: AppTextStyles.body),
                  ),
                ],
              ),
            )),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  /// Seletor de operação com 4 botões
  Widget _buildOperationSelector(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, _) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildOperationButton(
                context,
                gameProvider,
                Operation.addition,
                '+',
                const LinearGradient(
                  colors: [Color(0xFF4CAF50), Color(0xFF81C784)],
                ),
              ),
              _buildOperationButton(
                context,
                gameProvider,
                Operation.subtraction,
                '-',
                const LinearGradient(
                  colors: [Color(0xFFFF9800), Color(0xFFFFB74D)],
                ),
              ),
              _buildOperationButton(
                context,
                gameProvider,
                Operation.multiplication,
                '×',
                const LinearGradient(
                  colors: [Color(0xFFAA5FFF), Color(0xFFD0A8FF)],
                ),
              ),
              _buildOperationButton(
                context,
                gameProvider,
                Operation.division,
                '÷',
                const LinearGradient(
                  colors: [Color(0xFFE91E63), Color(0xFFF48FB1)],
                ),
              ),
            ],
          ),
        ).animate().fadeIn(delay: 200.ms).slideY(begin: -0.3, end: 0);
      },
    );
  }

  /// Botão individual de operação
  Widget _buildOperationButton(
    BuildContext context,
    GameProvider gameProvider,
    Operation operation,
    String symbol,
    LinearGradient gradient,
  ) {
    final isSelected = gameProvider.selectedOperation == operation;

    return GestureDetector(
      onTap: () => gameProvider.setOperation(operation),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: isSelected ? 72 : 64,
        height: isSelected ? 72 : 64,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.white : Colors.transparent,
            width: isSelected ? 4 : 0,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? gradient.colors.first.withOpacity(0.5)
                  : Colors.black.withOpacity(0.1),
              blurRadius: isSelected ? 15 : 8,
              offset: Offset(0, isSelected ? 6 : 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            symbol,
            style: TextStyle(
              fontSize: isSelected ? 36 : 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.3),
                  offset: const Offset(1, 1),
                  blurRadius: 3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Retorna o gradiente para uma operação específica
  LinearGradient _getOperationGradient(Operation operation) {
    switch (operation) {
      case Operation.addition:
        return const LinearGradient(
          colors: [Color(0xFF4CAF50), Color(0xFF81C784)],
        );
      case Operation.subtraction:
        return const LinearGradient(
          colors: [Color(0xFFFF9800), Color(0xFFFFB74D)],
        );
      case Operation.multiplication:
        return const LinearGradient(
          colors: [Color(0xFFAA5FFF), Color(0xFFD0A8FF)],
        );
      case Operation.division:
        return const LinearGradient(
          colors: [Color(0xFFE91E63), Color(0xFFF48FB1)],
        );
    }
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
