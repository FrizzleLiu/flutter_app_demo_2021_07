import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(RouteApp());
}

class RouteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "第一个界面",
      home: FirstPageDetail(),
    );
  }
}

class FirstPageDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("第一个界面"),
      ),
      body: ElevatedButton(
          onPressed: () => {
                Navigator.push(context, MaterialPageRoute(builder: (_) {
                  return Page2();
                })).then((value) => debugPrint(value))
              },
          child: Text("跳转第二个界面")),
    );
  }
}

class Page2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("第二个界面"),
      ),
      body: ElevatedButton(
        onPressed: () {
          Navigator.pop(context,"第二个界面返回的数据");
        },
        child: Text("返回"),
      ),
    );
  }
}
