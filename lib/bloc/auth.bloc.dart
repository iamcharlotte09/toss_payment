import 'package:commerce_app/event/auth.event.dart';
import 'package:commerce_app/repository/auth.repository.dart';
import 'package:commerce_app/state/auth.state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  AuthBloc({required this.repository}) : super(AuthState()) {
    on<Login>(_onLogin);
    on<Logout>(_onLogout);
    on<SignUp>(_onSignUp);
    _monitorAuthState();
  }

  void _monitorAuthState() {
    repository.authState?.listen((event) {
      final session = event.session;
      if (session != null) {
        // 사용자 로그인 상태
        emit(AuthState(user: session.user));
      } else {
        // 사용자 로그아웃 상태
        emit(AuthState(user: null));
      }
    });
  }


  void _onLogin(Login event, Emitter<AuthState> emit) async {
    try {
      final user = await repository.login(
        email: event.email,
        password: event.password,
      );

      emit(AuthState(user: user));
    } catch (e) {
      emit(AuthState(user:null));
    }
  }

  void _onLogout(Logout event, Emitter<AuthState> emit) async {
    try {
      await repository.logout();
      emit(AuthState(user: null));
    } catch (e) {
      emit(AuthState(user:null));
    }
  }

  void _onSignUp(SignUp event, Emitter<AuthState> emit) async {
    try {
      final user = await repository.signUp(
        email: event.email,
        password: event.password,
      );

      emit(AuthState(user: user));
    } catch (e) {
      emit(AuthState(user:null));
    }
  }
}
