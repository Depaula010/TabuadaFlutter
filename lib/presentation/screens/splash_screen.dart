import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../data/services/hive_service.dart';
import '../../data/services/audio_service.dart';
import 'home_screen.dart';

/// Tela de splash com animação de entrada
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initAndNavigate();
  }

  Future<void> _initAndNavigate() async {
    // Inicia timer mínimo da animação
    final minDelay = Future.delayed(const Duration(seconds: 2));
    
    // Inicializa serviços em ordem (Audio depende de Hive)
    await HiveService.init();
    await AudioService().init();
    
    // Aguarda tempo mínimo da animação
    await minDelay;

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.primaryGradient,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Ícone principal com animação
              Icon(
                Icons.calculate_rounded,
                size: 120,
                color: Colors.white,
              )
                  .animate()
                  .scale(
                    duration: 800.ms,
                    curve: Curves.elasticOut,
                  )
                  .then()
                  .shake(hz: 2, duration: 400.ms),

              const SizedBox(height: 32),

              // Título do app
              Text(
                'Mestres do\nCálculo',
                textAlign: TextAlign.center,
                style: AppTextStyles.h1.copyWith(
                  color: Colors.white,
                  fontSize: 48,
                ),
              )
                  .animate()
                  .fadeIn(delay: 300.ms, duration: 600.ms)
                  .slideY(begin: 0.3, end: 0),

              const SizedBox(height: 16),

              // Subtítulo
              Text(
                'Aprenda tabuada brincando!',
                style: AppTextStyles.body.copyWith(
                  color: Colors.white.withOpacity(0.9),
                ),
              )
                  .animate()
                  .fadeIn(delay: 600.ms, duration: 600.ms),

              const SizedBox(height: 48),

              // Loading indicator
              const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
              )
                  .animate()
                  .fadeIn(delay: 900.ms),
            ],
          ),
        ),
      ),
    );
  }
}
