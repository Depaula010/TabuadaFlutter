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
  int _remainingSeconds = 60;

  // Progresso persistente
  GameProgress? _currentProgress;

  // Getters
  GameState get state => _state;
  GameMode get mode => _mode;
  int? get currentTableNumber => _currentTableNumber;
  Question? get currentQuestion =>
      _questions.isNotEmpty ? _questions[_currentQuestionIndex] : null;
  int get currentQuestionNumber => _currentQuestionIndex + 1;
  int get totalQuestions => _questions.length;
  int get score => _score;
  int get correctCount => _correctCount;
  int get wrongCount => _wrongCount;
  int get remainingSeconds => _remainingSeconds;
  double get progress => totalQuestions > 0 ? currentQuestionNumber / totalQuestions : 0.0;
  bool get isLastQuestion => _currentQuestionIndex >= _questions.length - 1;

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

    // Carrega o progresso existente ou cria um novo
    _currentProgress = await HiveService.getOrCreateProgress(tableNumber);

    // Gera as questões
    _questions = _questionGenerator.generateQuestionSet(tableNumber, questionCount);

    // Inicia música de fundo
    AudioService().playBackgroundMusic();

    // Configura timer para Time Attack
    if (_mode == GameMode.timeAttack) {
      _remainingSeconds = 60;
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

    // Aguarda um breve momento para feedback visual
    await Future.delayed(const Duration(milliseconds: 800));

    // Avança para próxima questão ou finaliza
    if (!isLastQuestion) {
      _currentQuestionIndex++;
      notifyListeners();
    } else {
      await _finishGame();
    }

    return isCorrect;
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
        final allProgress = HiveService.getAllProgress();
        final completedCount = allProgress.values.where((p) => p.isCompleted).length;
        if (completedCount == 1) {
          await HiveService.unlockTrophy('first_steps');
        }
      }

      await HiveService.saveProgress(_currentProgress!);
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
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
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
