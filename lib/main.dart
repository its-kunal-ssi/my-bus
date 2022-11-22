import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:mybus/screen/AdminCreateBus.dart';
import 'package:mybus/screen/AuthPage.dart';
import 'package:mybus/screen/SampleMap.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  return runApp(ChangeNotifierProvider(
      create: (context) => ApplicationState(),
      builder: ((context, child) => MyApp())));
}

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }
  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;

  Future<void> init() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    // FirebaseUIAuth.configureProviders([EmailAuthProvider()]);

    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _loggedIn = true;
      } else {
        _loggedIn = false;
      }
      notifyListeners();
    });
    debugPrint('object');
    print(FirebaseAuth.instance);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      title: 'My Bus',
      routes: {
        '/': (context) {
          return const AuthPage();
        },
        '/home': (context) {
          return const HomeScreen('hello from home');
        },
        '/auth': (context) {
          return const AuthPage();
        },
        '/map': (context) {
          return const SampleApp();
        }
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  final String secret;
  const HomeScreen(this.secret, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text('Hello From HomeScreen'),
          TextButton(
              onPressed: (() {
                Navigator.pushNamed(context, '/auth');
              }),
              child: Text('${secret}'))
        ]),
      ),
    );
  }
}
