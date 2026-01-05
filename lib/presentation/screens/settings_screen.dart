import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../data/services/hive_service.dart';
import '../../data/services/audio_service.dart';
import '../widgets/custom_button.dart';

/// Tela de configurações com controles de áudio e vibração
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late double _musicVolume;
  late double _sfxVolume;
  late bool _vibrationEnabled;

  @override
  void initState() {
    super.initState();
    _musicVolume = HiveService.getMusicVolume();
    _sfxVolume = HiveService.getSfxVolume();
    _vibrationEnabled = HiveService.isVibrationEnabled();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(),

              // Conteúdo
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Seção de Áudio
                      _buildSectionTitle('🔊 Áudio'),
                      const SizedBox(height: 16),
                      _buildMusicVolumeControl(),
                      const SizedBox(height: 16),
                      _buildSfxVolumeControl(),

                      const SizedBox(height: 32),

                      // Seção de Vibração
                      _buildSectionTitle('📳 Vibração'),
                      const SizedBox(height: 16),
                      _buildVibrationToggle(),

                      const SizedBox(height: 32),

                      // Seção de Dados
                      _buildSectionTitle('🗑️ Dados'),
                      const SizedBox(height: 16),
                      _buildClearProgressButton(),

                      const SizedBox(height: 32),

                      // Seção Sobre
                      _buildSectionTitle('ℹ️ Sobre'),
                      const SizedBox(height: 16),
                      _buildAboutCard(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_rounded, size: 28),
            onPressed: () => Navigator.pop(context),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primary,
            ),
          ),
          const SizedBox(width: 16),
          Text('Configurações', style: AppTextStyles.h2),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.h3,
    ).animate().fadeIn().slideX(begin: -0.2, end: 0);
  }

  Widget _buildMusicVolumeControl() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.music_note, color: AppColors.primary),
              const SizedBox(width: 12),
              Text('Música de Fundo', style: AppTextStyles.body),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                _musicVolume == 0 ? Icons.volume_off : Icons.volume_up,
                color: AppColors.primary,
              ),
              Expanded(
                child: Slider(
                  value: _musicVolume,
                  min: 0.0,
                  max: 1.0,
                  divisions: 10,
                  activeColor: AppColors.primary,
                  label: '${(_musicVolume * 100).round()}%',
                  onChanged: (value) async {
                    setState(() => _musicVolume = value);
                    await AudioService().setMusicVolume(value);
                  },
                ),
              ),
              Text(
                '${(_musicVolume * 100).round()}%',
                style: AppTextStyles.caption,
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms);
  }

  Widget _buildSfxVolumeControl() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.audiotrack, color: AppColors.accent),
              const SizedBox(width: 12),
              Text('Efeitos Sonoros', style: AppTextStyles.body),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                _sfxVolume == 0 ? Icons.volume_off : Icons.volume_up,
                color: AppColors.accent,
              ),
              Expanded(
                child: Slider(
                  value: _sfxVolume,
                  min: 0.0,
                  max: 1.0,
                  divisions: 10,
                  activeColor: AppColors.accent,
                  label: '${(_sfxVolume * 100).round()}%',
                  onChanged: (value) async {
                    setState(() => _sfxVolume = value);
                    await AudioService().setSfxVolume(value);
                    // Toca som de exemplo
                    if (value > 0) {
                      AudioService().playCorrectSound();
                    }
                  },
                ),
              ),
              Text(
                '${(_sfxVolume * 100).round()}%',
                style: AppTextStyles.caption,
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms);
  }

  Widget _buildVibrationToggle() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.vibration, color: AppColors.secondary),
          const SizedBox(width: 12),
          Expanded(
            child: Text('Vibração ao tocar', style: AppTextStyles.body),
          ),
          Switch(
            value: _vibrationEnabled,
            activeColor: AppColors.secondary,
            onChanged: (value) async {
              setState(() => _vibrationEnabled = value);
              await HiveService.setVibrationEnabled(value);
            },
          ),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms);
  }

  Widget _buildClearProgressButton() {
    return CustomButton(
      text: 'Limpar Todo Progresso',
      icon: Icons.delete_forever,
      gradient: const LinearGradient(
        colors: [Colors.red, Colors.redAccent],
      ),
      onPressed: () async {
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('⚠️ Confirmar'),
            content: const Text(
              'Tem certeza que deseja apagar TODO o progresso? Esta ação não pode ser desfeita!',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('APAGAR TUDO'),
              ),
            ],
          ),
        );

        if (confirmed == true && mounted) {
          await HiveService.clearAllData();
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ Progresso apagado com sucesso!'),
              backgroundColor: AppColors.success,
            ),
          );
        }
      },
    ).animate().fadeIn(delay: 400.ms);
  }

  Widget _buildAboutCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mestres do Cálculo',
            style: AppTextStyles.h3.copyWith(color: AppColors.primary),
          ),
          const SizedBox(height: 8),
          Text('Versão 1.0.0', style: AppTextStyles.caption),
          const SizedBox(height: 16),
          Text(
            'App educativo de tabuada para crianças de 6 a 12 anos.',
            style: AppTextStyles.body.copyWith(fontSize: 14),
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          _buildInfoRow(Icons.shield, 'Sem coleta de dados'),
          const SizedBox(height: 8),
          _buildInfoRow(Icons.offline_bolt, '100% offline'),
          const SizedBox(height: 8),
          _buildInfoRow(Icons.block, 'Sem anúncios'),
          const SizedBox(height: 16),
          Text(
            '© 2025 - Todos os direitos reservados',
            style: AppTextStyles.caption,
          ),
        ],
      ),
    ).animate().fadeIn(delay: 500.ms);
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.success),
        const SizedBox(width: 8),
        Text(text, style: AppTextStyles.caption),
      ],
    );
  }
}
