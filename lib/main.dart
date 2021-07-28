import 'package:flutter/material.dart';

import 'article_demo_app/ui/page/page_splash.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (context) => SplashPage(),
      },
    );
  }
}
