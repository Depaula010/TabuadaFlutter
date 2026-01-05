# 🎯 Dicas de Refinamento e Otimização

## ⚠️ Warnings do Flutter Analyze

O comando `flutter analyze` reportou **30 issues** (não-críticos). Aqui está como resolvê-los:

### 1. deprecated_member_use

**Problema**: Algumas APIs estão marcadas como deprecated.

**Soluções**:

#### WillPopScope (game_screen.dart, result_screen.dart)
```dart
// ❌ Deprecated (mas ainda funciona)
WillPopScope(
  onWillPop: () async { ... },
  child: Scaffold(...),
)

// ✅ Novo (Flutter 3.12+)
PopScope(
  canPop: false,
  onPopInvoked: (bool didPop) async {
    if (!didPop) {
      // Lógica de confirmação
    }
  },
  child: Scaffold(...),
)
```

#### Outros deprecations comuns
- `TextTheme.headline1` → `TextTheme.displayLarge`
- `Theme.of(context).accentColor` → `Theme.of(context).colorScheme.secondary`

**Ação recomendada**: Não é urgente. Funciona perfeitamente, mas pode atualizar gradualmente.

---

## 🚀 Otimizações de Performance

### 1. Usar `const` em Mais Lugares

```dart
// ❌ Antes
Widget build(BuildContext context) {
  return SizedBox(height: 20);
}

// ✅ Depois
Widget build(BuildContext context) {
  return const SizedBox(height: 20);
}
```

**Impacto**: Reduz reconstruções desnecessárias de widgets.

**Onde aplicar**:
- Todos os `SizedBox` com valores fixos
- `Icon`, `Text` com valores constantes
- Padding com valores fixos

---

### 2. Otimizar Animações

**Adicionar em game_screen.dart**:

```dart
@override
Widget build(BuildContext context) {
  return RepaintBoundary( // Isola repaint apenas neste widget
    child: AnimatedContainer(...),
  );
}
```

**Impacto**: Evita repaint de widgets vizinhos durante animações.

---

### 3. Cache de Imagens (quando adicionar assets)

```dart
// Em app inicialização
@override
void initState() {
  super.initState();
  precacheImage(AssetImage(AppAssets.characterHappy), context);
  precacheImage(AssetImage(AppAssets.backgroundMain), context);
}
```

**Impacto**: Carrega imagens antes de serem necessárias, evita lag.

---

### 4. Lazy Loading de Lottie

```dart
// ✅ Carregue Lottie apenas quando necessário
FutureBuilder(
  future: AssetBundle.load(AppAssets.lottieTrophy),
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      return Lottie.asset(AppAssets.lottieTrophy);
    }
    return CircularProgressIndicator();
  },
)
```

---

## 🎨 Melhorias de UX

### 1. Adicionar Loading States

**Em difficulty_screen.dart**:

```dart
Consumer<ProgressProvider>(
  builder: (context, provider, _) {
    if (provider.allProgress.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }
    return GridView.builder(...);
  },
)
```

---

### 2. Error Boundary

**Criar**: `lib/core/utils/error_handler.dart`

```dart
class ErrorHandler {
  static void handleError(Object error, StackTrace stack) {
    // Log em produção
    if (kReleaseMode) {
      // Enviar para Firebase Crashlytics (opcional)
      print('Error: $error');
    } else {
      // Mostrar em debug
      debugPrint('Error: $error\n$stack');
    }
  }
}
```

**Usar no main.dart**:

```dart
void main() async {
  FlutterError.onError = (details) {
    ErrorHandler.handleError(details.exception, details.stack!);
  };
  
  runZonedGuarded(() async {
    // ... código existente
    runApp(const MestresDoCalculo());
  }, (error, stack) {
    ErrorHandler.handleError(error, stack);
  });
}
```

---

### 3. Feedback de Loading em Navegação

```dart
// Ao iniciar jogo
showDialog(
  context: context,
  barrierDismissible: false,
  builder: (_) => Center(
    child: CircularProgressIndicator(),
  ),
);

await gameProvider.startGame(...);

Navigator.pop(context); // Remove loading
Navigator.push(...); // Vai para game
```

---

## 🧪 Expandir Testes

### Widget Test Exemplo

**Criar**: `test/widget/custom_button_test.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mestres_do_calculo/presentation/widgets/custom_button.dart';

void main() {
  testWidgets('CustomButton deve executar onPressed ao tocar', (tester) async {
    bool pressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomButton(
            text: 'Teste',
            onPressed: () => pressed = true,
          ),
        ),
      ),
    );

    await tester.tap(find.text('Teste'));
    await tester.pump();

    expect(pressed, isTrue);
  });

  testWidgets('CustomButton não deve executar se disabled', (tester) async {
    bool pressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomButton(
            text: 'Teste',
            onPressed: () => pressed = true,
            isDisabled: true,
          ),
        ),
      ),
    );

    await tester.tap(find.text('Teste'));
    await tester.pump();

    expect(pressed, isFalse);
  });
}
```

**Executar**: `flutter test test/widget/`

---

## 📱 Responsividade

### 1. Adaptar para Tablets

```dart
// Criar helper
class ScreenUtils {
  static bool isTablet(BuildContext context) {
    final shortestSide = MediaQuery.of(context).size.shortestSide;
    return shortestSide >= 600;
  }
}

// Usar no código
final fontSize = ScreenUtils.isTablet(context) ? 48.0 : 36.0;
```

---

### 2. Safe Area Completo

```dart
Scaffold(
  body: SafeArea(
    minimum: EdgeInsets.all(8), // Margem mínima
    child: ...,
  ),
)
```

---

## 🔊 Otimizar Áudio

### 1. Pré-carregar Sons

**No AudioService.init()**:

```dart
Future<void> init() async {
  if (_isInitialized) return;

  // Pré-carrega SFX mais usados
  await _sfxPlayer.setSource(AssetSource('sounds/sfx/success.mp3'));
  await _sfxPlayer.setSource(AssetSource('sounds/sfx/error.mp3'));

  _isInitialized = true;
}
```

---

### 2. Pool de Players SFX

```dart
class AudioService {
  final List<AudioPlayer> _sfxPool = [];

  Future<void> init() async {
    // Cria pool de 3 players para SFX simultâneos
    for (int i = 0; i < 3; i++) {
      _sfxPool.add(AudioPlayer());
    }
  }

  Future<void> playCorrectSound() async {
    final player = _sfxPool.firstWhere(
      (p) => p.state != PlayerState.playing,
      orElse: () => _sfxPool.first,
    );
    await player.play(AssetSource('sounds/sfx/success.mp3'));
  }
}
```

**Impacto**: Permite múltiplos sons simultâneos sem corte.

---

## 🎯 Acessibilidade

### 1. Adicionar Semantics

```dart
CustomButton(
  text: 'JOGAR',
  onPressed: () { ... },
  child: Semantics(
    label: 'Botão para iniciar o jogo',
    button: true,
    child: ...,
  ),
)
```

---

### 2. Suporte a Modo Alto Contraste

```dart
// Em app_colors.dart
static Color getTextColor(BuildContext context) {
  final isHighContrast = MediaQuery.of(context).highContrast;
  return isHighContrast ? Colors.black : textPrimary;
}
```

---

### 3. Tamanhos de Fonte Escaláveis

```dart
Text(
  'Título',
  style: AppTextStyles.h1.copyWith(
    fontSize: 40 * MediaQuery.of(context).textScaleFactor,
  ),
)
```

---

## 🐛 Debug Helpers

### 1. Logger Customizado

**Criar**: `lib/core/utils/logger.dart`

```dart
class Logger {
  static void log(String message, {String? tag}) {
    if (kDebugMode) {
      print('[${tag ?? 'APP'}] $message');
    }
  }

  static void logGameEvent(String event, {Map<String, dynamic>? data}) {
    log('GAME EVENT: $event ${data ?? ''}', tag: 'GAME');
  }
}
```

**Usar**:

```dart
// Em game_provider.dart
Logger.logGameEvent('Question answered', data: {
  'correct': isCorrect,
  'tableNumber': _currentTableNumber,
  'score': _score,
});
```

---

### 2. Performance Overlay (Debug)

**Em main.dart**:

```dart
MaterialApp(
  showPerformanceOverlay: kDebugMode, // Mostra FPS em debug
  // ...
)
```

---

## 📦 Reduzir Tamanho do APK/AAB

### 1. Remover Assets Não Usados

```bash
# Antes do build
flutter clean
flutter pub get
```

---

### 2. Comprimir Imagens

Use ferramentas:
- **TinyPNG**: https://tinypng.com/
- **ImageOptim** (Mac)
- **PngOptimizer** (Windows)

Alvo: <100KB por imagem

---

### 3. Usar Formatos Modernos

- PNG → **WebP** (menor e com transparência)
- MP3 → **OGG** (menor para loops)

```yaml
# pubspec.yaml
assets:
  - assets/images/character/ # .webp
  - assets/sounds/music/ # .ogg
```

---

### 4. Proguard (Android)

**android/app/build.gradle**:

```gradle
buildTypes {
  release {
    shrinkResources true
    minifyEnabled true
    proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
  }
}
```

**Impacto**: Reduz tamanho do APK em ~30-40%

---

## 🚨 Crashlytics (Opcional, Pós-Lançamento)

### Configurar Firebase Crashlytics

```yaml
# pubspec.yaml
dependencies:
  firebase_core: ^2.24.0
  firebase_crashlytics: ^3.4.0
```

```dart
// main.dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  
  runApp(const MestresDoCalculo());
}
```

**Benefício**: Recebe relatórios de crashes em produção.

---

## 💾 Backup e Restore de Progresso

### Implementar Export/Import

**Criar**: `lib/data/services/backup_service.dart`

```dart
class BackupService {
  static Future<String> exportProgress() async {
    final allProgress = HiveService.getAllProgress();
    final json = jsonEncode(allProgress);
    return base64Encode(utf8.encode(json));
  }

  static Future<void> importProgress(String base64Data) async {
    final json = utf8.decode(base64Decode(base64Data));
    final Map<String, dynamic> data = jsonDecode(json);
    
    // Restaura progresso
    for (var entry in data.entries) {
      // Lógica de restore
    }
  }
}
```

**UX**: Adicionar em SettingsScreen botões "Fazer Backup" e "Restaurar".

---

## 📊 Analytics (Opcional)

### Google Analytics for Firebase

```dart
// Rastrear eventos sem violar privacidade
FirebaseAnalytics.instance.logEvent(
  name: 'game_completed',
  parameters: {
    'table_number': tableNumber,
    'score': score,
    'mode': gameMode.toString(),
  },
);
```

**Importante**: Só rastrear eventos anônimos, sem dados pessoais.

---

## 🎨 Modo Escuro (Futuro)

### Preparar Infraestrutura

```dart
// app_colors.dart
class AppColors {
  static Color background(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? Color(0xFF1A1A2E) : Color(0xFFF5F7FA);
  }
}
```

```dart
// main.dart
MaterialApp(
  themeMode: ThemeMode.system, // Respeita tema do sistema
  darkTheme: ThemeData.dark().copyWith(...),
  // ...
)
```

---

## 🔒 Segurança

### 1. Obfuscate Code (Release)

```bash
flutter build appbundle --obfuscate --split-debug-info=build/app/outputs/symbols
```

**Benefício**: Dificulta engenharia reversa.

---

### 2. Validar Integridade de Dados

```dart
// Ao carregar progresso
GameProgress? getProgress(int tableNumber) {
  final progress = _progressBox.get('table_$tableNumber');
  
  if (progress != null && progress.tableNumber != tableNumber) {
    // Dados corrompidos, retorna null
    return null;
  }
  
  return progress;
}
```

---

## 📝 Checklist Final de Refinamento

### Antes do Build de Produção

- [ ] Remover todos os `print()` e `debugPrint()` de produção
- [ ] Verificar que não há TODOs críticos
- [ ] Testar em dispositivo real (não só emulador)
- [ ] Testar com diferentes tamanhos de tela
- [ ] Testar com fontes grandes do sistema
- [ ] Testar interrupt (chamada telefônica durante jogo)
- [ ] Verificar que progresso persiste após force-close
- [ ] Testar com internet desconectada
- [ ] Verificar orientação portrait forçada
- [ ] Revisar termos de uso e política de privacidade

---

## 🎯 Conclusão

Estas otimizações são **incrementais**. O app já está funcional e bem estruturado.

**Priorize**:
1. Sons (impacto UX alto)
2. Testes de widget (qualidade)
3. Redução de APK (Play Store)

O resto pode vir em atualizações pós-lançamento (v1.1, v1.2, etc).

---

**Boa otimização! 🚀**
