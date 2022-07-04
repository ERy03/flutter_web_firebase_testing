import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Authentication
class MyAuthPage extends StatefulWidget {
  @override
  _MyAuthPageState createState() => _MyAuthPageState();
}

class _MyAuthPageState extends State<MyAuthPage> {
  // 入力されたメールアドレス
  String newUserEmail = "";
  // 入力されたパスワード
  String newUserPassword = "";
  // 登録・ログインに関する情報を表示
  String infoText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.all(32),
          child: Column(
            children: <Widget>[
              TextFormField(
                // テキスト入力のラベルを設定
                decoration: InputDecoration(labelText: "メールアドレス"),
                onChanged: (String value) {
                  setState(() {
                    newUserEmail = value;
                  });
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                decoration: InputDecoration(labelText: "パスワード（６文字以上）"),
                // パスワードが見えないようにする
                obscureText: true,
                onChanged: (String value) {
                  setState(() {
                    newUserPassword = value;
                  });
                },
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () async {
                  try {
                    // メール/パスワードでユーザー登録
                    final FirebaseAuth auth = FirebaseAuth.instance;
                    final UserCredential result =
                        await auth.createUserWithEmailAndPassword(
                      email: newUserEmail,
                      password: newUserPassword,
                    );

                    // 登録したユーザー情報
                    final User user = result.user!;
                    setState(() {
                      infoText = "登録OK：${user.uid}";
                    });
                  } catch (e) {
                    // 登録に失敗した場合
                    setState(() {
                      infoText = "登録NG：${e.toString()}";
                    });
                  }
                },
                child: Text("ユーザー登録"),
              ),
              const SizedBox(height: 8),
              Text(infoText)
            ],
          ),
        ),
      ),
    );
  }
}

// FireStorePage
class MyFirestorePage extends StatefulWidget {
  @override
  MyFirestorePageState createState() => MyFirestorePageState();
}

class MyFirestorePageState extends State<MyFirestorePage> {
  List<DocumentSnapshot> documentList = [];
  String orderDocumentInfo = "";
  // 引数からユーザー情報を受け取れるようにする
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: size * 0.05,
              ),
              ElevatedButton(
                child: Text('コレクション＋ドキュメント作成'),
                onPressed: () async {
                  // ドキュメント作成
                  await FirebaseFirestore.instance
                      .collection('users') // コレクションID // addでドキュメントIDを自動生成
                      .add({'name': '鈴木', 'age': 40}); // データ
                },
              ),
              SizedBox(
                height: size * 0.05,
              ),
              ElevatedButton(
                child: Text('サブコレクション＋ドキュメント作成'),
                onPressed: () async {
                  // サブコレクション内にドキュメント作成
                  await FirebaseFirestore.instance
                      .collection('users') // コレクションID
                      .doc(
                          'LshPAzjp4kAS0K6fczrm') // ドキュメントID << usersコレクション内のドキュメント
                      .collection('orders') // サブコレクションID
                      .add({'price': 600, 'date': '9/13'}); // データ
                },
              ),
              SizedBox(
                height: size * 0.05,
              ),
              ElevatedButton(
                child: Text('ドキュメント一覧取得'),
                onPressed: () async {
                  // コレクション内のドキュメント一覧を取得
                  final snapshot = await FirebaseFirestore.instance
                      .collection('users')
                      .get();
                  // 取得したドキュメント一覧をUIに反映
                  setState(() {
                    documentList = snapshot.docs;
                  });
                },
              ),
              // コレクション内のドキュメント一覧を表示
              Column(
                children: documentList.map((document) {
                  return ListTile(
                    title: Text('${document['name']}さん'),
                    subtitle: Text('${document['age']}歳'),
                  );
                }).toList(),
              ),
              SizedBox(
                height: size * 0.05,
              ),
              ElevatedButton(
                child: Text('ドキュメントを指定して取得'),
                onPressed: () async {
                  // コレクションIDとドキュメントIDを指定して取得
                  final document = await FirebaseFirestore.instance
                      .collection('users')
                      .doc('LshPAzjp4kAS0K6fczrm')
                      .collection('orders')
                      .doc('JoMNCtA7d6pUVQalqx83')
                      .get();
                  // 取得したドキュメントの情報をUIに反映
                  setState(() {
                    orderDocumentInfo =
                        '${document['date']} ${document['price']}円';
                  });
                },
              ),
              // ドキュメントの情報を表示
              ListTile(title: Text(orderDocumentInfo)),
              SizedBox(
                height: size * 0.05,
              ),
              ElevatedButton(
                child: Text('ドキュメント更新'),
                onPressed: () async {
                  // ドキュメント更新
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc('LshPAzjp4kAS0K6fczrm')
                      .update({'age': 41});
                },
              ),
              SizedBox(
                height: size * 0.05,
              ),
              ElevatedButton(
                child: Text('ドキュメント削除'),
                onPressed: () async {
                  // ドキュメント削除
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc('oz4XERIUrev1CfEVNBXN')
                      .delete();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
