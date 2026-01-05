import 'package:flutter/material.dart';

/// Paleta de cores vibrantes e acessíveis para crianças
class AppColors {
  // Cores Primárias
  static const Color primary = Color(0xFF5B7FFF); // Azul vibrante
  static const Color primaryDark = Color(0xFF3D5FDD);
  static const Color primaryLight = Color(0xFF8FA9FF);

  // Cores Secundárias
  static const Color secondary = Color(0xFFFFD93D); // Amarelo alegre
  static const Color secondaryDark = Color(0xFFFFB800);
  static const Color secondaryLight = Color(0xFFFFE87C);

  // Cores de Acento
  static const Color accent = Color(0xFFAA5FFF); // Roxo mágico
  static const Color accentLight = Color(0xFFD0A8FF);

  // Feedback Visual
  static const Color success = Color(0xFF4CAF50); // Verde
  static const Color successLight = Color(0xFF81C784);
  static const Color error = Color(0xFFFF6B6B); // Vermelho suave
  static const Color errorLight = Color(0xFFFF9E9E);
  static const Color warning = Color(0xFFFF9800);

  // Neutras
  static const Color background = Color(0xFFF5F7FA);
  static const Color cardBackground = Colors.white;
  static const Color textPrimary = Color(0xFF2C3E50);
  static const Color textSecondary = Color(0xFF7F8C8D);
  static const Color divider = Color(0xFFE0E0E0);

  // Gradientes
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondary, secondaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [accent, accentLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [success, successLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Gradiente de fundo
  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFFE3F2FD), Color(0xFFFFF9C4)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
