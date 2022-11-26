import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:mybus/firebase_options.dart';

class ApplicationState extends ChangeNotifier {
  bool _isLoading = true, _loggedIn = false;
  bool get isLoading => _isLoading;
  bool get loggedIn => _loggedIn;
  ApplicationState() {
    init();
  }
  Future<void> init() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    _isLoading = false;
    notifyListeners();
    FirebaseUIAuth.configureProviders([EmailAuthProvider()]);
    FirebaseAuth.instance.authStateChanges().listen((event) {
      if (event != null) {
        _loggedIn = true;
        notifyListeners();
      } else {
        _loggedIn = false;
        notifyListeners();
      }
    });
  }

  void SignOutUser() {
    FirebaseAuth.instance.signOut();
    notifyListeners();
  }
}
