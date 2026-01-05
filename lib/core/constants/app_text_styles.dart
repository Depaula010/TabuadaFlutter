import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Estilos de texto otimizados para leitura infantil
class AppTextStyles {
  // Fonte base (Roboto é amigável e legível para crianças)
  static TextStyle get _baseStyle => GoogleFonts.poppins(
        color: AppColors.textPrimary,
      );

  // Títulos grandes (Telas principais)
  static TextStyle get h1 => _baseStyle.copyWith(
        fontSize: 40,
        fontWeight: FontWeight.bold,
        height: 1.2,
      );

  // Títulos médios (Seções)
  static TextStyle get h2 => _baseStyle.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        height: 1.3,
      );

  // Títulos pequenos (Cards)
  static TextStyle get h3 => _baseStyle.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 1.4,
      );

  // Corpo de texto
  static TextStyle get body => _baseStyle.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.normal,
        height: 1.5,
      );

  // Números grandes (Questões)
  static TextStyle get numberLarge => GoogleFonts.rubik(
        fontSize: 64,
        fontWeight: FontWeight.bold,
        color: AppColors.primary,
        height: 1.1,
      );

  // Números médios (Opções de resposta)
  static TextStyle get numberMedium => GoogleFonts.rubik(
        fontSize: 36,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.2,
      );

  // Botões
  static TextStyle get button => _baseStyle.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      );

  // Botões grandes (CTAs principais)
  static TextStyle get buttonLarge => _baseStyle.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.8,
      );

  // Legendas e subtextos
  static TextStyle get caption => _baseStyle.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: AppColors.textSecondary,
      );

  // Pontuação e timer
  static TextStyle get score => GoogleFonts.orbitron(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: AppColors.secondary,
        letterSpacing: 1.2,
      );
}
