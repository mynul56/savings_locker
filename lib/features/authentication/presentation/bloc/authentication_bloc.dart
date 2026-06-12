import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/sign_in_usecase.dart';
import '../../domain/usecases/sign_up_usecase.dart';
import '../../domain/repositories/auth_repository.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

@injectable
class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final SignInUseCase signInUseCase;
  final SignUpUseCase signUpUseCase;
  final LogoutUseCase logoutUseCase;
  final AuthRepository authRepository;

  AuthenticationBloc({
    required this.signInUseCase,
    required this.signUpUseCase,
    required this.logoutUseCase,
    required this.authRepository,
  }) : super(AuthenticationInitial()) {
    on<AppStarted>(_onAppStarted);
    on<SignInRequested>(_onSignInRequested);
    on<SignUpRequested>(_onSignUpRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<ForgotPasswordRequested>(_onForgotPasswordRequested);
  }

  Future<void> _onAppStarted(AppStarted event, Emitter<AuthenticationState> emit) async {
    emit(AuthenticationLoading());
    final result = await authRepository.getCurrentUser();
    result.fold(
      (failure) => emit(AuthenticationUnauthenticated()),
      (user) {
        if (user != null) {
          emit(AuthenticationAuthenticated(user));
        } else {
          emit(AuthenticationUnauthenticated());
        }
      },
    );
  }

  Future<void> _onSignInRequested(SignInRequested event, Emitter<AuthenticationState> emit) async {
    emit(AuthenticationLoading());
    final result = await signInUseCase(SignInParams(email: event.email, password: event.password));
    result.fold(
      (failure) => emit(AuthenticationFailure(failure.message)),
      (user) => emit(AuthenticationAuthenticated(user)),
    );
  }

  Future<void> _onSignUpRequested(SignUpRequested event, Emitter<AuthenticationState> emit) async {
    emit(AuthenticationLoading());
    final result = await signUpUseCase(SignUpParams(
      email: event.email,
      password: event.password,
      fullName: event.fullName,
    ));
    result.fold(
      (failure) => emit(AuthenticationFailure(failure.message)),
      (user) => emit(AuthenticationAuthenticated(user)),
    );
  }

  Future<void> _onLogoutRequested(LogoutRequested event, Emitter<AuthenticationState> emit) async {
    emit(AuthenticationLoading());
    final result = await logoutUseCase(NoParams());
    result.fold(
      (failure) => emit(AuthenticationFailure(failure.message)),
      (_) => emit(AuthenticationUnauthenticated()),
    );
  }

  Future<void> _onForgotPasswordRequested(ForgotPasswordRequested event, Emitter<AuthenticationState> emit) async {
    // Optionally emit a loading state or just handle it silently
    final result = await authRepository.resetPassword(event.email);
    result.fold(
      (failure) => emit(AuthenticationFailure(failure.message)),
      (_) {
        // Just remain in unauthenticated or emit a specific success state
        emit(AuthenticationUnauthenticated());
      },
    );
  }
}
