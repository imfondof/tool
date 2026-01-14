import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(this._repository) : super(const LoginState()) {
    on<LoginSubmitted>(_onSubmitted);
  }

  final AuthRepository _repository;

  Future<void> _onSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(status: LoginStatus.loading, error: null));

    try {
      final user = await _repository.login(
        email: event.email,
        password: event.password,
      );
      emit(state.copyWith(status: LoginStatus.success, user: user));
    } catch (_) {
      emit(state.copyWith(
        status: LoginStatus.failure,
        error: 'Login failed. Please try again.',
      ));
    }
  }
}
