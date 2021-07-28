import 'dart:io';
import 'dart:isolate';

void main () {
  var receivePort = ReceivePort();
  Isolate.spawn(entryPoint, receivePort.sendPort);
  receivePort.listen((message) {
    if(message is String){
      print(message);//输出: 子Isolate发送消息
    }else if(message is SendPort){
      message.send("主Isolate发送消息");
    }
  });
  //这里延迟会阻塞上面的接收回调
  // sleep(Duration(seconds: 10));
  // receivePort.close();
}

void entryPoint(SendPort sendPort){
  sendPort.send("子Isolate发送消息");
  var receivePort = ReceivePort();
  sendPort.send(receivePort.sendPort);//将子Isolate的sendPort发送给主Isolate
  receivePort.listen((message) {
    print(message);//输出: 主Isolate发送消息
  });
  // receivePort.close(); 同上
}