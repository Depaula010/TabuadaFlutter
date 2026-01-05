import 'package:vibration/vibration.dart';
import '../../data/services/hive_service.dart';

/// Helper para feedback tátil (vibração)
class HapticHelper {
  /// Vibração leve para feedback de sucesso
  static Future<void> success() async {
    if (!HiveService.isVibrationEnabled()) return;
    
    final hasVibrator = await Vibration.hasVibrator() ?? false;
    if (hasVibrator) {
      Vibration.vibrate(duration: 50, amplitude: 128);
    }
  }

  /// Vibração média para feedback de erro
  static Future<void> error() async {
    if (!HiveService.isVibrationEnabled()) return;
    
    final hasVibrator = await Vibration.hasVibrator() ?? false;
    if (hasVibrator) {
      Vibration.vibrate(duration: 200, amplitude: 200);
    }
  }

  /// Vibração para seleção (toque em botões)
  static Future<void> selection() async {
    if (!HiveService.isVibrationEnabled()) return;
    
    final hasVibrator = await Vibration.hasVibrator() ?? false;
    if (hasVibrator) {
      Vibration.vibrate(duration: 30, amplitude: 100);
    }
  }

  /// Vibração celebratória (conquistas)
  static Future<void> celebration() async {
    if (!HiveService.isVibrationEnabled()) return;
    
    final hasVibrator = await Vibration.hasVibrator() ?? false;
    if (hasVibrator) {
      // Padrão de vibração: curta-pausa-curta-pausa-longa
      Vibration.vibrate(duration: 100);
      await Future.delayed(const Duration(milliseconds: 50));
      Vibration.vibrate(duration: 100);
      await Future.delayed(const Duration(milliseconds: 50));
      Vibration.vibrate(duration: 300);
    }
  }
}
