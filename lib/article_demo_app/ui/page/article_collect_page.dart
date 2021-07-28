import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app01/article_demo_app/common/event/events.dart';
import 'package:flutter_app01/article_demo_app/common/http/api.dart';
import 'package:flutter_app01/article_demo_app/manager/app_manager.dart';
import 'package:flutter_app01/article_demo_app/ui/widget/article_item.dart';

class ArticleCollectPage extends StatefulWidget {
  @override
  _ArticleCollectPageState createState() => _ArticleCollectPageState();
}

///AutomaticKeepAliveClientMixin Tab左右切换页面不会销毁重建
class _ArticleCollectPageState extends State<ArticleCollectPage>
    with AutomaticKeepAliveClientMixin {
  bool _isHidden = false;
  ScrollController? _controller = ScrollController();

  ///收藏列表
  List _collects = [];
  var _curPage = 0;
  var _pageCount = 0;
  StreamSubscription<CollectEvent>? _collectEventListener;

  @override
  void initState() {
    super.initState();
    _controller?.addListener(() {
      //获得ScrollController监听控件可以滑动的最大范围
      var maxScrollExtent = _controller?.position.maxScrollExtent;

      /// 获取当前像素值
      var pixels = _controller?.position.pixels;
      if (maxScrollExtent == pixels && _curPage < _pageCount) {
        ///加载更多
        _getCollects();
      }
    });
    AppManager.eventBus.on<CollectEvent>().listen((event) {
      //页面没有被dispose
      if (mounted) {
        //取消收藏
        if (!event.collect) {
          _collects.removeWhere((element) {
            return element['id'] == event.id;
          });
        }
      }
    });
    _getCollects();
  }

  @override
  void dispose() {
    _collectEventListener?.cancel();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Offstage(
          offstage: _isHidden,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
        Offstage(
          offstage: _collects.isNotEmpty || !_isHidden,
          child: const Center(
            child: Text("(＞﹏＜) 你还没有收藏任何内容......"),
          ),
        ),
        Offstage(
          offstage: _collects.isEmpty,
          child: RefreshIndicator(
            onRefresh: ()=> _getCollects(true),
            child: ListView.builder(
              ///总是能滑动，因为数据少，listview无法滑动，
              ///RefreshIndicator 就无法更新
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: _collects.length,
              itemBuilder: (context,i) => _buildItem(i),
              controller: _controller,
            ),
          ),
        )
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;

  ///加载收藏数据
  _getCollects([bool refresh = false]) async {
    if (refresh) {
      _curPage = 0;
    }
    var articleList = await Api.getArticleList(_curPage);
    if (articleList != null) {
      if (_curPage == 0) {
        _collects.clear();
      }
      _curPage++;
      var datas = articleList['data'];
      _pageCount = datas['pageCount'];
      _collects.addAll(datas['datas']);
      _isHidden = true;
      setState(() {});
    }
  }

  _buildItem(int i) {
    //只收藏站内
    _collects[i]['id'] = _collects[i]['originId'];
    _collects[i]['collect'] = true;
    return ArticleItem(_collects[i]);
  }
}
