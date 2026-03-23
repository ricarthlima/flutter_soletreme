import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'core/initial_bindings.dart';
import 'features/game_maze/presentation/ui/game_screen.dart';
import 'features/privacy/presentation/ui/privacy_screen.dart';
import 'shared/theme/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  usePathUrlStrategy();

  await DI.initialize();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'soletre.me',
      debugShowCheckedModeBanner: false,
      scrollBehavior: MyCustomScrollBehavior(),
      theme: ThemeData(
        primarySwatch: Colors.green,
        primaryColor: AppColors.darkBackground,
        fontFamily: 'RubikMonoOne',
        appBarTheme: const AppBarTheme(foregroundColor: Colors.white),
      ),
      initialRoute: "/",
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case "/":
            return MaterialPageRoute(builder: (_) => const GameScreen());

          case "/privacy":
            return MaterialPageRoute(builder: (_) => const PrivacyScreen());

          default:
            return MaterialPageRoute(builder: (_) => const GameScreen());
        }
      },
    );
  }
}

/// Essencial para o usuário de PC conseguir arrastar o dedo/mouse no labirinto
class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
  };
}
