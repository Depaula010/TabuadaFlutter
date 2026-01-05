# Configurações para AndroidManifest.xml e Play Store

## 📱 AndroidManifest.xml

Cole este conteúdo em `android/app/src/main/AndroidManifest.xml`:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.seudominio.mestres_do_calculo">
    
    <!-- Permissões -->
    <!-- Vibração para feedback tátil -->
    <uses-permission android:name="android.permission.VIBRATE"/>
    
    <!-- Internet apenas para Google Fonts (opcional) -->
    <uses-permission android:name="android.permission.INTERNET"/>
    
    <!-- Declaração de que o app é adequado para crianças -->
    <application
        android:label="Mestres do Cálculo"
        android:name="${applicationName}"
        android:icon="@mipmap/ic_launcher"
        android:usesCleartextTraffic="false"
        android:allowBackup="false"
        android:fullBackupContent="false">
        
        <!-- Atividade principal -->
        <activity
            android:name=".MainActivity"
            android:exported="true"
            android:launchMode="singleTop"
            android:theme="@style/LaunchTheme"
            android:configChanges="orientation|keyboardHidden|keyboard|screenSize|smallestScreenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
            android:hardwareAccelerated="true"
            android:windowSoftInputMode="adjustResize"
            android:screenOrientation="portrait">
            
            <!-- Deep linking intent -->
            <intent-filter>
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>
            
            <!-- Meta-data para splash screen -->
            <meta-data
                android:name="io.flutter.embedding.android.NormalTheme"
                android:resource="@style/NormalTheme"/>
        </activity>
        
        <!-- Meta-data para Designed for Families -->
        <meta-data
            android:name="com.google.android.gms.ads.AD_MANAGER_APP"
            android:value="false"/>
    </application>
</manifest>
```

---

## 🍎 Info.plist (iOS - Futuro)

Se for publicar no iOS, adicione em `ios/Runner/Info.plist`:

```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>Este app não acessa suas fotos</string>

<key>NSCameraUsageDescription</key>
<string>Este app não usa a câmera</string>

<key>NSMicrophoneUsageDescription</key>
<string>Este app não usa o microfone</string>

<key>NSLocationWhenInUseUsageDescription</key>
<string>Este app não acessa sua localização</string>

<!-- Forçar orientação portrait -->
<key>UISupportedInterfaceOrientations</key>
<array>
    <string>UIInterfaceOrientationPortrait</string>
</array>

<!-- Versão do app -->
<key>CFBundleShortVersionString</key>
<string>1.0.0</string>

<key>CFBundleVersion</key>
<string>1</string>

<!-- Nome do app -->
<key>CFBundleDisplayName</key>
<string>Mestres do Cálculo</string>
```

---

## 🌍 Internacionalização (i18n)

### Passo 1: Adicionar dependência

No `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
  intl: ^0.18.1
```

### Passo 2: Configurar no pubspec.yaml

```yaml
flutter:
  generate: true  # Habilita geração automática
```

### Passo 3: Criar arquivo l10n.yaml

Crie `l10n.yaml` na raiz do projeto:

```yaml
arb-dir: lib/l10n
template-arb-file: app_pt.arb
output-localization-file: app_localizations.dart
```

### Passo 4: Criar arquivos ARB

Crie a pasta `lib/l10n/` e os arquivos:

#### `lib/l10n/app_pt.arb` (Português)

```json
{
  "@@locale": "pt",
  "appTitle": "Mestres do Cálculo",
  "play": "JOGAR",
  "settings": "Configurações",
  "trophies": "Troféus",
  "trainingMode": "Treino Livre",
  "timeAttackMode": "Desafio Relâmpago",
  "balloonMode": "Duelo de Balões",
  "chooseTable": "Escolha a Tabuada",
  "question": "Questão",
  "score": "pontos",
  "correct": "Acertos",
  "wrong": "Erros",
  "accuracy": "Precisão",
  "time": "Tempo",
  "playAgain": "JOGAR NOVAMENTE",
  "mainMenu": "Menu Principal",
  "musicVolume": "Música de Fundo",
  "sfxVolume": "Efeitos Sonoros",
  "vibration": "Vibração ao tocar",
  "clearProgress": "Limpar Todo Progresso",
  "about": "Sobre",
  "version": "Versão",
  "parentalGateTitle": "Verificação para Adultos",
  "parentalGateMessage": "Para acessar esta área, resolva a conta abaixo:",
  "cancel": "Cancelar",
  "confirm": "Confirmar",
  "incorrectAnswer": "❌ Resposta incorreta",
  "progressCleared": "✅ Progresso apagado com sucesso!"
}
```

#### `lib/l10n/app_en.arb` (Inglês)

```json
{
  "@@locale": "en",
  "appTitle": "Math Masters",
  "play": "PLAY",
  "settings": "Settings",
  "trophies": "Trophies",
  "trainingMode": "Free Training",
  "timeAttackMode": "Lightning Challenge",
  "balloonMode": "Balloon Duel",
  "chooseTable": "Choose the Table",
  "question": "Question",
  "score": "points",
  "correct": "Correct",
  "wrong": "Wrong",
  "accuracy": "Accuracy",
  "time": "Time",
  "playAgain": "PLAY AGAIN",
  "mainMenu": "Main Menu",
  "musicVolume": "Background Music",
  "sfxVolume": "Sound Effects",
  "vibration": "Vibration on touch",
  "clearProgress": "Clear All Progress",
  "about": "About",
  "version": "Version",
  "parentalGateTitle": "Adult Verification",
  "parentalGateMessage": "To access this area, solve the math problem below:",
  "cancel": "Cancel",
  "confirm": "Confirm",
  "incorrectAnswer": "❌ Incorrect answer",
  "progressCleared": "✅ Progress cleared successfully!"
}
```

### Passo 5: Atualizar main.dart

```dart
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MestresDoCalculo extends StatelessWidget {
  const MestresDoCalculo({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [...],
      child: MaterialApp(
        title: 'Mestres do Cálculo',
        
        // Localização
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('pt', 'BR'), // Português
          Locale('en', 'US'), // Inglês
        ],
        
        debugShowCheckedModeBanner: false,
        theme: ThemeData(...),
        home: const SplashScreen(),
      ),
    );
  }
}
```

### Passo 6: Usar nos Widgets

```dart
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// No build:
final l10n = AppLocalizations.of(context)!;

Text(l10n.appTitle)  // Em vez de 'Mestres do Cálculo'
Text(l10n.play)      // Em vez de 'JOGAR'
```

### Passo 7: Gerar Traduções

```bash
flutter gen-l10n
# ou
flutter pub get  # Gera automaticamente se flutter.generate: true
```

---

## 📋 Checklist de Preparação Play Store

### Configurações Técnicas

- [ ] **ApplicationId** único em build.gradle:
  ```gradle
  defaultConfig {
      applicationId "com.seudominio.mestres_do_calculo"
      minSdkVersion 21
      targetSdkVersion 33
      versionCode 1
      versionName "1.0.0"
  }
  ```

- [ ] **Ícone adaptativo** gerado (1024x1024)
- [ ] **Permissões** corretamente declaradas
- [ ] **Orientação portrait** forçada
- [ ] **Proguard** configurado (opcional mas recomendado)

### Assets Play Store

- [ ] **Screenshots** (mínimo 2, máximo 8):
  - Tamanho: 1080x1920 (16:9)
  - Formato: PNG ou JPG
  
- [ ] **Feature Graphic** (banner):
  - Tamanho: 1024x500
  - Formato: PNG ou JPG

- [ ] **Ícone de alta resolução**:
  - Tamanho: 512x512
  - Formato: PNG

### Textos

- [ ] **Título**: "Mestres do Cálculo - Tabuada" (máx 30 caracteres)
- [ ] **Descrição curta** (máx 80 caracteres)
- [ ] **Descrição completa** (máx 4000 caracteres)
- [ ] **Categoria**: Educação > Matemática
- [ ] **Classificação etária**: Designed for Families (6-12 anos)

### Legal

- [ ] **Política de Privacidade** hospedada (URL pública)
  - Sugestão: GitHub Pages, Google Sites, ou WordPress
  
- [ ] **Declaração de conformidade**:
  - ✅ COPPA compliant
  - ✅ Sem coleta de dados
  - ✅ Sem anúncios
  - ✅ Offline-first

---

## 🔐 Assinatura do APK/AAB

### Criar keystore

```bash
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

### Configurar key.properties

Crie `android/key.properties`:

```properties
storePassword=sua-senha-secreta
keyPassword=sua-senha-secreta
keyAlias=upload
storeFile=/caminho/para/upload-keystore.jks
```

### Atualizar build.gradle

Em `android/app/build.gradle`:

```gradle
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    ...
    
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile file(keystoreProperties['storeFile'])
            storePassword keystoreProperties['storePassword']
        }
    }
    
    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            shrinkResources true
        }
    }
}
```

### Build Final

```bash
flutter build appbundle --release --obfuscate --split-debug-info=build/symbols
```

O arquivo estará em: `build/app/outputs/bundle/release/app-release.aab`

---

## 🌐 Hospedar Política de Privacidade

### Opção 1: GitHub Pages (Grátis e Fácil)

1. Crie repositório público no GitHub
2. Adicione `privacy_policy.md` (ou converta para HTML)
3. Vá em Settings > Pages
4. Escolha branch `main` e pasta `/` (root)
5. Aguarde 1 minuto
6. URL estará em: `https://seu-usuario.github.io/repo/privacy_policy.md`

### Opção 2: Google Sites (Visual)

1. Acesse https://sites.google.com/
2. Crie novo site
3. Cole o conteúdo da política
4. Publique
5. Use a URL gerada

### Opção 3: HTML Simples

Converta o Markdown para HTML e hospede em qualquer servidor:

```bash
# Usando pandoc (se tiver instalado)
pandoc privacy_policy.md -o privacy_policy.html

# Ou use um conversor online:
# https://markdowntohtml.com/
```

---

## ✅ Checklist Final Antes do Upload

- [ ] Testado em dispositivo real Android
- [ ] Testado em diferentes tamanhos de tela
- [ ] Sem crashes ou bugs críticos
- [ ] Todos os sons funcionando
- [ ] Vibração funcionando (se dispositivo suportar)
- [ ] Progresso salva e carrega corretamente
- [ ] Troféus desbloqueiam nas condições corretas
- [ ] Parental Gate funcionando
- [ ] Configurações salvam preferências
- [ ] Build em release sem warnings críticos
- [ ] Política de Privacidade acessível via URL pública
- [ ] Screenshots capturados e editados
- [ ] Descrição revisada (português E inglês se i18n)

---

## 📤 Upload na Play Console

1. Acesse https://play.google.com/console
2. Crie novo aplicativo
3. Preencha dados básicos
4. **Categoria**: Educação
5. **Público-alvo**: Designed for Families (6-12 anos)
6. **Conteúdo**: Sem anúncios, sem compras
7. **Upload AAB**: `app-release.aab`
8. Preencha questionário de privacidade
9. Adicione screenshots e textos
10. **Revisar e Publicar**

**Tempo de aprovação**: Normalmente 1-3 dias.

---

**Pronto! Agora o app está 100% preparado para a Play Store! 🎉**
