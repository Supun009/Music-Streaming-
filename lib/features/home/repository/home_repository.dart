import 'dart:convert';
import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:music/core/theme/failuer/failure.dart';
import 'package:music/features/home/models/song_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_repository.g.dart';

@riverpod
HomeRepository homeRepository(HomeRepositoryRef ref) {
  return HomeRepository();
}

class HomeRepository {
  Future<Either<AppFailure, String>> upload(File selectedSong) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('http://10.0.2.2:3000/upload'),
      );

      request.files.add(await http.MultipartFile.fromPath(
        'song',
        selectedSong.path,
      ));

      final response = await request.send();

      if (response.statusCode != 200) {
        return Left(AppFailure("Upload fail "));
      }
      return Right(await response.stream.bytesToString());
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, List<SongModel>>> getSongs({
    required String token,
  }) async {
    try {
      final res = await http.get(
        Uri.parse('http://10.0.2.2:3000/list'),
        headers: {
          'content-type': 'application/json',
          "x-auth-token": token,
        },
      );

      if (res.statusCode != 200) {
        return Left(AppFailure("Cant get songs"));
      }

      var resBodyMap = jsonDecode(res.body) as List;

      List<SongModel> songs = [];
      for (final map in resBodyMap) {
        songs.add(SongModel.fromMap(map));
      }

      return Right(songs);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }
}
