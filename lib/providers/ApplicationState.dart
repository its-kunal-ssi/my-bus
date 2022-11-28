import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:mybus/firebase_options.dart';

class ApplicationState extends ChangeNotifier {
  bool _isLoading = true, _loggedIn = false;
  bool get isLoading => _isLoading;
  bool get loggedIn => _loggedIn;
  late FirebaseDatabase _db;
  FirebaseDatabase get db => _db;
  ApplicationState() {
    init();
  }
  Future<void> init() async {
    FirebaseApp app = await Firebase.initializeApp(
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
    _db = FirebaseDatabase.instanceFor(app: app);
  }

  void SignOutUser() {
    FirebaseAuth.instance.signOut();
    notifyListeners();
  }
}
