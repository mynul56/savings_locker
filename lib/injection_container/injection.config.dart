// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: no_leading_underscores_for_library_prefixes, depend_on_referenced_packages

import 'package:cloud_firestore/cloud_firestore.dart' as _i4;
import 'package:firebase_auth/firebase_auth.dart' as _i3;
import 'package:firebase_messaging/firebase_messaging.dart' as _i6;
import 'package:firebase_storage/firebase_storage.dart' as _i5;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import 'firebase_injectable_module.dart' as _i7;

// Auth
import '../features/authentication/data/datasources/auth_remote_data_source.dart';
import '../features/authentication/data/repositories/auth_repository_impl.dart';
import '../features/authentication/domain/repositories/auth_repository.dart';
import '../features/authentication/domain/usecases/logout_usecase.dart';
import '../features/authentication/domain/usecases/sign_in_usecase.dart';
import '../features/authentication/domain/usecases/sign_up_usecase.dart';
import '../features/authentication/presentation/bloc/authentication_bloc.dart';

import '../features/authentication/domain/usecases/update_profile_name_usecase.dart';
import '../features/authentication/domain/usecases/update_password_usecase.dart';

// Savings
import '../features/savings/data/datasources/savings_remote_data_source.dart';
import '../features/savings/data/repositories/savings_repository_impl.dart';
import '../features/savings/domain/repositories/savings_repository.dart';
import '../features/savings/domain/usecases/load_deposits_usecase.dart';
import '../features/savings/domain/usecases/create_deposit_usecase.dart';
import '../features/savings/domain/usecases/withdraw_deposit_usecase.dart';
import '../features/savings/presentation/bloc/savings_bloc.dart';

// Goals
import '../features/goals/data/datasources/goals_remote_data_source.dart';
import '../features/goals/data/repositories/goals_repository_impl.dart';
import '../features/goals/domain/repositories/goals_repository.dart';
import '../features/goals/domain/usecases/load_goals_usecase.dart';
import '../features/goals/domain/usecases/create_goal_usecase.dart';
import '../features/goals/domain/usecases/contribute_goal_usecase.dart';
import '../features/goals/presentation/bloc/goals_bloc.dart';

extension GetItInjectableX on _i1.GetIt {
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(this, environment, environmentFilter);
    final firebaseInjectableModule = _$FirebaseInjectableModule();

    gh.lazySingleton<_i3.FirebaseAuth>(
      () => firebaseInjectableModule.firebaseAuth,
    );
    gh.lazySingleton<_i4.FirebaseFirestore>(
      () => firebaseInjectableModule.firestore,
    );
    gh.lazySingleton<_i5.FirebaseStorage>(
      () => firebaseInjectableModule.firebaseStorage,
    );
    gh.lazySingleton<_i6.FirebaseMessaging>(
      () => firebaseInjectableModule.firebaseMessaging,
    );

    // Auth Layer
    gh.lazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        firebaseAuth: gh<_i3.FirebaseAuth>(),
        firestore: gh<_i4.FirebaseFirestore>(),
      ),
    );

    gh.lazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(remoteDataSource: gh<AuthRemoteDataSource>()),
    );

    gh.factory<SignInUseCase>(() => SignInUseCase(gh<AuthRepository>()));
    gh.factory<SignUpUseCase>(() => SignUpUseCase(gh<AuthRepository>()));
    gh.factory<LogoutUseCase>(() => LogoutUseCase(gh<AuthRepository>()));
    gh.factory<UpdateProfileNameUseCase>(() => UpdateProfileNameUseCase(gh<AuthRepository>()));
    gh.factory<UpdatePasswordUseCase>(() => UpdatePasswordUseCase(gh<AuthRepository>()));

    gh.factory<AuthenticationBloc>(
      () => AuthenticationBloc(
        signInUseCase: gh<SignInUseCase>(),
        signUpUseCase: gh<SignUpUseCase>(),
        logoutUseCase: gh<LogoutUseCase>(),
        authRepository: gh<AuthRepository>(),
        updateProfileNameUseCase: gh<UpdateProfileNameUseCase>(),
        updatePasswordUseCase: gh<UpdatePasswordUseCase>(),
      ),
    );

    // Savings Layer
    gh.lazySingleton<SavingsRemoteDataSource>(
      () => SavingsRemoteDataSourceImpl(firestore: gh<_i4.FirebaseFirestore>()),
    );
    gh.lazySingleton<SavingsRepository>(
      () => SavingsRepositoryImpl(
        remoteDataSource: gh<SavingsRemoteDataSource>(),
      ),
    );
    gh.factory<LoadDepositsUseCase>(
      () => LoadDepositsUseCase(gh<SavingsRepository>()),
    );
    gh.factory<CreateDepositUseCase>(
      () => CreateDepositUseCase(gh<SavingsRepository>()),
    );
    gh.factory<WithdrawDepositUseCase>(
      () => WithdrawDepositUseCase(gh<SavingsRepository>()),
    );
    gh.factory<SavingsBloc>(
      () => SavingsBloc(
        loadDepositsUseCase: gh<LoadDepositsUseCase>(),
        createDepositUseCase: gh<CreateDepositUseCase>(),
        withdrawDepositUseCase: gh<WithdrawDepositUseCase>(),
      ),
    );

    // Goals Layer
    gh.lazySingleton<GoalsRemoteDataSource>(
      () => GoalsRemoteDataSourceImpl(firestore: gh<_i4.FirebaseFirestore>()),
    );
    gh.lazySingleton<GoalsRepository>(
      () => GoalsRepositoryImpl(remoteDataSource: gh<GoalsRemoteDataSource>()),
    );
    gh.factory<LoadGoalsUseCase>(() => LoadGoalsUseCase(gh<GoalsRepository>()));
    gh.factory<CreateGoalUseCase>(
      () => CreateGoalUseCase(gh<GoalsRepository>()),
    );
    gh.factory<ContributeGoalUseCase>(
      () => ContributeGoalUseCase(gh<GoalsRepository>()),
    );
    gh.factory<GoalsBloc>(
      () => GoalsBloc(
        loadGoalsUseCase: gh<LoadGoalsUseCase>(),
        createGoalUseCase: gh<CreateGoalUseCase>(),
        contributeGoalUseCase: gh<ContributeGoalUseCase>(),
      ),
    );

    return this;
  }
}

class _$FirebaseInjectableModule extends _i7.FirebaseInjectableModule {}
