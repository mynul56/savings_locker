import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

@injectable
class UpdateProfileNameUseCase implements UseCase<UserEntity, String> {
  final AuthRepository repository;

  UpdateProfileNameUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(String params) async {
    return await repository.updateProfileName(params);
  }
}
