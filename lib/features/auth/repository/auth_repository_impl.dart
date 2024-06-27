import 'dart:convert';
import 'package:fpdart/fpdart.dart';
import 'package:music/core/theme/failuer/failure.dart';
import 'package:music/features/auth/model/user.dart';
import 'package:music/features/auth/repository/auth_repository.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_repository_impl.g.dart';

@riverpod
AuthRepositoryImpl authRepositoryImpl(AuthRepositoryImplRef ref) {
  return AuthRepositoryImpl(baseUrl: 'http://10.0.2.2:3000');
}

class AuthRepositoryImpl implements AuthRepository {
  final String baseUrl;

  AuthRepositoryImpl({
    required this.baseUrl,
  });

  @override
  Future<Either<AppFailure, UserModel>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(Uri.parse('$baseUrl/api/login'),
          headers: {'content-type': 'application/json'},
          body: jsonEncode(
            {
              'email': email,
              'password': password,
            },
          ));

      final resBody = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 200) {
        return Left(AppFailure(resBody['msg']));
      }

      return Right(UserModel.fromMap(resBody));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, UserModel>> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
          {
            'name': name,
            'email': email,
            'password': password,
          },
        ),
      );

      final resBody = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 200) {
        return Left(AppFailure(resBody['msg']));
      }

      return Right(UserModel.fromMap(resBody));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, UserModel>> getUSerdata({
    required String token,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/'),
        headers: {
          'content-type': 'application/json',
          'x-auth-token': token,
        },
      );

      final resBody = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 200) {
        return Left(AppFailure(resBody['msg']));
      }

      return Right(UserModel.fromMap(resBody).copyWith(
        token: token,
      ));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }
}
