import 'package:flutter/material.dart';
import 'package:flutter_app01/article_demo_app/common/event/events.dart';
import 'package:flutter_app01/article_demo_app/common/http/api.dart';
import 'package:flutter_app01/article_demo_app/manager/app_manager.dart';
import 'package:flutter_app01/article_demo_app/ui/page/collect_page.dart';
import 'package:flutter_app01/article_demo_app/ui/page/login_page.dart';

class MainDrawer extends StatefulWidget {
  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  String? _userName;

  @override
  void initState() {
    super.initState();
    AppManager.eventBus.on<LoginEvent>().listen((event) {
      setState(() {
        _userName = event.username;
        AppManager.prefs?.setString(AppManager.ACCOUNT, _userName!);
      });
    });
    _userName = AppManager.prefs?.getString(AppManager.ACCOUNT);
  }

  void _itemClick(Widget? page) {
    //如果未登录 进入登录界面
    var targetPage = _userName == null ? LoginPage() : page;
    if (targetPage != null) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return targetPage;
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    var drawerHeader = DrawerHeader(
      decoration: const BoxDecoration(color: Colors.blue),
      child: InkWell(

        ///点击计入登录界面
        onTap: () => _itemClick(null),
        child: Column(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(bottom: 18.0),
              child: CircleAvatar(
                backgroundImage: AssetImage("assets/images/logo.png"),
                radius: 38.0,
              ),
            ),
            Text(
              _userName ?? "请先登录",
              style: const TextStyle(color: Colors.white, fontSize: 18.0),
            )
          ],
        ),
      ),
    );

    return ListView(
      ///不设置会导致状态栏灰色
      padding: EdgeInsets.zero,
      children: [
        drawerHeader,
        InkWell(
          onTap: () => _itemClick(CollectPage()),
          child: const ListTile(
            leading: Icon(Icons.favorite),
            title: Text(
              "收藏列表",
              style: TextStyle(fontSize: 16.0),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(18.0, 0.0, 18.0, 0.0),
          child: Divider(
            color: Colors.grey,
          ),
        ),

        ///退出登录
        Offstage(
          ///可控制隐藏和显示
          offstage: _userName == null,
          child: InkWell(
            onTap: (){
              setState(() {
                _userName = null;
                Api.clearCooike();
                AppManager.prefs?.setString(AppManager.ACCOUNT, _userName == null ? ""  :_userName!);
                AppManager.eventBus.fire(LogoutEvent());
              });
            },
            child: const ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text("退出登录",style: TextStyle(fontSize: 16.0),),
            ),
          )
        )
      ],
    );
  }
}
