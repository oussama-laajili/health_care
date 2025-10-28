import 'package:flutter/material.dart';
import 'package:health_care/ui/launding_screen/launching_screen.dart';
import 'package:provider/provider.dart';

import 'ui/login_screen/login_provider.dart';
import 'providers/loader_provider.dart';
import 'shared/widgets/global_loader.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => LoaderProvider()),
      ],
      child: MaterialApp(
        title: 'Health Care',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const GlobalLoader(
          child: LaunchingScreen(),
        ),
      ),
    );
  }
}
