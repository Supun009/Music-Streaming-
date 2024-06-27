import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music/core/theme/app_pallete.dart';

import '../../../core/providers/current_song_notifier.dart';

class MusicPlayer extends ConsumerWidget {
  const MusicPlayer({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSong = ref.watch(currentSongnotifierProvider);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                        image: NetworkImage(currentSong!.thumbnail_url),
                        fit: BoxFit.cover)),
              ),
            ),
            Expanded(
              flex: 4,
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        currentSong.song_name,
                        style: const TextStyle(
                            color: Pallete.whiteColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 17),
                      ),
                      const Expanded(child: SizedBox()),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(CupertinoIcons.heart))
                    ],
                  )
                ],
              ),
            ),
            Column(
              children: [
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: Pallete.whiteColor,
                    inactiveTrackColor: Pallete.whiteColor.withOpacity(0.117),
                    trackHeight: 4,
                  ),
                  child: Slider(
                    value: 0.5,
                    onChanged: (value) {},
                  ),
                )
              ],
            ),
            const Row(
              children: [
                Text(
                  '0.05',
                  style: TextStyle(
                      color: Pallete.subtitleText,
                      fontSize: 13,
                      fontWeight: FontWeight.w200),
                ),
                Expanded(child: SizedBox()),
                Text(
                  '0.05',
                  style: TextStyle(
                      color: Pallete.subtitleText,
                      fontSize: 13,
                      fontWeight: FontWeight.w200),
                ),
              ],
            ),
            const SizedBox(height: 15),
            const Row(
              children: [],
            )
          ],
        ),
      ),
    );
  }
}
