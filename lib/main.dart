import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mybus/firebase_options.dart';
import 'package:mybus/providers/ApplicationState.dart';
import 'package:mybus/utils/Appbar.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ApplicationState(),
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          routes: {
            '/sign-in': (context) {
              return SignInScreen(
                providers: [EmailAuthProvider()],
                actions: [
                  AuthStateChangeAction(
                    (context, state) {
                      Navigator.pushReplacementNamed(context, '/');
                    },
                  )
                ],
              );
            }
          },
          home: HomePage(),
        );
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: Container(
        child: Text("Hello"),
      ),
    );
  }
}
