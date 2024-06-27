import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music/core/providers/current_song_notifier.dart';
import 'package:music/core/theme/app_pallete.dart';
import 'package:music/features/home/widget/music_player.dart';

class SongSlab extends ConsumerWidget {
  const SongSlab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSong = ref.watch(currentSongnotifierProvider);
    final songNotifier = ref.read(currentSongnotifierProvider.notifier);

    if (currentSong == null) {
      return const SizedBox();
    }
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return const MusicPlayer();
            },
          ),
        );
      },
      child: Stack(
        children: [
          Container(
            height: 66,
            width: MediaQuery.of(context).size.width - 16,
            decoration: BoxDecoration(
                color: Pallete.gradient2,
                borderRadius: BorderRadius.circular(4)),
            padding: const EdgeInsets.all(9),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 48,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(currentSong.thumbnail_url),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(4)),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          currentSong.song_name,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          currentSong.artist,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ],
                    )
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: songNotifier.playPause,
                      icon: Icon(songNotifier.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow),
                    )
                  ],
                )
              ],
            ),
          ),
          StreamBuilder(
              stream: songNotifier.audioPlayer?.positionStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox();
                }
                final position = snapshot.data!;
                final duration = songNotifier.audioPlayer!.duration;
                double slideBarValue = 0.0;
                if (duration != null) {
                  slideBarValue =
                      position.inMilliseconds / duration.inMilliseconds;
                }

                return Positioned(
                    bottom: 0,
                    left: 8,
                    child: Container(
                      height: 2,
                      width: slideBarValue *
                          (MediaQuery.of(context).size.width - 32),
                      decoration: BoxDecoration(
                        color: Pallete.whiteColor,
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ));
              }),
          Positioned(
              bottom: 0,
              left: 8,
              child: Container(
                height: 2,
                width: MediaQuery.of(context).size.width - 32,
                decoration: BoxDecoration(
                  color: Pallete.inactiveSeekColor,
                  borderRadius: BorderRadius.circular(7),
                ),
              )),
        ],
      ),
    );
  }
}
