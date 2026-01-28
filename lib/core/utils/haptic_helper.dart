import 'package:flutter/services.dart';
import '../../data/services/hive_service.dart';

/// Helper para feedback tátil (vibração) usando HapticFeedback nativo do Flutter
class HapticHelper {
  /// Vibração leve para feedback de sucesso
  static Future<void> success() async {
    if (!HiveService.isVibrationEnabled()) return;
    await HapticFeedback.lightImpact();
  }

  /// Vibração média para feedback de erro
  static Future<void> error() async {
    if (!HiveService.isVibrationEnabled()) return;
    await HapticFeedback.heavyImpact();
  }

  /// Vibração para seleção (toque em botões)
  static Future<void> selection() async {
    if (!HiveService.isVibrationEnabled()) return;
    await HapticFeedback.selectionClick();
  }

  /// Vibração celebratória (conquistas)
  static Future<void> celebration() async {
    if (!HiveService.isVibrationEnabled()) return;
    // Padrão de vibração: curta-pausa-curta-pausa-longa
    await HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(milliseconds: 50));
    await HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(milliseconds: 50));
    await HapticFeedback.heavyImpact();
  }
}
