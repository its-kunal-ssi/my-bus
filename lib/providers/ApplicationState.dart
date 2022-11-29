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
  List<dynamic> lisBuses = [];
  ApplicationState() {
    init();
  }
  Future<void> init() async {
    FirebaseApp app = await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    FirebaseUIAuth.configureProviders([EmailAuthProvider()]);
    fireauth = FirebaseAuth.instanceFor(app: app);
    fireauth.authStateChanges().listen((event) {
      if (event != null) {
        _loggedIn = true;
        syncLocations();
        notifyListeners();
      } else {
        _loggedIn = false;
        notifyListeners();
      }
    });
    db = FirebaseDatabase.instanceFor(app: app);
    firedb = FirebaseFirestore.instanceFor(app: app);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> createBus(String busno, String busname, String busmodel,
      String driver, String driverId, BuildContext context) async {
    await firedb.collection('buses').doc(busno).set({
      "driver": driver,
      "driverId": driverId,
      "busModel": busmodel,
      "name": busname,
      "busn0": busno
    });
    Navigator.pop(context);
  }

  void SignOutUser() {
    FirebaseAuth.instance.signOut();
    notifyListeners();
  }

  Future<void> getData() async {
    busesData = firedb.collection('buses').snapshots();
    print(lisBuses);
  }

  Future<void> removeBus(String busno) async {
    await firedb.collection('buses').doc(busno).delete();
  }

  Future<void> syncLocations() async {
    var adb = [];
    firedb.collection('buses').snapshots().listen((event) {
      adb.clear();
      event.docs.forEach((element) {
        adb.add({...element.data(), "busno": element.id});
      });
      adb.forEach((element) {
        print(element['driverid']);
        if (element['driverid'] == fireauth.currentUser!.uid.toString()) {
          Geolocator.getPositionStream(
                  locationSettings: LocationSettings(
                      accuracy: LocationAccuracy.best, distanceFilter: 0))
              .listen((event) async {
            db.ref("buses/${element['busno']}").set({
              "lat": event.latitude,
              "long": event.longitude,
              "timestamp": DateTime.now().millisecondsSinceEpoch
            });
          });
        }
      });
    });
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
