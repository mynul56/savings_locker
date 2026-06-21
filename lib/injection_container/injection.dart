import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import '../features/savings/data/services/ssl_payment_service.dart';

import 'injection.config.dart';

final GetIt sl = GetIt.instance; // sl stands for Service Locator

@InjectableInit(
  initializerName: 'init', // default
  preferRelativeImports: true, // default
  asExtension: true, // default
)
Future<void> configureDependencies() async {
  sl.init();
  // Manually register SslPaymentService since build_runner is currently broken
  sl.registerLazySingleton<SslPaymentService>(() => SslPaymentService());
}
