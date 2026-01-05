import 'package:flutter/material.dart';
import 'dart:math';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

/// Parental Gate - Proteção para áreas restritas às crianças
/// 
/// Solicita resolução de uma conta matemática simples para adultos
/// Em conformidade com COPPA (Children's Online Privacy Protection Act)
class ParentalGate {
  /// Mostra o Parental Gate e retorna true se o usuário passar
  static Future<bool> show(BuildContext context) async {
    final random = Random();
    final a = random.nextInt(10) + 1;
    final b = random.nextInt(10) + 1;
    final correctAnswer = a + b;
    final controller = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Ícone
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.warning.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.lock_outline,
                  size: 48,
                  color: AppColors.warning,
                ),
              ),

              const SizedBox(height: 20),

              // Título
              Text(
                'Verificação para Adultos',
                style: AppTextStyles.h3,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 12),

              // Explicação
              Text(
                'Para acessar esta área, resolva a conta abaixo:',
                style: AppTextStyles.body.copyWith(fontSize: 14),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              // Questão matemática
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '$a + $b = ?',
                  style: AppTextStyles.numberMedium.copyWith(
                    color: Colors.white,
                    fontSize: 32,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Campo de resposta
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: AppTextStyles.h2,
                decoration: InputDecoration(
                  hintText: 'Digite a resposta',
                  hintStyle: AppTextStyles.caption,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: AppColors.primary, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: AppColors.primary, width: 2),
                  ),
                  filled: true,
                  fillColor: AppColors.background,
                ),
                onSubmitted: (value) {
                  final answer = int.tryParse(value) ?? 0;
                  Navigator.pop(context, answer == correctAnswer);
                },
              ),

              const SizedBox(height: 24),

              // Botões
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Cancelar',
                        style: AppTextStyles.button.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        final answer = int.tryParse(controller.text) ?? 0;
                        Navigator.pop(context, answer == correctAnswer);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Confirmar',
                        style: AppTextStyles.button.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Mensagem de ajuda
              Text(
                'Esta verificação protege configurações e links externos',
                style: AppTextStyles.caption.copyWith(fontSize: 11),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );

    return result ?? false;
  }

  /// Versão simplificada para casos menos críticos
  static Future<bool> showSimple(BuildContext context, {String? message}) async {
    final random = Random();
    final number = random.nextInt(5) + 1;
    final correctAnswer = number * 2;

    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.lock, color: AppColors.warning),
            const SizedBox(width: 8),
            const Text('Verificação'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message ?? 'Para continuar, calcule:',
              style: AppTextStyles.body,
            ),
            const SizedBox(height: 16),
            Text(
              '$number × 2 = ?',
              style: AppTextStyles.h2.copyWith(color: AppColors.primary),
            ),
            const SizedBox(height: 16),
            TextField(
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: 'Resposta',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onSubmitted: (value) {
                final answer = int.tryParse(value) ?? 0;
                Navigator.pop(context, answer == correctAnswer);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    ) ?? false;
  }
}
