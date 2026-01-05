# 🎯 Guia de Próximos Passos - Mestres do Cálculo

## ✅ O Que Já Foi Implementado

### Arquitetura Base (100%)
- [x] Estrutura de diretórios completa
- [x] Configuração do pubspec.yaml com todas as dependências
- [x] Sistema de cores e tipografia premium
- [x] Modelos de dados (Question, Trophy, GameProgress)
- [x] Adaptadores Hive gerados e funcionando

### Lógica do Jogo (100%)
- [x] **QuestionGenerator**: Motor de geração de questões com alternativas inteligentes
- [x] **GameProvider**: Gerenciamento completo de estado do jogo
- [x] **ProgressProvider**: Tracking de progresso e troféus
- [x] **HiveService**: Persistência local otimizada
- [x] Sistema de pontuação com bônus de sequência
- [x] Timer para modo Time Attack
- [x] Sistema de troféus com 5 conquistas padrão

### UI/UX (90%)
- [x] Splash Screen animada
- [x] Home Screen com estatísticas globais
- [x] Tela de seleção de modos (3 modos)
- [x] Tela de seleção de dificuldade (tabuadas 1-10)
- [x] Game Screen com feedback visual rico
- [x] Result Screen celebratória
- [x] Tela de troféus
- [x] Widgets customizados (CustomButton, AnswerOption)
- [x] Animações com flutter_animate
- [x] Confetti para celebrações
- [x] Haptic feedback

### Testes (70%)
- [x] 11 testes unitários para QuestionGenerator (TODOS PASSANDO ✅)
- [ ] Testes de widget pendentes
- [ ] Testes de integração pendentes

---

## 🚧 Tarefas Pendentes (Prioridade)

### FASE 1 - Sons e Configurações (Essencial)

#### 1.1 Integração Completa de Áudio
**Arquivo**: `lib/data/services/audio_service.dart`

```dart
// Já criado mas com TODOs. Próximos passos:
```

**Tarefas**:
1. Baixar assets de áudio gratuitos:
   - **Música de fundo**: [Incompetech](https://incompetech.com/music/), [Bensound](https://www.bensound.com/)
   - **SFX**: [Freesound](https://freesound.org/), [Zapsplat](https://www.zapsplat.com/)

2. Adicionar arquivos em:
   - `assets/sounds/music/background.mp3`
   - `assets/sounds/sfx/success.mp3`
   - `assets/sounds/sfx/error.mp3`
   - `assets/sounds/sfx/coin.mp3`
   - `assets/sounds/sfx/trophy.mp3`

3. Descomentar código no `AudioService` e integrar:

```dart
// Em game_screen.dart, adicionar ao _handleAnswer:
if (isCorrect) {
  HapticHelper.success();
  AudioService().playCorrectSound();
  AudioService().playCoinSound();
  _confettiController.play();
} else {
  HapticHelper.error();
  AudioService().playWrongSound();
}
```

4. Adicionar música de fundo no `main.dart`:

```dart
void main() async {
  // ... código existente
  await AudioService().init();
  AudioService().playBackgroundMusic();
  runApp(const MestresDoCalculo());
}
```

**Tempo estimado**: 2-3 horas

---

#### 1.2 Tela de Configurações com Parental Gate
**Criar**: `lib/presentation/screens/settings_screen.dart`

**Funcionalidades**:
- [ ] Controle de volume (música e SFX) com sliders
- [ ] Toggle de vibração
- [ ] Botão "Limpar Progresso" (com Parental Gate)
- [ ] Sobre/Créditos
- [ ] Links para redes sociais (com Parental Gate)

**Implementar Parental Gate**:
**Arquivo**: `lib/core/utils/parental_gate.dart`

```dart
import 'package:flutter/material.dart';
import 'dart:math';

class ParentalGate {
  static Future<bool> show(BuildContext context) async {
    final random = Random();
    final a = random.nextInt(10) + 1;
    final b = random.nextInt(10) + 1;
    final correctAnswer = a + b;

    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Verificação para Adultos'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Para continuar, resolva:'),
            SizedBox(height: 16),
            Text(
              '$a + $b = ?',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Resposta'),
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
            child: Text('Cancelar'),
          ),
        ],
      ),
    ) ?? false;
  }
}
```

**Integrar na HomeScreen**:

```dart
// No botão de configurações:
onPressed: () async {
  final allowed = await ParentalGate.show(context);
  if (allowed) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => SettingsScreen()),
    );
  }
},
```

**Tempo estimado**: 3-4 horas

---

### FASE 2 - Polimento Visual

#### 2.1 Adicionar Assets Visuais
1. **Personagem mascote**:
   - Baixar em: [Freepik](https://www.freepik.com/), [Flaticon](https://www.flaticon.com/)
   - Usar formatos: PNG com transparência ou SVG
   - Adicionar em `assets/images/character/`
   - Estados: happy.png, sad.png, excited.png

2. **Animações Lottie**:
   - Baixar em: [LottieFiles](https://lottiefiles.com/)
   - Buscar por: "trophy", "celebration", "confetti", "star"
   - Adicionar em `assets/animations/lottie/`

3. **Integrar no código**:

```dart
// Em home_screen.dart, substituir o Icon por Lottie:
import 'package:lottie/lottie.dart';
import '../../core/constants/app_assets.dart';

// Substituir:
Icon(Icons.emoji_events, size: 140, color: AppColors.secondary)

// Por:
Lottie.asset(
  AppAssets.lottieTrophy,
  width: 200,
  height: 200,
  repeat: true,
)
```

**Tempo estimado**: 2-3 horas

---

#### 2.2 Melhorias de Animação
**Arquivo**: `lib/presentation/screens/game_screen.dart`

Adicionar shake effect ao errar:

```dart
// No _handleAnswer quando isCorrect == false:
if (!isCorrect) {
  HapticHelper.error();
  AudioService().playWrongSound();
  
  // Adicionar shake
  setState(() {
    // Usar AnimationController para shake
  });
}
```

**Tempo estimado**: 1-2 horas

---

### FASE 3 - Modo Duelo de Balões (Opcional)

#### 3.1 Implementar Física de Balões
**Criar**: `lib/presentation/screens/balloon_duel_screen.dart`

Usar pacote `flutter_physics` ou implementação customizada com `AnimationController`.

**Mecânica**:
1. Balões flutuam na tela com respostas
2. Criança toca no balão correto
3. Balão estoura com animação
4. Feedback similar ao modo normal

**Tempo estimado**: 8-10 horas

---

### FASE 4 - Preparação para Play Store

#### 4.1 Configurar Ícone do App
**Usar**: `flutter_launcher_icons`

1. Adicionar ao `pubspec.yaml`:
```yaml
dev_dependencies:
  flutter_launcher_icons: ^0.13.1

flutter_launcher_icons:
  android: true
  ios: false
  image_path: "assets/icon/icon.png"
  adaptive_icon_background: "#5B7FFF"
  adaptive_icon_foreground: "assets/icon/foreground.png"
```

2. Criar ícone 1024x1024px
3. Executar: `flutter pub run flutter_launcher_icons`

**Tempo estimado**: 1-2 horas

---

#### 4.2 Criar Política de Privacidade
**Criar**: `privacy_policy.md`

Hospedar em GitHub Pages ou criar página simples:

```html
<!DOCTYPE html>
<html>
<head>
  <title>Política de Privacidade - Mestres do Cálculo</title>
</head>
<body>
  <h1>Política de Privacidade</h1>
  <p><strong>Última atualização:</strong> [DATA]</p>
  
  <h2>Coleta de Dados</h2>
  <p>Este aplicativo NÃO coleta, armazena ou compartilha dados pessoais.</p>
  
  <h2>Armazenamento Local</h2>
  <p>Todo o progresso é salvo localmente no dispositivo usando Hive.</p>
  
  <h2>Permissões</h2>
  <ul>
    <li><strong>Vibração:</strong> Apenas para feedback tátil.</li>
    <li><strong>Internet:</strong> Apenas para Google Fonts (opcional).</li>
  </ul>
  
  <h2>Contato</h2>
  <p>Email: seuemail@dominio.com</p>
</body>
</html>
```

URL para Play Store: `https://seu-dominio.com/privacy-policy.html`

**Tempo estimado**: 1 hora

---

#### 4.3 Build e Publicação
1. **Configurar assinatura** (Android):
   - Seguir: [Guia oficial Flutter](https://docs.flutter.dev/deployment/android)
   - Criar keystore
   - Configurar `key.properties`

2. **Build AAB**:
```bash
flutter build appbundle --release
```

3. **Google Play Console**:
   - Criar aplicativo
   - Categoria: "Designed for Families"
   - Faixa etária: 6-12 anos
   - Upload AAB
   - Adicionar screenshots (6-8 imagens)
   - Adicionar descrição otimizada

**Tempo estimado**: 4-6 horas

---

## 📝 Checklist Final de Lançamento

### Funcional
- [ ] Todos os 3 modos jogáveis (Treino, Time Attack, Duelo de Balões)
- [ ] Som funcionando (música + SFX)
- [ ] Progresso salva e carrega corretamente
- [ ] Troféus desbloqueiam nas condições corretas
- [ ] App não trava em nenhuma condição

### UX/UI
- [ ] Todas as animações suaves
- [ ] Cores acessíveis (contraste adequado)
- [ ] Textos legíveis em todos os tamanhos de tela
- [ ] Ícones e imagens de alta qualidade

### Conformidade
- [ ] Parental Gate implementado
- [ ] Política de Privacidade criada e hospedada
- [ ] Sem coleta de dados
- [ ] Sem anúncios
- [ ] Sem compras in-app

### Técnico
- [ ] Build em release sem warnings
- [ ] App < 50MB
- [ ] Testes unitários passando
- [ ] Performance 60fps em dispositivos médios
- [ ] Compatibilidade Android 5.0+ (API 21+)

---

## 🎨 Melhorias Futuras (Pós-Lançamento)

### V2.0 - Recursos Avançados
- [ ] Modo multiplayer local (2 jogadores)
- [ ] Personagens desbloqueáveis
- [ ] Temas visuais (espaço, fundo do mar, floresta)
- [ ] Minigames bônus
- [ ] Estatísticas detalhadas (gráficos)

### V2.1 - Internacionalização
- [ ] Suporte para inglês
- [ ] Suporte para espanhol
- [ ] Números falados (Text-to-Speech)

### V3.0 - Expansão de Conteúdo
- [ ] Outras operações (adição, subtração, divisão)
- [ ] Desafios diários
- [ ] Ranking familiar (sem servidor)
- [ ] Modo história com progressão

---

## 📊 Métricas de Sucesso

Após lançamento, monitore:
- Downloads (meta: 1000 no primeiro mês)
- Avaliações (meta: 4.5+ estrelas)
- Retenção (meta: 50% D7)
- Crashes (meta: < 1%)

---

## 🤝 Contribuindo

Se este projeto for open-source:
1. Fork o repositório
2. Crie uma branch (`git checkout -b feature/nova-funcionalidade`)
3. Commit (`git commit -m 'Adiciona nova funcionalidade'`)
4. Push (`git push origin feature/nova-funcionalidade`)
5. Abra um Pull Request

---

**Boa sorte com o desenvolvimento! 🚀**
