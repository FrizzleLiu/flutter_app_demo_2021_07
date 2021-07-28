import 'package:flutter/material.dart';
import 'package:flutter_app01/article_demo_app/common/res/icons.dart';
import 'package:flutter_app01/article_demo_app/ui/page/website_collect_page.dart';

import 'article_collect_page.dart';

class CollectPage extends StatefulWidget {
  @override
  State<CollectPage> createState() => _CollectPageState();
}

class _CollectPageState extends State<CollectPage> {
  final tabs = ["文章", "网站"];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: tabs.length, child: Scaffold(
      appBar: AppBar(
        title: const Text("我的收藏"),
        bottom: const TabBar(
          tabs: [
            ///使用iconfont图标之前请配置好ttf字体文件
            Tab(
              icon: Icon(Icons.article),
            ),
            Tab(
              icon: Icon(website,size: 32.0,),
            ),
          ],
        ),
      ),
      body: TabBarView(
        children: [
          ArticleCollectPage(),
          WebsiteCollectPage()
        ],
      ),
    ));
  }
}
