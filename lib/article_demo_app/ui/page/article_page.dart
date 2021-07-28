import 'package:flutter/material.dart';
import 'package:flutter_app01/article_demo_app/common/http/api.dart';
import 'package:banner_carousel/banner_carousel.dart';
import 'package:flutter_app01/article_demo_app/ui/widget/article_item.dart';
import 'package:flutter_app01/article_demo_app/ui/widget/main_drawer.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ArticlePage extends StatefulWidget {
  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  ///滑动控制器
  var _controller = ScrollController();

  ///列表是否隐藏,隐藏时显示加载框
  bool _isHide = true;

  ///文章数据
  List articles = [];

  ///banner数据
  List banners = [];

  ///文章总数
  var totalCount = 0;

  ///分页-页码
  var curPage = 0;

  //点击返回事件
  var _lastClick;

  ///initState只会执行一次,进行一些初始化操作
  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      ///获取SrollController 监听控件可以滚动的最大范围
      var maxScroll = _controller.position.maxScrollExtent;

      ///获取当前位置的像素设置
      var pixels = _controller.position.pixels;

      if (maxScroll == pixels && curPage < totalCount) {
        _getArticleList();
      }
    });

    ///初始化完成触发一次加载
    _pullToRefresh();
  }

  ///加载文章数据
  _getArticleList([bool update = true]) async {
    debugPrint("加载文章");
    var data = await Api.getArticleList(curPage);
    if (null != data) {
      var map = data['data'];
      var datas = map['datas'];
      totalCount = map["pageCount"];
      if (curPage == 0) {
        articles.clear();
      }
      curPage++;
      articles.addAll(datas);

      if (update) {
        setState(() {});
      }
    }
  }

  _getBanner([bool update = true]) async {
    var data = await Api.getBanner();
    banners.clear();
    banners.addAll(data['data']);
    if (update) {
      setState(() {});
    }
  }

  ///刷新,加载文章/banner数据
  Future<void> _pullToRefresh() async {
    curPage = 0;
    Iterable<Future> futures = [_getArticleList(), _getBanner()];
    await Future.wait(futures);
    _isHide = false;
    setState(() {});
    return null;
  }

  ///dispose释放滑动控制器
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  ///布局
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          //在一定的时间内 2s点击两次才能返回
          if (_lastClick == null ||
              DateTime.now().difference(_lastClick) > Duration(seconds: 2)) {
            _lastClick = DateTime.now();
            Fluttertoast.showToast(msg:"请再按一次退出!");
            return false;
          }
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              '文章',
              style: const TextStyle(color: Colors.white),
            ),
          ),
          drawer: Drawer(
            child: MainDrawer(),
          ),
          body: Stack(
            children: <Widget>[
              ///正在加载
              Offstage(
                offstage: !_isHide, //是否隐藏
                child: new Center(child: CircularProgressIndicator()),
              ),

              ///内容
              Offstage(
                offstage: _isHide,
                child: RefreshIndicator(
                    child: ListView.builder(
                      itemCount: articles.length + 1,
                      itemBuilder: (context, i) => _buildItem(i),
                      controller: _controller,
                    ),
                    onRefresh: _pullToRefresh),
              ),
              Offstage(
                offstage: _isHide || articles.isNotEmpty, //是否隐藏
                child: Center(
                    child: InkWell(
                      child: const Text("(＞﹏＜) 点击重试......"),
                      onTap: () {
                        setState(() {
                          _isHide = true;
                        });
                        _pullToRefresh();
                      },
                    )),
              ),
            ],
          ),
        ));
  }

  /// ListView Item布局
  Widget _buildItem(int i) {
    if(i == 0){
      return Container(
        height: MediaQuery.of(context).size.height*0.3,
        child:  _bannerView(),
      );
    }else {
      var itemData = articles[i - 1];
      return ArticleItem(itemData);
    }
  }

  ///创建BannerView
  Widget _bannerView() {
    List<BannerModel> bannerModels= banners.map((item) => BannerModel(imagePath: item['imagePath'],id: "1")).toList();
    debugPrint("${bannerModels.toString()}---------${bannerModels.length} ");
    return BannerCarousel.fullScreen(
      banners: bannerModels,
      height: 180,
    );
  }

}