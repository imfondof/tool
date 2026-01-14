import 'bootstrap/run_app.dart';
import 'core/config/app_config.dart';

Future<void> main() async {
  await runAppWithConfig(AppConfig.prod());
}
