import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mybus/firebase_options.dart';

class ApplicationState extends ChangeNotifier {
  bool _isLoading = true, _loggedIn = false;
  bool get isLoading => _isLoading;
  bool get loggedIn => _loggedIn;
  late FirebaseAuth fireauth;
  late FirebaseDatabase db;
  late FirebaseFirestore firedb;
  late Stream<QuerySnapshot> busesData;
  bool isSyncLocations = true;
  List<dynamic> lisBuses = [];
  late StreamSubscription<Position> _PositionStream;

  StreamSubscription<Position> get PositionStream => _PositionStream;

  set PositionStream(StreamSubscription<Position> PositionStream) {
    _PositionStream = PositionStream;
  }

  late Position currLoc;

  ApplicationState() {
    init();
  }
  Future<void> init() async {
    await Geolocator.checkPermission().then((value) {
      if (value == LocationPermission.denied ||
          value == LocationPermission.deniedForever) {
        Geolocator.requestPermission();
      }
    });
    _isLoading = true;
    notifyListeners(); 
    PositionStream = Geolocator.getPositionStream(
            locationSettings: LocationSettings(accuracy: LocationAccuracy.best))
        .listen((event) async {
      currLoc = event;
      print(event);
      notifyListeners();
      lisBuses.forEach((element) {
        if (element["driverId"] == fireauth.currentUser?.uid) {
          db.ref("buses/${element['busno']}").set({
            "lat": event.latitude,
            "long": event.longitude,
            "timestamp": DateTime.now().millisecondsSinceEpoch
          });
        }
      });
      await Future.delayed(Duration(seconds: 5));
    });
    FirebaseApp app = await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    FirebaseUIAuth.configureProviders([EmailAuthProvider()]);
    fireauth = FirebaseAuth.instanceFor(app: app);
    db = FirebaseDatabase.instanceFor(app: app);
    firedb = FirebaseFirestore.instanceFor(app: app);
    fireauth.authStateChanges().listen((event) {
      if (event != null) {
        _loggedIn = true;
        notifyListeners();
      } else {
        _loggedIn = false;
        notifyListeners();
      }
    });
    firedb.collection('buses').snapshots().listen((event) {
      lisBuses.clear();
      event.docs.forEach((element) {
        lisBuses.add(
            {"busno": element.id, ...element.data() as Map<String, dynamic>});
      });
      notifyListeners();
    });
    _isLoading = false;
    notifyListeners();
  }

  void setIsSyncLoc(bool bb) {
    isSyncLocations = bb;
    if (isSyncLocations) {
      _PositionStream.resume();
    } else {
      _PositionStream.pause();
    }
    notifyListeners();
  }

  Future<void> createBus(String busno, String busname, String busmodel,
      String driver, String driverId, BuildContext context) async {
    await firedb.collection('buses').doc(busno).set({
      "driver": driver,
      "driverId": driverId,
      "busModel": busmodel,
      "name": busname,
      "busno": busno
    });
    Navigator.pop(context);
  }

  void SignOutUser() {
    FirebaseAuth.instance.signOut();
    notifyListeners();
  }

  Future<void> removeBus(String busno) async {
    await firedb.collection('buses').doc(busno).delete();
  }
}

class Bus {
  String driver, driverid, busModel;
  LatLng busLoc;
  Bus(
      {required this.driver,
      required this.driverid,
      required this.busModel,
      required this.busLoc});
  Map<String, dynamic> toMap() => {
        "driver": driver,
        "driverid": driverid,
        "busModel": busModel,
        "busLoc": busLoc
      };
}


// sync bus data with application state


