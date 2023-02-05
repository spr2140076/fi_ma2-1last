import 'package:fi_ma/view/notification.dart';
import 'package:fi_ma/view/register/exin_detail_edit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Menu extends StatefulWidget {
  const Menu({super.key, });

  @override
  State<Menu> createState() => _Menu();
}

class _Menu extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        title: Text('メニュー', style: TextStyle(fontSize: 25),),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(height: 100,),
            Container(
              width: 150,
              height: 80,
              margin: EdgeInsets.all(8),
              child: ElevatedButton(
                child:  Text('通知' ,style: TextStyle(fontSize: 25),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => CupertinoSwitchTile(title: true, value: true, onChanged: (bool ) {  },),
                    )
                  );
                },
              ),
            ),
            SizedBox(height: 30,),
            Container(
              width: 150,
              height: 80,
              margin: EdgeInsets.all(8),
              child: ElevatedButton(
                child: const Text('ログアウト', style: TextStyle(fontSize: 22),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: (){
                  showCupertinoDialog(
                    context: context,
                    builder: (context){
                      return CupertinoAlertDialog(
                        title: Text('ログアウト'),
                        content: Text('ログアウトしますか？'),
                        actions: [
                          CupertinoDialogAction(
                            child: Text('キャンセル'),
                            onPressed: (){
                              Navigator.pop(context);
                            },
                          ),
                          CupertinoDialogAction(
                            isDestructiveAction: true,
                            child: Text('ログアウト'),
                            onPressed: (){
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 30,),
            Container(
              width: 150,
              height: 80,
              margin: EdgeInsets.all(8),
              child: ElevatedButton(
                child: const Text('リセット', style: TextStyle(fontSize: 25),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: (){
                  showCupertinoDialog(
                    context: context,
                    builder: (context){
                      return CupertinoAlertDialog(
                        title: Text('リセット'),
                        content: Text('リセットしますか？'),
                        actions: [
                          CupertinoDialogAction(
                            child: Text('キャンセル'),
                            onPressed: (){
                              Navigator.pop(context);
                            },
                          ),
                          CupertinoDialogAction(
                            isDestructiveAction: true,
                            child: Text('リセット'),
                            onPressed: (){
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {                                       // ＋ボタンを押したときの処理を設定
          await Navigator.of(context).push(                         // ページ遷移をNavigatorで設定
            MaterialPageRoute(
                builder: (context) => const ExpenseDetailEdit()           // 詳細更新画面（元ネタがないから新規登録）を表示するcat_detail_edit.dartへ遷移
            ),
          );
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
