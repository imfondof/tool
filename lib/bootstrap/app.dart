import 'package:flutter/material.dart';

import '../core/config/app_config.dart';
import '../core/routing/app_router.dart';
import '../core/routing/app_routes.dart';
import '../core/theme/app_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.config});

  final AppConfig config;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: config.appName,
      theme: AppTheme.light(),
      onGenerateRoute: AppRouter.onGenerateRoute,
      initialRoute: AppRoutes.login,
      debugShowCheckedModeBanner: config.isDev,
    );
  }
}
