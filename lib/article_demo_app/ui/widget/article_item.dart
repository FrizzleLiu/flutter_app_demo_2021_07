import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../page/article_detail.dart';

class ArticleItem extends StatelessWidget {
  final itemData;

  const ArticleItem(this.itemData);

  @override
  Widget build(BuildContext context) {
    var author = new Row(

      ///水平线性布局
      children: <Widget>[

        ///expand 最后摆放,相当于linearlayout的weight权重
        new Expanded(
            child: Text.rich(TextSpan(children: [
              TextSpan(text: "作者: "),
              TextSpan(
                  text: itemData['author'],
                  style: TextStyle(color: Theme
                      .of(context)
                      .primaryColor))
            ]))),
        Text(itemData['niceDate'])
      ],
    );

    ///标题
    Text title = Text(
      itemData['title'],
      style: TextStyle(fontSize: 16.0, color: Colors.black),
      textAlign: TextAlign.left,
    );

    Text chapterName = Text(
      itemData['chapterName'],
      style: TextStyle(color: Theme
          .of(context)
          .primaryColor),
    );

    ///垂直线性布局
    Column column = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: EdgeInsets.all(10),
          child: author,),
        Padding(padding: EdgeInsets.fromLTRB(10,5,10,5),
          child: title,),
        Padding(padding: EdgeInsets.fromLTRB(10,5,10,5),
          child: chapterName,),
      ],
    );

    return Card(
      elevation: 4.0,
      child: InkWell(
        child: column,
        onTap: (){
          debugPrint("点击文章");
          Navigator.of(context).push(MaterialPageRoute(builder: (context){
            itemData['url'] = itemData['link'];
            return WebPage(itemData);
          }));
        },
      ),
      
    );
  }
}

///TextSpan(
//               children: TextSpan(text: "作者: "),
//               TextSpan(text: itemData['author']),
//             )
