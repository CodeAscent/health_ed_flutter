import 'package:bloc/bloc.dart';
import 'package:health_ed_flutter/core/local/local_storage.dart';
import 'package:health_ed_flutter/features/auth/models/user.dart';
import 'package:health_ed_flutter/features/auth/repository/auth_repository.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  AuthBloc(this.authRepository) : super(AuthInitial()) {
    on<AuthLoginRequested>(authLogin);
    on<AuthUserDataRequested>(authUser);
  }

  Future<void> authLogin(
      AuthLoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final res = await authRepository.login(
          email: event.email, password: event.password);
      final user = User.fromMap(res['user']);
      await LocalStorage.prefs.setString('token', res['token']);
      emit(AuthLoginSuccess(user: user));
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }

  Future<void> authUser(
      AuthUserDataRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final res = await authRepository.fetchUser();
      final user = User.fromMap(res['user']);
      emit(AuthUserFetchSuccess(user: user));
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }
}
