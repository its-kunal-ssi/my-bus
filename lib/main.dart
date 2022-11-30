import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mybus/firebase_options.dart';
import 'package:mybus/key.dart';
import 'package:mybus/providers/ApplicationState.dart';
import 'package:mybus/screen/IntroPage.dart';
import 'package:mybus/screen/MyBuses.dart';
import 'package:mybus/screen/SampleMap.dart';
import 'package:mybus/utils/Appbar.dart';
import 'package:mybus/utils/Drawer.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ApplicationState(),
      builder: (context, child) {
        return Consumer<ApplicationState>(builder: ((context, value, child) {
          return MaterialApp(
            initialRoute: value.fireauth.currentUser != null ? "/home" : "/",
            theme: ThemeData(textTheme: GoogleFonts.poppinsTextTheme()),
            debugShowCheckedModeBanner: false,
            routes: {
              '/': (context) {
                return IntroPage();
              },
              '/home': (context) {
                return HomePage();
              },
              '/buses': ((context) {
                return MyBuses();
              }),
              '/sign-in': (context) {
                return SignInScreen(
                  providers: [EmailAuthProvider()],
                  actions: [
                    AuthStateChangeAction(
                      (context, state) {
                        Navigator.pushReplacementNamed(context, '/home');
                      },
                    )
                  ],
                );
              },
              "/samplemap": (context) => SampleApp()
            },
          );
        }));
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(context),
      appBar: MyAppBar(),
      body: Container(
        child: MyPostitionStrem(),
      ),
    );
  }
}

class MyPostitionStrem extends StatefulWidget {
  const MyPostitionStrem({super.key});

  @override
  State<MyPostitionStrem> createState() => _MyPostitionStremState();
}

class _MyPostitionStremState extends State<MyPostitionStrem> {
  // StreamSubscription<Position> positionStream = Geolocator
  late Position? p = null;
  final Stream<Position> posStream = Geolocator.getPositionStream();
  final LocationSettings lc =
      LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 100);

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    LocationPermission permission = await Geolocator.requestPermission();
    Geolocator.getPositionStream(
            locationSettings: LocationSettings(
                accuracy: LocationAccuracy.high, distanceFilter: 100))
        .listen((Position? position) {
      setState(() {
        p = position;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          StreamBuilder<Position>(
            stream: posStream,
            builder: ((context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              if (snapshot.connectionState == ConnectionState.active) {
                return Column(
                  children: [
                    Text(
                      'Your Location is',
                      style:
                          TextStyle(fontSize: 20, color: Colors.grey.shade600),
                    ),
                    Container(
                        child: Text(
                            'Lat: ${snapshot.data?.latitude.toString()}, Long: ${snapshot.data?.longitude.toString()}')),
                  ],
                );
              }
              return Text('Found Nothing');
            }),
          )
        ],
      ),
    );
  }
}
