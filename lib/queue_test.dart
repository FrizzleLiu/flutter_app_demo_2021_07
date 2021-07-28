import 'dart:isolate';

void main(){
  var receivePort = ReceivePort();
  receivePort.listen((message) {
    print(message);
  });
  receivePort.sendPort.send("普通队列任务1");
  Future.microtask(() => print("微任务队列 任务1"));
  receivePort.sendPort.send("普通队列任务2");
  Future.microtask(() => print("微任务队列 任务2"));
  receivePort.sendPort.send("普通队列任务3");
  Future.microtask(() => print("微任务队列 任务3"));
  // receivePort.close();
  //输出顺序为:
  // 微任务队列 任务1
  // 微任务队列 任务2
  // 微任务队列 任务3
  // 普通队列任务1
  // 普通队列任务2
  // 普通队列任务3
}