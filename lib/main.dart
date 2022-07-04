import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_firebase_testing/addPost.dart';
import 'package:flutter_web_firebase_testing/chatPage.dart';
import 'package:flutter_web_firebase_testing/auth/secrets.dart';
import 'package:flutter_web_firebase_testing/login.dart';
import 'package:flutter_web_firebase_testing/practice.dart';
import 'package:go_router/go_router.dart';

Future<void> main() async {
  // Firebase初期化
  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: firebaseApiKey,
        authDomain: firebaseAuthDomain,
        projectId: firebaseProjectId,
        storageBucket: firebaseStorageBucket,
        messagingSenderId: firebaseMessagingSenderId,
        appId: firebaseAppId,
        measurementId: firebaseMeasurementId),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationProvider: _router.routeInformationProvider,
      routeInformationParser: _router.routeInformationParser,
      routerDelegate: _router.routerDelegate,
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: MyAuthPage(),
      // home: MyFirestorePage(),
    );
  }

  final GoRouter _router = GoRouter(
    initialLocation: "/login",
    routes: <GoRoute>[
      GoRoute(
        name: "login",
        path: '/login',
        builder: (BuildContext context, GoRouterState state) => LoginPage(),
      ),
      GoRoute(
        name: "home",
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return ChatPage(state.extra as User);
        },
      ),
      GoRoute(
        name: "add",
        path: '/add',
        builder: (BuildContext context, GoRouterState state) {
          return AddPostPage(state.extra as User);
        },
      ),
    ],
  );
}
