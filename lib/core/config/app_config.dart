enum AppEnvironment { dev, prod }

class AppConfig {
  const AppConfig._({
    required this.environment,
    required this.baseUrl,
    required this.appName,
  });

  final AppEnvironment environment;
  final String baseUrl;
  final String appName;

  bool get isDev => environment == AppEnvironment.dev;

  factory AppConfig.dev() {
    return const AppConfig._(
      environment: AppEnvironment.dev,
      baseUrl: 'https://api.dev.example.com',
      appName: 'Tool (Dev)',
    );
  }

  factory AppConfig.prod() {
    return const AppConfig._(
      environment: AppEnvironment.prod,
      baseUrl: 'https://api.example.com',
      appName: 'Tool',
    );
  }
}
