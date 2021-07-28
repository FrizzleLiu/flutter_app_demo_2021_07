import 'package:flutter/material.dart';
import 'package:flutter_app01/article_demo_app/common/event/events.dart';
import 'package:flutter_app01/article_demo_app/common/http/api.dart';
import 'package:flutter_app01/article_demo_app/manager/app_manager.dart';
import 'package:flutter_app01/article_demo_app/ui/page/register_page.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  FocusNode _pwdNode = FocusNode();
  String? _username, _password;
  bool _isObscure = true;
  Color? _pwdIconColor;

  @override
  void dispose() {
    _pwdNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "登录",
          style: TextStyle(color: Colors.white, fontSize: 16.0),
        ),
      ),
      body: Form(
        key: _formKey,

        ///使用ListView是期望软键盘顶起UI的情况
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 22.0),
          children: [
            _buildUserName(),
            _buildPwd(),
            _buildLogin(),
            _buildRegister(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserName() {
    return TextFormField(
      autofocus: true,
      decoration: const InputDecoration(
        labelText: "用户名"
      ),
      initialValue: _username,
      ///从注册返回username
      ///设置键盘回车键为下一步
      textInputAction: TextInputAction.next,
      onEditingComplete: (){
        FocusScope.of(context).requestFocus(_pwdNode);
      },
      validator: (String? value){
        if(value!.trim().isEmpty){
          return "请输入用户名";
        }
        _username = value;
      },
    );
  }

  Widget _buildPwd() {
    return TextFormField(
      focusNode: _pwdNode,

      ///是否隐藏
      obscureText: _isObscure,
      validator: (String? value) {
        if (value!.trim().isEmpty) {
          return "请输入密码";
        }
        _password = value;
      },
      textInputAction: TextInputAction.done,
      onEditingComplete: _doLogin,
      decoration: InputDecoration(
          labelText: "密码",

          ///输入框尾部密码图标
          suffixIcon: IconButton(
            icon: Icon(
              Icons.remove_red_eye,
              color: _pwdIconColor,
            ),
            onPressed: () {
              setState(() {
                _isObscure = !_isObscure;

                ///密码隐藏 图标颜色改变
                _pwdIconColor = _isObscure ? Colors.grey
                :Theme.of(context).iconTheme.color;
              });
            },
          )),
    );
  }

  Widget _buildLogin() {
    return Container(
      height: 45.0,
      margin: const EdgeInsets.only(top: 18.0, left: 8.0, right: 8.0),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(const Color(0xFF2979FF)),
        ),
        onPressed: _doLogin,
        child: const Text(
          "登录",
          style: TextStyle(fontSize: 16.0, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildRegister() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("没有账号?"),
          GestureDetector(
            child: const Text(
              "点击注册",
              style: TextStyle(color: Colors.green),
            ),
            onTap: () async {
              ///跳转注册界面
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return RegisterPage();
              }));
            },
          )
        ],
      ),
    );
  }

  ///跳转登录
  void _doLogin() async{
    _pwdNode.unfocus();
    ///输入内容通过验证
    if(_formKey.currentState!.validate()){
      debugPrint("登录: $_username $_password");
        var result = await Api.login(_username!, _password!);
        debugPrint("登录结果: ${result.toString()}");
        if(result['errorCode'] == -1){
          Fluttertoast.showToast(msg: result['errorMsg']);
        }else{
          AppManager.eventBus.fire(LoginEvent(_username!));
          Navigator.pop(context);
        }
    }
  }
}
