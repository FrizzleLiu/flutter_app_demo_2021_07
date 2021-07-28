
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class WebPage extends StatefulWidget {
  final itemData;

  WebPage(this.itemData);

  @override
  State<WebPage> createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {
  bool isLoading = true;
  late FlutterWebviewPlugin flutterWebviewPlugin;

  @override
  void initState() {
    super.initState();
    debugPrint("初始化FlutterWebviewPlugin");
    debugPrint("初始化mounted : $mounted");
    flutterWebviewPlugin = FlutterWebviewPlugin();
    flutterWebviewPlugin.onProgressChanged.listen((progress) {
      debugPrint("FlutterWebview progress回调: ${progress}");
      if (mounted && progress == 1.0) {
        isLoading = false;
        setState(() {});
      } else if (progress < 1.0) {
        isLoading = true;
        setState(() {});
      }
    });
    flutterWebviewPlugin.onStateChanged.listen((state) {
      debugPrint("初始化mounted : $mounted");
      debugPrint("FlutterWebviewPlugin回调${state.type}");
      if (mounted && state.type == WebViewState.finishLoad) {
        isLoading = false;
        setState(() {});
      } else if (state.type == WebViewState.startLoad) {
        isLoading = true;
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    flutterWebviewPlugin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      appBar: AppBar(
        title: Text(widget.itemData['title']),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: LinearProgressIndicator(),
        ),
        bottomOpacity: isLoading ? 1.0 : 0.0,
      ),
      url: widget.itemData['url'],
      withJavascript: true,
      withLocalStorage: true,
    );
  }
}
