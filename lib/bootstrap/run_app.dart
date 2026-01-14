import 'package:flutter/material.dart';

import '../core/config/app_config.dart';
import 'app.dart';
import 'di/service_locator.dart';
import '../core/storage/storage_service.dart';

Future<void> runAppWithConfig(AppConfig config) async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupServiceLocator(config);
  await getIt<StorageService>().init();
  runApp(MyApp(config: config));
}
