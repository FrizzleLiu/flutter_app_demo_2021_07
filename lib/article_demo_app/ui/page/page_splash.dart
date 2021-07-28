import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app01/article_demo_app/manager/app_manager.dart';

import 'article_page.dart';


class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState()  {
    super.initState();
    initData();
  }

   initData() async{
    ///初始化/等待5s显示splash
     Iterable<Future> futures = [AppManager.initApp(),Future.delayed(Duration(seconds: 3))];
     await Future.wait( futures );
     Navigator.pushReplacement(context, MaterialPageRoute(builder: (_){
       return ArticlePage();
     }));
   }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Image.asset("assets/images/splash.png"),
    );
  }
}




