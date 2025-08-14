import '../../core/error/result.dart';

/// Base class for all use cases following Single Responsibility Principle
/// Implements Template Method pattern
abstract class UseCase<Type, Params> {
  /// Main execution method
  Future<Result<Type>> call(Params params);

  /// Optional validation method
  Result<void> validate(Params params) => const Success(null);
}

/// Base class for use cases without parameters
abstract class NoParamsUseCase<Type> extends UseCase<Type, NoParams> {
  @override
  Future<Result<Type>> call(NoParams params);
}

/// Empty parameters class
class NoParams {
  const NoParams();
}
