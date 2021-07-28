import 'package:flutter/material.dart';

void main() {
  var myApp01 = _MyApp01();
  runApp(myApp01);
}

class _MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: const Text("Title"),),
          body: const Center(child: Text("Hello Flutter", textDirection: TextDirection.ltr)),
    ));
  }
}

class _MyApp01 extends StatefulWidget {
  @override
  _MyApp01State createState() => _MyApp01State();
}

class _MyApp01State extends State<_MyApp01> {
  String title = "Title";

  _MyApp01State(){
    Future.delayed(Duration(seconds: 3)).then((value) {
      title = "改变";
      setState(() {
        debugPrint("调用了setState");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: Text(title),),
          body: const Center(child: Text("Hello Flutter")),
        ));
  }

  @override
  void initState() {
    super.initState();
    debugPrint("声明周期: initState");
  }

  @override
  void activate() {
    // TODO: implement activate
    super.activate();
  }
}

