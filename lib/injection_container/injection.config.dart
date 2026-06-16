// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:firebase_messaging/firebase_messaging.dart' as _i892;
import 'package:firebase_storage/firebase_storage.dart' as _i457;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../features/authentication/data/datasources/auth_remote_data_source.dart'
    as _i299;
import '../features/authentication/data/repositories/auth_repository_impl.dart'
    as _i781;
import '../features/authentication/domain/repositories/auth_repository.dart'
    as _i716;
import '../features/authentication/domain/usecases/logout_usecase.dart'
    as _i196;
import '../features/authentication/domain/usecases/sign_in_usecase.dart'
    as _i979;
import '../features/authentication/domain/usecases/sign_up_usecase.dart'
    as _i162;
import '../features/authentication/domain/usecases/update_password_usecase.dart'
    as _i434;
import '../features/authentication/domain/usecases/update_profile_name_usecase.dart'
    as _i909;
import '../features/authentication/presentation/bloc/authentication_bloc.dart'
    as _i920;
import '../features/goals/data/datasources/goals_remote_data_source.dart'
    as _i924;
import '../features/goals/data/repositories/goals_repository_impl.dart'
    as _i700;
import '../features/goals/domain/repositories/goals_repository.dart' as _i131;
import '../features/goals/domain/usecases/contribute_goal_usecase.dart'
    as _i472;
import '../features/goals/domain/usecases/create_goal_usecase.dart' as _i561;
import '../features/goals/domain/usecases/load_goals_usecase.dart' as _i917;
import '../features/goals/presentation/bloc/goals_bloc.dart' as _i487;
import '../features/savings/data/datasources/savings_remote_data_source.dart'
    as _i823;
import '../features/savings/data/repositories/savings_repository_impl.dart'
    as _i388;
import '../features/savings/domain/repositories/savings_repository.dart'
    as _i536;
import '../features/savings/domain/usecases/create_deposit_usecase.dart'
    as _i943;
import '../features/savings/domain/usecases/load_deposits_usecase.dart'
    as _i288;
import '../features/savings/domain/usecases/withdraw_deposit_usecase.dart'
    as _i114;
import '../features/savings/presentation/bloc/savings_bloc.dart' as _i796;
import '../features/transactions/data/datasources/transactions_remote_data_source.dart'
    as _i612;
import '../features/transactions/data/repositories/transactions_repository_impl.dart'
    as _i825;
import '../features/transactions/domain/repositories/transactions_repository.dart'
    as _i5;
import '../features/transactions/domain/usecases/load_transactions_usecase.dart'
    as _i737;
import '../features/transactions/presentation/bloc/transactions_bloc.dart'
    as _i891;
import 'firebase_injectable_module.dart' as _i574;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final firebaseInjectableModule = _$FirebaseInjectableModule();
    gh.lazySingleton<_i59.FirebaseAuth>(
      () => firebaseInjectableModule.firebaseAuth,
    );
    gh.lazySingleton<_i974.FirebaseFirestore>(
      () => firebaseInjectableModule.firestore,
    );
    gh.lazySingleton<_i457.FirebaseStorage>(
      () => firebaseInjectableModule.firebaseStorage,
    );
    gh.lazySingleton<_i892.FirebaseMessaging>(
      () => firebaseInjectableModule.firebaseMessaging,
    );
    gh.lazySingleton<_i299.AuthRemoteDataSource>(
      () => _i299.AuthRemoteDataSourceImpl(
        firebaseAuth: gh<_i59.FirebaseAuth>(),
        firestore: gh<_i974.FirebaseFirestore>(),
      ),
    );
    gh.lazySingleton<_i716.AuthRepository>(
      () => _i781.AuthRepositoryImpl(
        remoteDataSource: gh<_i299.AuthRemoteDataSource>(),
      ),
    );
    gh.factory<_i196.LogoutUseCase>(
      () => _i196.LogoutUseCase(gh<_i716.AuthRepository>()),
    );
    gh.factory<_i979.SignInUseCase>(
      () => _i979.SignInUseCase(gh<_i716.AuthRepository>()),
    );
    gh.factory<_i162.SignUpUseCase>(
      () => _i162.SignUpUseCase(gh<_i716.AuthRepository>()),
    );
    gh.factory<_i434.UpdatePasswordUseCase>(
      () => _i434.UpdatePasswordUseCase(gh<_i716.AuthRepository>()),
    );
    gh.factory<_i909.UpdateProfileNameUseCase>(
      () => _i909.UpdateProfileNameUseCase(gh<_i716.AuthRepository>()),
    );
    gh.factory<_i920.AuthenticationBloc>(
      () => _i920.AuthenticationBloc(
        signInUseCase: gh<_i979.SignInUseCase>(),
        signUpUseCase: gh<_i162.SignUpUseCase>(),
        logoutUseCase: gh<_i196.LogoutUseCase>(),
        authRepository: gh<_i716.AuthRepository>(),
        updateProfileNameUseCase: gh<_i909.UpdateProfileNameUseCase>(),
        updatePasswordUseCase: gh<_i434.UpdatePasswordUseCase>(),
      ),
    );
    gh.lazySingleton<_i823.SavingsRemoteDataSource>(
      () => _i823.SavingsRemoteDataSourceImpl(
        firestore: gh<_i974.FirebaseFirestore>(),
      ),
    );
    gh.lazySingleton<_i924.GoalsRemoteDataSource>(
      () => _i924.GoalsRemoteDataSourceImpl(
        firestore: gh<_i974.FirebaseFirestore>(),
      ),
    );
    gh.lazySingleton<_i612.TransactionsRemoteDataSource>(
      () => _i612.TransactionsRemoteDataSourceImpl(
        firestore: gh<_i974.FirebaseFirestore>(),
      ),
    );
    gh.lazySingleton<_i5.TransactionsRepository>(
      () => _i825.TransactionsRepositoryImpl(
        remoteDataSource: gh<_i612.TransactionsRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i536.SavingsRepository>(
      () => _i388.SavingsRepositoryImpl(
        remoteDataSource: gh<_i823.SavingsRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i131.GoalsRepository>(
      () => _i700.GoalsRepositoryImpl(
        remoteDataSource: gh<_i924.GoalsRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i737.LoadTransactionsUseCase>(
      () => _i737.LoadTransactionsUseCase(gh<_i5.TransactionsRepository>()),
    );
    gh.factory<_i943.CreateDepositUseCase>(
      () => _i943.CreateDepositUseCase(gh<_i536.SavingsRepository>()),
    );
    gh.factory<_i288.LoadDepositsUseCase>(
      () => _i288.LoadDepositsUseCase(gh<_i536.SavingsRepository>()),
    );
    gh.factory<_i114.WithdrawDepositUseCase>(
      () => _i114.WithdrawDepositUseCase(gh<_i536.SavingsRepository>()),
    );
    gh.factory<_i472.ContributeGoalUseCase>(
      () => _i472.ContributeGoalUseCase(gh<_i131.GoalsRepository>()),
    );
    gh.factory<_i561.CreateGoalUseCase>(
      () => _i561.CreateGoalUseCase(gh<_i131.GoalsRepository>()),
    );
    gh.factory<_i917.LoadGoalsUseCase>(
      () => _i917.LoadGoalsUseCase(gh<_i131.GoalsRepository>()),
    );
    gh.factory<_i487.GoalsBloc>(
      () => _i487.GoalsBloc(
        loadGoalsUseCase: gh<_i917.LoadGoalsUseCase>(),
        createGoalUseCase: gh<_i561.CreateGoalUseCase>(),
        contributeGoalUseCase: gh<_i472.ContributeGoalUseCase>(),
      ),
    );
    gh.factory<_i891.TransactionsBloc>(
      () => _i891.TransactionsBloc(
        loadTransactionsUseCase: gh<_i737.LoadTransactionsUseCase>(),
      ),
    );
    gh.factory<_i796.SavingsBloc>(
      () => _i796.SavingsBloc(
        loadDepositsUseCase: gh<_i288.LoadDepositsUseCase>(),
        createDepositUseCase: gh<_i943.CreateDepositUseCase>(),
        withdrawDepositUseCase: gh<_i114.WithdrawDepositUseCase>(),
      ),
    );
    return this;
  }
}

class _$FirebaseInjectableModule extends _i574.FirebaseInjectableModule {}
