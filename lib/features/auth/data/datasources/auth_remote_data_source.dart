import '../../../../core/network/dio_client.dart';
import '../../domain/entities/user.dart';

abstract class AuthRemoteDataSource {
  Future<User> login({required String email, required String password});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this._client);

  final DioClient _client;

  @override
  Future<User> login({required String email, required String password}) async {
    final response = await _client.dio.post(
      '/auth/login',
      data: {'email': email, 'password': password},
    );

    final data = response.data as Map<String, dynamic>;
    return User(id: data['id'] as String, name: data['name'] as String);
  }
}
