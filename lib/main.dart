import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'data/services/hive_service.dart';
import 'data/services/audio_service.dart';
import 'logic/providers/game_provider.dart';
import 'logic/providers/progress_provider.dart';
import 'presentation/screens/splash_screen.dart';
import 'core/constants/app_colors.dart';

void main() async {
  // Garante que o Flutter esteja inicializado
  WidgetsFlutterBinding.ensureInitialized();

  // Força orientação portrait (ideal para crianças)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Inicializa o Hive (banco de dados local)
  await HiveService.init();

  // Inicializa o serviço de áudio (pré-carrega sons)
  await AudioService().init();

  // Configura a barra de status e navegação
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: AppColors.background,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const MestresDoCalculo());
}

class MestresDoCalculo extends StatelessWidget {
  const MestresDoCalculo({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GameProvider()),
        ChangeNotifierProvider(create: (_) => ProgressProvider()),
      ],
      child: MaterialApp(
        title: 'Mestres do Cálculo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            brightness: Brightness.light,
          ),
          scaffoldBackgroundColor: AppColors.background,
          // Define a fonte padrão como segura para caso Google Fonts falhe
          fontFamily: 'Roboto',
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
