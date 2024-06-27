import 'dart:io';
import 'package:fpdart/fpdart.dart';
import 'package:music/features/auth/model/current_user_notifier.dart';
import 'package:music/features/home/models/song_model.dart';
import 'package:music/features/home/repository/home_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_view_model.g.dart';

@riverpod
Future<List<SongModel>> getAllSongs(GetAllSongsRef ref) async {
  final token = ref.watch(currentUserNotifierProvider)!.token;
  final res = await ref.watch(homeRepositoryProvider).getSongs(token: token);

  return switch (res) {
    Left(value: final l) => throw l.message,
    Right(value: final r) => r,
  };
}

@riverpod
class HomeViewModel extends _$HomeViewModel {
  late HomeRepository _homeRepository;
  @override
  AsyncValue? build() {
    _homeRepository = ref.watch(homeRepositoryProvider);
    return null;
  }

  Future<void> uploadSong({
    required File selectedsong,
    required File selectedImage,
    required String songName,
    required String artistName,
  }) async {
    state = const AsyncValue.loading();

    final response = await _homeRepository.upload(selectedsong);

    final val = switch (response) {
      Left(value: final l) => AsyncValue.error(l.message, StackTrace.current),
      Right(value: final r) => AsyncValue.data(r),
    };
    print(val);
  }
}
