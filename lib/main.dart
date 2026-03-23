import 'package:flutter/material.dart';

import 'core/initial_bindings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DI.initialize();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(body: Center(child: Text('Hello World!'))),
    );
  }
}
