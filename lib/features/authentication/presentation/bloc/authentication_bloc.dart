import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/sign_in_usecase.dart';
import '../../domain/usecases/sign_up_usecase.dart';
import '../../domain/repositories/auth_repository.dart';

import '../../domain/usecases/update_profile_name_usecase.dart';
import '../../domain/usecases/update_password_usecase.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

@injectable
class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final SignInUseCase signInUseCase;
  final SignUpUseCase signUpUseCase;
  final LogoutUseCase logoutUseCase;
  final AuthRepository authRepository;
  final UpdateProfileNameUseCase updateProfileNameUseCase;
  final UpdatePasswordUseCase updatePasswordUseCase;

  AuthenticationBloc({
    required this.signInUseCase,
    required this.signUpUseCase,
    required this.logoutUseCase,
    required this.authRepository,
    required this.updateProfileNameUseCase,
    required this.updatePasswordUseCase,
  }) : super(AuthenticationInitial()) {
    on<AppStarted>(_onAppStarted);
    on<SignInRequested>(_onSignInRequested);
    on<SignUpRequested>(_onSignUpRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<ForgotPasswordRequested>(_onForgotPasswordRequested);
    on<UpdateProfileNameRequested>(_onUpdateProfileNameRequested);
    on<UpdatePasswordRequested>(_onUpdatePasswordRequested);
    on<BiometricAuthenticationSuccessful>(_onBiometricAuthenticationSuccessful);
  }

  Future<void> _onAppStarted(
    AppStarted event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(AuthenticationLoading());
    final result = await authRepository.getCurrentUser();
    await result.fold((failure) async {
      emit(AuthenticationUnauthenticated());
    }, (user) async {
      if (user != null) {
        final prefs = await SharedPreferences.getInstance();
        final isFaceLockEnabled = prefs.getBool('isFaceLockEnabled') ?? false;
        if (isFaceLockEnabled) {
          emit(AuthenticationBiometricRequested(user));
        } else {
          emit(AuthenticationAuthenticated(user));
        }
      } else {
        emit(AuthenticationUnauthenticated());
      }
    });
  }

  Future<void> _onSignInRequested(
    SignInRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(AuthenticationLoading());
    final result = await signInUseCase(
      SignInParams(email: event.email, password: event.password),
    );
    result.fold(
      (failure) => emit(AuthenticationFailure(failure.message)),
      (user) => emit(AuthenticationAuthenticated(user)),
    );
  }

  Future<void> _onSignUpRequested(
    SignUpRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(AuthenticationLoading());
    final result = await signUpUseCase(
      SignUpParams(
        email: event.email,
        password: event.password,
        fullName: event.fullName,
      ),
    );
    result.fold(
      (failure) => emit(AuthenticationFailure(failure.message)),
      (user) => emit(AuthenticationAuthenticated(user)),
    );
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(AuthenticationLoading());
    final result = await logoutUseCase(NoParams());
    result.fold(
      (failure) => emit(AuthenticationFailure(failure.message)),
      (_) => emit(AuthenticationUnauthenticated()),
    );
  }

  Future<void> _onForgotPasswordRequested(
    ForgotPasswordRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    // Optionally emit a loading state or just handle it silently
    final result = await authRepository.resetPassword(event.email);
    result.fold((failure) => emit(AuthenticationFailure(failure.message)), (_) {
      // Just remain in unauthenticated or emit a specific success state
      emit(AuthenticationUnauthenticated());
    });
  }

  Future<void> _onUpdateProfileNameRequested(
    UpdateProfileNameRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    final currentState = state;
    if (currentState is AuthenticationAuthenticated) {
      final updateResult = await updateProfileNameUseCase(event.fullName);
      updateResult.fold(
        (failure) => emit(AuthenticationFailure(failure.message)),
        (user) => emit(AuthenticationAuthenticated(user)),
      );
    }
  }

  Future<void> _onUpdatePasswordRequested(
    UpdatePasswordRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    final currentState = state;
    if (currentState is AuthenticationAuthenticated) {
      final updateResult = await updatePasswordUseCase(
        UpdatePasswordParams(
          currentPassword: event.currentPassword,
          newPassword: event.newPassword,
        ),
      );
      updateResult.fold(
        (failure) => emit(AuthenticationFailure(failure.message)),
        (_) => emit(currentState), // Just stay authenticated
      );
    }
  }

  Future<void> _onBiometricAuthenticationSuccessful(
    BiometricAuthenticationSuccessful event,
    Emitter<AuthenticationState> emit,
  ) async {
    final currentState = state;
    if (currentState is AuthenticationBiometricRequested) {
      emit(AuthenticationAuthenticated(currentState.user));
    }
  }
}
