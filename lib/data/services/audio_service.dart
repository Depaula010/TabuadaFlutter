import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../../data/services/hive_service.dart';

/// Serviço de gerenciamento de áudio
class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _musicPlayer = AudioPlayer();
  final AudioPlayer _sfxPlayer = AudioPlayer();

  bool _isInitialized = false;
  bool _audioUnlocked = false;

  /// Inicializa o serviço de áudio
  Future<void> init() async {
    if (_isInitialized) return;

    // Configura player de música como loop
    _musicPlayer.setReleaseMode(ReleaseMode.loop);

    // Aplica volumes salvos
    await _musicPlayer.setVolume(HiveService.getMusicVolume());
    await _sfxPlayer.setVolume(HiveService.getSfxVolume());

    _isInitialized = true;
  }

  /// Desbloqueia áudio para navegadores (Chrome precisa de interação do usuário)
  Future<void> unlockAudio() async {
    if (_audioUnlocked) return;
    
    try {
      // Toca um som silencioso para desbloquear o AudioContext
      await _sfxPlayer.setVolume(0);
      await _sfxPlayer.play(AssetSource('sounds/sfx/success.mp3'));
      await Future.delayed(const Duration(milliseconds: 100));
      await _sfxPlayer.stop();
      await _sfxPlayer.setVolume(HiveService.getSfxVolume());
      _audioUnlocked = true;
    } catch (e) {
      print('Erro ao desbloquear áudio: $e');
    }
  }

  // ===== MÚSICA DE FUNDO =====

  /// Inicia música de fundo
  Future<void> playBackgroundMusic() async {
    try {
      await _musicPlayer.play(AssetSource('sounds/music/background.mp3'));
    } catch (e) {
      print('Erro ao tocar música: $e');
    }
  }

  /// Para música de fundo
  Future<void> stopBackgroundMusic() async {
    await _musicPlayer.stop();
  }

  /// Pausa música de fundo
  Future<void> pauseBackgroundMusic() async {
    await _musicPlayer.pause();
  }

  /// Resume música de fundo
  Future<void> resumeBackgroundMusic() async {
    await _musicPlayer.resume();
  }

  /// Atualiza volume da música
  Future<void> setMusicVolume(double volume) async {
    await _musicPlayer.setVolume(volume);
    await HiveService.setMusicVolume(volume);
  }

  // ===== EFEITOS SONOROS =====

  /// Toca som de acerto
  Future<void> playCorrectSound() async {
    try {
      await _sfxPlayer.stop();
      await _sfxPlayer.play(AssetSource('sounds/sfx/success.mp3'));
    } catch (e) {
      print('Erro ao tocar SFX: $e');
    }
  }

  /// Toca som de erro
  Future<void> playWrongSound() async {
    try {
      await _sfxPlayer.stop();
      await _sfxPlayer.play(AssetSource('sounds/sfx/error.mp3'));
    } catch (e) {
      print('Erro ao tocar SFX: $e');
    }
  }

  /// Toca som de moeda/pontos
  Future<void> playCoinSound() async {
    try {
      await _sfxPlayer.stop();
      await _sfxPlayer.play(AssetSource('sounds/sfx/success.mp3'));
    } catch (e) {
      print('Erro ao tocar SFX: $e');
    }
  }

  /// Toca som de troféu desbloqueado
  Future<void> playTrophyUnlockedSound() async {
    try {
      await _sfxPlayer.stop();
      await _sfxPlayer.play(AssetSource('sounds/sfx/success.mp3'));
    } catch (e) {
      print('Erro ao tocar SFX: $e');
    }
  }

  /// Atualiza volume dos efeitos sonoros
  Future<void> setSfxVolume(double volume) async {
    await _sfxPlayer.setVolume(volume);
    await HiveService.setSfxVolume(volume);
  }

  // ===== CLEANUP =====

  /// Libera recursos
  Future<void> dispose() async {
    await _musicPlayer.dispose();
    await _sfxPlayer.dispose();
  }
}
