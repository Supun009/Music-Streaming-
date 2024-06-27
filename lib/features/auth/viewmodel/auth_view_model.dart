import 'package:fpdart/fpdart.dart';
import 'package:music/features/auth/model/current_user_notifier.dart';
import 'package:music/features/auth/model/user.dart';
import 'package:music/features/auth/repository/auth_local_repository.dart';
import 'package:music/features/auth/repository/auth_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_view_model.g.dart';

@riverpod
class AuthViewModel extends _$AuthViewModel {
  late AuthRepositoryImpl _authRepositoryImpl;
  late AuthLocalRepositiry _authLocalRepositiry;
  late CurrentUserNotifier _currentUserNotifier;

  @override
  AsyncValue<UserModel>? build() {
    _authRepositoryImpl = ref.watch(authRepositoryImplProvider);
    _authLocalRepositiry = ref.watch(authLocalRepositiryProvider);
    _currentUserNotifier = ref.watch(currentUserNotifierProvider.notifier);
    return null;
  }

  Future<void> initSharedPref() async {
    await _authLocalRepositiry.init();
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    final res = await _authRepositoryImpl.signUp(
      name: name,
      email: email,
      password: password,
    );

    final val = switch (res) {
      Left(value: final l) => state = AsyncError(
          l.message,
          StackTrace.current,
        ),
      Right(value: final r) => state = AsyncValue.data(r)
    };
    print(val);
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    final res = await _authRepositoryImpl.login(
      email: email,
      password: password,
    );

    final val = switch (res) {
      Left(value: final l) => state = AsyncError(
          l.message,
          StackTrace.current,
        ),
      Right(value: final r) => _logonSucces(r),
    };
    print(val);
  }

  AsyncValue<UserModel?> _logonSucces(UserModel user) {
    _authLocalRepositiry.setToken(user.token);
    _currentUserNotifier.addUser(user);
    return state = AsyncValue.data(user);
  }

  Future<UserModel?> getUSerData() async {
    state = const AsyncValue.loading();
    final token = _authLocalRepositiry.getToken();

    if (token != null) {
      final res = await _authRepositoryImpl.getUSerdata(token: token);

      final val = switch (res) {
        Left(value: final l) => state = AsyncError(
            l.message,
            StackTrace.current,
          ),
        Right(value: final r) => _getDataSuccess(r),
      };
      return val.value;
    }
    return null;
  }

  AsyncValue<UserModel> _getDataSuccess(UserModel user) {
    _currentUserNotifier.addUser(user);
    return state = AsyncValue.data(user);
  }
}
