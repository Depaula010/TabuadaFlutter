# 🎮 Mestres do Cálculo

> **App educativo de tabuada para crianças de 6 a 12 anos**

Um aplicativo Flutter gamificado para ensinar tabuada de forma divertida e interativa, sem necessidade de backend, cumprindo as diretrizes "Designed for Families" da Google Play Store.

---

## 📋 Visão Geral do Projeto

### 🎯 Características Principais

- **3 Modos de Jogo:**
  - 🎓 **Treino Livre**: Aprenda sem pressão de tempo
  - ⚡ **Desafio Relâmpago**: 60 segundos de ação intensa
  - 🎈 **Duelo de Balões**: (Em desenvolvimento) Estoure os balões com respostas corretas

- **Sistema de Gamificação:**
  - ⭐ Sistema de estrelas (0-3 por tabuada)
  - 🏆 Troféus desbloqueáveis
  - 📊 Tracking de progresso por tabuada
  - 🎯 Sistema de pontuação com bônus de sequência

- **UX/UI Infantil:**
  - 🎨 Paleta de cores vibrantes e acessíveis
  - ✨ Animações suaves e micro-interações
  - 🎭 Feedback visual rico (cores, confetti, animações)
  - 📳 Haptic feedback (vibração)
  - 🔊 Suporte para áudio (música e efeitos sonoros)

---

## 🏗️ Arquitetura

### Stack Técnica

- **Framework**: Flutter 3.0+
- **Gerenciamento de Estado**: Provider
- **Persistência Local**: Hive (alta performance)
- **Animações**: flutter_animate + Lottie + Confetti
- **Áudio**: audioplayers
- **Feedback Tátil**: vibration
- **Tipografia**: google_fonts (Poppins, Rubik, Orbitron)

### Estrutura de Diretórios

\`\`\`
lib/
├── core/                  # Constantes e utilitários
│   ├── constants/        # Cores, estilos, assets
│   └── utils/            # Helpers (haptic, parental gate)
├── data/                 # Camada de dados
│   ├── models/          # Modelos (Question, Trophy, GameProgress)
│   └── services/        # Serviços (Hive, Audio)
├── logic/                # Lógica de negócio
│   ├── providers/       # Provider (Game, Progress)
│   └── game_engine/     # Motor do jogo (gerador de questões)
└── presentation/         # UI
    ├── screens/         # Telas
    └── widgets/         # Widgets reutilizáveis
\`\`\`

---

## 🧠 Lógica de Geração de Questões

O **QuestionGenerator** usa um algoritmo inteligente para criar alternativas incorretas plausíveis:

### Estratégias de Distração:

1. **Correto ± 1**: Simula erros de contagem
2. **Tabuada Adjacente**: X × (Y ± 1)
3. **Confusão de Operação**: X + Y (adição em vez de multiplicação)
4. **Variação Aleatória**: Correto ± valor pequeno aleatório

**Exemplo para 7 × 8 = 56:**
- ❌ 55 (56 - 1)
- ❌ 49 (7 × 7, tabuada anterior)
- ❌ 15 (7 + 8, confusão)

---

## 🚀 Como Rodar o Projeto

### Pré-requisitos

\`\`\`bash
flutter --version  # Flutter 3.0.0 ou superior
\`\`\`

### Instalação

1. **Clone o repositório**
\`\`\`bash
git clone <repo-url>
cd TabuadaFlutter
\`\`\`

2. **Instale as dependências**
\`\`\`bash
flutter pub get
\`\`\`

3. **Gere os adaptadores Hive**
\`\`\`bash
flutter pub run build_runner build --delete-conflicting-outputs
\`\`\`

4. **Execute o app**
\`\`\`bash
flutter run
\`\`\`

### Assets Necessários

⚠️ **IMPORTANTE**: Adicione os seguintes assets nas pastas correspondentes:

#### Imagens
\`\`\`
assets/images/character/     # Personagem mascote
assets/images/backgrounds/   # Fundos decorativos
\`\`\`

#### Sons
\`\`\`
assets/sounds/music/         # Música de fundo (loop)
assets/sounds/sfx/           # Efeitos sonoros
  ├── success.mp3           # Som de acerto
  ├── error.mp3             # Som de erro
  └── coin.mp3              # Som de pontos
\`\`\`

#### Animações
\`\`\`
assets/animations/lottie/    # Animações Lottie (.json)
  ├── trophy.json           # Animação de troféu
  └── celebration.json      # Celebração
\`\`\`

**Recursos gratuitos recomendados:**
- Imagens: [Freepik](https://www.freepik.com/), [Flaticon](https://www.flaticon.com/)
- Sons: [Freesound](https://freesound.org/), [Mixkit](https://mixkit.co/)
- Lottie: [LottieFiles](https://lottiefiles.com/)

---

## 🧪 Testes

### Testes de Unidade

\`\`\`bash
flutter test test/unit/question_generator_test.dart
\`\`\`

### Testes de Widget

\`\`\`bash
flutter test test/widget/game_screen_test.dart
\`\`\`

### Teste Manual

- [ ] Todas as tabuadas de 1 a 10
- [ ] Modo Time Attack com 60s
- [ ] Sistema de troféus desbloqueia corretamente
- [ ] Vibração funciona em dispositivos compatíveis
- [ ] Progresso persiste após fechar e reabrir o app

---

## 📦 Build para Produção

### Android (AAB para Play Store)

\`\`\`bash
flutter build appbundle --release
\`\`\`

O arquivo estará em: \`build/app/outputs/bundle/release/app-release.aab\`

### Configurações Necessárias

#### 1. android/app/build.gradle
\`\`\`gradle
defaultConfig {
    applicationId "com.seudominio.mestres_do_calculo"
    minSdkVersion 21
    targetSdkVersion 33
    versionCode 1
    versionName "1.0.0"
}
\`\`\`

#### 2. android/app/src/main/AndroidManifest.xml
\`\`\`xml
<manifest>
    <uses-permission android:name="android.permission.VIBRATE"/>
    <uses-permission android:name="android.permission.INTERNET"/> <!-- Apenas para Google Fonts -->
    
    <application
        android:label="Mestres do Cálculo"
        android:icon="@mipmap/ic_launcher">
        <!-- ... -->
    </application>
</manifest>
\`\`\`

---

## 🛡️ Google Play Store - Designed for Families

### Checklist de Conformidade

- [x] **Sem coleta de dados**: App totalmente offline (exceto fontes)
- [x] **Conteúdo apropriado**: Segmentação 6-12 anos
- [ ] **Parental Gate**: Implementar em configurações (TODO)
- [x] **Sem anúncios**: Livre de publicidade
- [x] **Sem compras in-app**
- [ ] **Política de Privacidade**: Criar e hospedar

### Exemplo de Política de Privacidade

\`\`\`markdown
# Política de Privacidade - Mestres do Cálculo

**Última atualização**: [DATA]

## Coleta de Dados
Este aplicativo NÃO coleta, armazena ou compartilha nenhum dado pessoal.
Todos os dados de progresso são salvos localmente no dispositivo.

## Permissões
- **Vibração**: Usada apenas para feedback tátil durante o jogo.
- **Internet**: Apenas para carregar fontes do Google Fonts.

## Contato
Para dúvidas: seuemail@dominio.com
\`\`\`

Hospede em: GitHub Pages, WordPress, ou qualquer site estático.

---

## 🎨 Customização

### Cores

Edite: \`lib/core/constants/app_colors.dart\`

\`\`\`dart
static const Color primary = Color(0xFF5B7FFF); // Azul
static const Color secondary = Color(0xFFFFD93D); // Amarelo
static const Color accent = Color(0xFFAA5FFF); // Roxo
\`\`\`

### Troféus

Adicione novos troféus em: \`lib/data/services/hive_service.dart\`

\`\`\`dart
Trophy(
  id: 'seu_trofeu',
  title: 'Título',
  description: 'Descrição',
  iconName: 'icon_name',
  category: TrophyCategory.master,
)
\`\`\`

---

## 🔮 Próximos Passos (Roadmap)

### Fase 1 - Completar Funcionalidades Core ✅
- [x] Sistema de questões inteligentes
- [x] Modos de jogo (Treino + Time Attack)
- [x] Progresso e troféus
- [x] UI/UX infantil premium

### Fase 2 - Áudio e Polimento 🚧
- [ ] Integrar AudioService completo
- [ ] Adicionar música de fundo
- [ ] SFX para acertos/erros
- [ ] Trava para pais (Parental Gate)
- [ ] Tela de configurações completa

### Fase 3 - Modo Duelo de Balões 🎈
- [ ] Implementar física de balões
- [ ] Interação de toque/estouro
- [ ] Animações especiais

### Fase 4 - Recursos Avançados 🌟
- [ ] Modo multiplayer local
- [ ] Personagens desbloqueáveis
- [ ] Temas visuais alternativos
- [ ] Ranking familiar

---

## 👨‍💻 Desenvolvimento

### Padrões de Código

- **Provider**: Para estado global
- **StatefulWidget**: Para estado local (animações)
- **const**: Sempre que possível para otimização
- **Nomenclatura**: camelCase para variáveis, PascalCase para classes

### Commits

Seguir padrão semântico:
\`\`\`
feat: Adiciona modo Time Attack
fix: Corrige bug de persistência Hive
refactor: Melhora lógica de geração de questões
docs: Atualiza README
\`\`\`

---

## 📄 Licença

Este projeto é educacional e pode ser usado livremente.

---

## 🙏 Recursos e Créditos

- **Flutter Team**: Framework incrível
- **Provider**: Gerenciamento de estado
- **Hive**: Database local rápido
- **Google Fonts**: Tipografia

---

## 📞 Suporte

**Problemas ou dúvidas?** Abra uma issue no GitHub ou entre em contato.

---

**Feito com ❤️ e Flutter**
\`\`\`

