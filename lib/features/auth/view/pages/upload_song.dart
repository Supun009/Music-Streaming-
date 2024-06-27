import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music/core/theme/app_pallete.dart';
import 'package:music/core/utills/utills.dart';
import 'package:music/core/widgets/custom_field.dart';
import 'package:music/features/home/view_model/home_view_model.dart';
import 'package:music/features/home/widget/audio_wave.dart';

class UploadSongs extends ConsumerStatefulWidget {
  const UploadSongs({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _State();
}

class _State extends ConsumerState<UploadSongs> {
  final songnameController = TextEditingController();
  final artistnameController = TextEditingController();

  var selectedColor = Pallete.cardColor;
  File? selectedImage;
  File? selecteAudio;

  @override
  void dispose() {
    songnameController.dispose();
    artistnameController.dispose();
    super.dispose();
  }

  void selectAudio() async {
    final pickedAudio = await pickAudio();
    if (pickedAudio != null) {
      setState(() {
        selecteAudio = pickedAudio;
      });
    }
  }

  void selectImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        selectedImage = pickedImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("upload somgs"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () async {
                ref.read(homeViewModelProvider.notifier).uploadSong(
                    selectedsong: selecteAudio!,
                    selectedImage: selectedImage!,
                    songName: songnameController.text,
                    artistName: artistnameController.text);
              },
              icon: const Icon(Icons.check))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: selectImage,
                child: selectedImage != null
                    ? SizedBox(
                        height: 150,
                        width: double.infinity,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            selectedImage!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : DottedBorder(
                        color: Pallete.borderColor,
                        radius: const Radius.circular(10),
                        borderType: BorderType.RRect,
                        dashPattern: const [10, 4],
                        strokeCap: StrokeCap.round,
                        child: const SizedBox(
                          height: 150,
                          width: double.infinity,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.folder_open,
                                size: 40,
                              ),
                              SizedBox(height: 15),
                              Text(
                                'Select the thumbnail for your song',
                                style: TextStyle(fontSize: 15),
                              )
                            ],
                          ),
                        )),
              ),
              const SizedBox(height: 40),
              selecteAudio != null
                  ? AudioWave(path: selecteAudio!.path)
                  : CustomFied(
                      hintText: 'Pick song',
                      controller: null,
                      readonly: true,
                      onTap: selectAudio,
                    ),
              const SizedBox(height: 20),
              CustomFied(
                hintText: 'Artist',
                controller: null,
                readonly: false,
                onTap: () {},
              ),
              const SizedBox(height: 20),
              CustomFied(
                hintText: 'Song name',
                controller: null,
                readonly: false,
                onTap: () {},
              ),
              const SizedBox(height: 20),
              ColorPicker(
                pickersEnabled: const {ColorPickerType.wheel: true},
                onColorChanged: (Color color) {
                  setState(() {
                    selectedColor = color;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
