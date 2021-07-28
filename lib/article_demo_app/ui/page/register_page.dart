import 'package:flutter/material.dart';
import 'package:flutter_app01/article_demo_app/common/http/api.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  FocusNode _userNameNode = FocusNode();
  FocusNode _pwdNode = FocusNode();
  FocusNode _rePwdNode = FocusNode();
  String? _username, _pwd, rePwd;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("注册"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 12.0),
          children: [
            _buildUserName(),
            _buildPwd(),
            _buildRePwd(),
            _buildRegister()
          ],
        ),
      ),
    );
  }

  ///用户名
  Widget _buildUserName() {
    return TextFormField(
      autofocus: true,
      decoration: const InputDecoration(labelText: "用户名"),

      ///键盘动作类型
      onEditingComplete: () {
        FocusScope.of(context).requestFocus(_pwdNode);
      },

      ///输入内容校验
      validator: (String? value) {
        if (value!.trim().isEmpty) {
          return "请输入用户名";
        }
        _username = value;
      },
    );
  }

  Widget _buildPwd() {
    return TextFormField(
      focusNode: _pwdNode,
      autofocus: true,
      obscureText: true, ///密码样式输入,默认隐藏
      decoration: const InputDecoration(labelText: "密码"),

      ///键盘动作
      onEditingComplete: () {
        FocusScope.of(context).requestFocus(_rePwdNode);
      },
      validator: (String? value) {
        if (value!.trim().isEmpty) {
          return "请输入用密码";
        }
        _pwd = value;
      },
    );
  }

  Widget _buildRePwd() {
    return TextFormField(
      autofocus: true,
      focusNode: _rePwdNode,
      obscureText: true, ///密码样式输入,默认隐藏
      decoration: const InputDecoration(labelText: "确认密码"),
      textInputAction: TextInputAction.go,
      onEditingComplete: () {
        _click();
      },
      validator: (String? value) {
        if (value!.trim().isEmpty) {
          //错误提示
          return "请确认密码";
        }

        if (_pwd != value) {
          return "两次密码输入不一致";
        }
        rePwd = value;
      },
    );
  }

  ///注册
  void _click() async{
    ///点击注册 隐藏软键盘
    _userNameNode.unfocus();
    _pwdNode.unfocus();
    _rePwdNode.unfocus();
    ///校验输入内容
    if(_formKey.currentState!.validate()){
      ///验证通过弹出一个弹窗,不允许返回键dismiss
      showDialog(context: context,barrierDismissible: false, builder: (_){
        return const Center(child: CircularProgressIndicator(),);
      });
      ///执行注册逻辑
      var result = await Api.register(_username!, _pwd!);
      ///隐藏对话框
      Navigator.pop(context);
      if(result['errorCode'] == -1){
        var error = result['errorMsg'];
        //弹出提示SnackBar样式
//        _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(error),));
        //弹出提示Toast样式
        Fluttertoast.showToast(msg: error);
      }else{
        //3 种方案
        //1、直接使用第三方
        //2、利用Flutter自己实现
        //3、通过插件调用到android的toast
        Fluttertoast.showToast(msg: "注册成功!");
        Navigator.pop(context);
      }
    }
  }

  Widget _buildRegister() {
    return ElevatedButton(onPressed: _click, child: const Text("注册"));
  }
}
