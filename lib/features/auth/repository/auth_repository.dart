import 'package:fpdart/fpdart.dart';
import 'package:music/features/auth/model/user.dart';

import '../../../core/theme/failuer/failure.dart';

abstract class AuthRepository {
  Future<Either<AppFailure, UserModel>> login({
    required String email,
    required String password,
  });
  Future<Either<AppFailure, UserModel>> signUp({
    required String name,
    required String email,
    required String password,
  });

  Future<Either<AppFailure, UserModel>> getUSerdata({
    required String token,
  });
}
