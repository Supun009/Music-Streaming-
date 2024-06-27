import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';

class AudioWave extends StatefulWidget {
  final String path;
  const AudioWave({
    super.key,
    required this.path,
  });

  @override
  State<AudioWave> createState() => _AudioWaveState();
}

class _AudioWaveState extends State<AudioWave> {
  final PlayerController _playerController = PlayerController();

  @override
  void initState() {
    super.initState();
    initAudioPlayer();
  }

  void initAudioPlayer() async {
    await _playerController.preparePlayer(path: widget.path);
  }

  Future<void> playAndPause() async {
    if (!_playerController.playerState.isPlaying) {
      await _playerController.startPlayer(finishMode: FinishMode.stop);
    } else if (!_playerController.playerState.isPaused) {
      await _playerController.pausePlayer();
    }
    setState(() {});
  }

  @override
  void dispose() {
    _playerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _playerController.playerState.isPlaying
            ? IconButton(
                onPressed: playAndPause,
                icon: const Icon(Icons.pause),
              )
            : IconButton(
                onPressed: playAndPause,
                icon: const Icon(Icons.play_arrow),
              ),
        Expanded(
          child: AudioFileWaveforms(
            size: const Size(double.infinity, 100),
            playerController: _playerController,
          ),
        ),
      ],
    );
  }
}
