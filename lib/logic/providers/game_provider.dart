import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../data/models/question.dart';
import '../../data/models/game_progress.dart';
import '../../data/services/audio_service.dart';
import '../game_engine/question_generator.dart';
import '../../data/services/hive_service.dart';

/// Estados do jogo
enum GameState {
  idle,
  playing,
  paused,
  finished,
}

/// Modos de jogo
enum GameMode {
  training, // Treino livre sem tempo
  timeAttack, // Desafio Relâmpago (60s)
  balloonDuel, // Duelo de Balões
}

/// Provider principal do jogo com toda a lógica de gameplay
class GameProvider extends ChangeNotifier {
  final QuestionGenerator _questionGenerator = QuestionGenerator();

  // Estado do jogo
  GameState _state = GameState.idle;
  GameMode _mode = GameMode.training;
  Operation _selectedOperation = Operation.multiplication;
  int? _currentTableNumber;

  // Questões
  List<Question> _questions = [];
  int _currentQuestionIndex = 0;

  // Pontuação
  int _score = 0;
  int _correctCount = 0;
  int _wrongCount = 0;
  int _consecutiveCorrect = 0; // Para troféus de sequência perfeita

  // Timer (para Time Attack)
  Timer? _gameTimer;
  int _remainingMilliseconds = 60000; // 60 segundos em milissegundos

  // Progresso persistente
  GameProgress? _currentProgress;

  // Getters
  GameState get state => _state;
  GameMode get mode => _mode;
  Operation get selectedOperation => _selectedOperation;
  int? get currentTableNumber => _currentTableNumber;
  Question? get currentQuestion =>
      _questions.isNotEmpty ? _questions[_currentQuestionIndex] : null;
  int get currentQuestionNumber => _currentQuestionIndex + 1;
  int get totalQuestions => _questions.length;
  int get score => _score;
  int get correctCount => _correctCount;
  int get wrongCount => _wrongCount;
  
  // Timer getters
  int get remainingSeconds => (_remainingMilliseconds / 1000).ceil();
  int get remainingTenths => ((_remainingMilliseconds % 1000) / 100).floor();
  int get remainingMilliseconds => _remainingMilliseconds;
  bool get isTimeCritical => _remainingMilliseconds <= 10000; // Últimos 10 segundos
  
  double get progress => totalQuestions > 0 ? currentQuestionNumber / totalQuestions : 0.0;
  bool get isLastQuestion => _currentQuestionIndex >= _questions.length - 1;

  // ===== SELEÇÃO DE OPERAÇÃO =====

  /// Define a operação matemática selecionada
  void setOperation(Operation operation) {
    _selectedOperation = operation;
    notifyListeners();
  }

  // ===== CONTROLE DO JOGO =====

  /// Inicia um novo jogo
  Future<void> startGame({
    required GameMode mode,
    required int tableNumber,
    int questionCount = 10,
  }) async {
    _mode = mode;
    _currentTableNumber = tableNumber;
    _state = GameState.playing;

    // Reseta estatísticas
    _score = 0;
    _correctCount = 0;
    _wrongCount = 0;
    _consecutiveCorrect = 0;
    _currentQuestionIndex = 0;

    // Carrega o progresso existente ou cria um novo para esta operação
    _currentProgress = await HiveService.getOrCreateProgress(tableNumber, _selectedOperation);

    // Gera as questões com a operação selecionada
    _questions = _questionGenerator.generateQuestionSet(
      tableNumber,
      questionCount,
      operation: _selectedOperation,
    );

    // Inicia música de fundo
    AudioService().playBackgroundMusic();

    // Configura timer para Time Attack
    if (_mode == GameMode.timeAttack) {
      _remainingMilliseconds = 60000; // 60 segundos
      _startTimer();
    }

    notifyListeners();
  }

  /// Submete uma resposta
  Future<bool> submitAnswer(int answer) async {
    if (_state != GameState.playing || currentQuestion == null) {
      return false;
    }

    final isCorrect = currentQuestion!.isCorrectAnswer(answer);

    if (isCorrect) {
      _handleCorrectAnswer();
    } else {
      _handleWrongAnswer();
    }

    // Retorna imediatamente - a UI controla o tempo de espera da animação
    return isCorrect;
  }

  /// Avança para a próxima questão (chamado pela UI após animação)
  Future<void> moveToNextQuestion() async {
    if (!isLastQuestion) {
      _currentQuestionIndex++;
      notifyListeners();
    } else {
      await _finishGame();
    }
  }

  /// Processa resposta correta
  void _handleCorrectAnswer() {
    _correctCount++;
    _consecutiveCorrect++;
    _score += _calculatePoints();
    _currentProgress?.recordCorrectAnswer();

    // Toca som de acerto
    AudioService().playCorrectSound();

    // Verifica troféu de 10 acertos seguidos
    if (_consecutiveCorrect >= 10) {
      HiveService.unlockTrophy('perfect_10');
    }

    notifyListeners();
  }

  /// Processa resposta errada
  void _handleWrongAnswer() {
    _wrongCount++;
    _consecutiveCorrect = 0; // Reseta sequência
    _currentProgress?.recordWrongAnswer();
    
    // Toca som de erro
    AudioService().playWrongSound();
    
    notifyListeners();
  }

  /// Calcula pontos baseado no modo e consecutivos
  int _calculatePoints() {
    int basePoints = 10;

    // Bônus no Time Attack
    if (_mode == GameMode.timeAttack) {
      basePoints = 15;
    }

    // Bônus por sequência
    final comboBonus = (_consecutiveCorrect ~/ 3) * 5;

    return basePoints + comboBonus;
  }

  /// Finaliza o jogo
  Future<void> _finishGame() async {
    _state = GameState.finished;
    _gameTimer?.cancel();

    // Para música de fundo
    AudioService().stopBackgroundMusic();

    // Salva progresso
    if (_currentProgress != null) {
      // Atualiza melhor pontuação no Time Attack
      if (_mode == GameMode.timeAttack) {
        _currentProgress!.updateBestTimeAttackScore(_score);
      }

      // Marca como completo se acertou tudo
      if (_wrongCount == 0) {
        _currentProgress!.markCompleted();
        
        // Desbloqueia troféu de primeira conclusão
        final allProgress = HiveService.getAllProgressForOperation(_selectedOperation);
        final completedCount = allProgress.values.where((p) => p.isCompleted).length;
        if (completedCount == 1) {
          await HiveService.unlockTrophy('first_steps');
        }
      }

      await HiveService.saveProgress(_currentProgress!, _selectedOperation);
    }

    notifyListeners();
  }

  /// Pausa o jogo
  void pauseGame() {
    if (_state == GameState.playing) {
      _state = GameState.paused;
      _gameTimer?.cancel();
      
      // Pausa música de fundo
      AudioService().pauseBackgroundMusic();
      
      notifyListeners();
    }
  }

  /// Resume o jogo
  void resumeGame() {
    if (_state == GameState.paused) {
      _state = GameState.playing;
      
      // Resume música de fundo
      AudioService().resumeBackgroundMusic();
      
      if (_mode == GameMode.timeAttack) {
        _startTimer();
      }
      notifyListeners();
    }
  }

  /// Reinicia o jogo atual
  Future<void> restartGame() async {
    if (_currentTableNumber != null) {
      await startGame(
        mode: _mode,
        tableNumber: _currentTableNumber!,
        questionCount: _questions.length,
      );
    }
  }

  // ===== TIMER =====

  void _startTimer() {
    _gameTimer?.cancel();
    // Atualiza a cada 100ms para mostrar décimos de segundo
    _gameTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_remainingMilliseconds > 0) {
        _remainingMilliseconds -= 100;
        notifyListeners();
      } else {
        _finishGame();
      }
    });
  }

  // ===== CLEANUP =====

  @override
  void dispose() {
    _gameTimer?.cancel();
    super.dispose();
  }
}
