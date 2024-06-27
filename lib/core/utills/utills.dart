import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(content: Text(message.toString())),
    );
}

Future<File?> pickAudio() async {
  try {
    final filePickerResults =
        await FilePicker.platform.pickFiles(type: FileType.audio);

    if (filePickerResults != null) {
      return File(filePickerResults.files.first.path!);
    }
    return null;
  } catch (e) {
    return null;
  }
}

Future<File?> pickImage() async {
  try {
    final filePickerResults = await FilePicker.platform.pickFiles();

    if (filePickerResults != null) {
      return File(filePickerResults.files.first.path!);
    }
    return null;
  } catch (e) {
    return null;
  }
}
