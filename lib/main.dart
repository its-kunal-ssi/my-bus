import 'dart:async';

import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mybus/providers/ApplicationState.dart';
import 'package:mybus/screen/IntroPage.dart';
import 'package:mybus/screen/LoadingScreen.dart';
import 'package:mybus/screen/MyBus.dart';
import 'package:mybus/utils/Appbar.dart';
import 'package:mybus/utils/Drawer.dart';
import 'package:provider/provider.dart';
import 'package:webviewx/webviewx.dart';

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
            initialRoute: value.isLoading
                ? "/loading"
                : value.fireauth.currentUser != null
                    ? "/home"
                    : "/",
            theme: ThemeData(textTheme: GoogleFonts.poppinsTextTheme()),
            debugShowCheckedModeBanner: false,
            routes: {
              '/loading':(context) {
                return MyLoader();
              },
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
            },
          );
        }));
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
  var webViewController;
  final Stream<Position> posStream = Geolocator.getPositionStream();
  final LocationSettings lc =
      LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 100);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Consumer<ApplicationState>(
            builder: (context, value, child) {
              List<String> htl = [
                '''<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <script src='https://api.mapbox.com/mapbox-gl-js/v2.9.1/mapbox-gl.js'></script>
    <link href='https://api.mapbox.com/mapbox-gl-js/v2.9.1/mapbox-gl.css' rel='stylesheet' />
    <style>
    </style>
</head>

<body>
    <div style="height: 370px; width: 300px; ">
        <div id="map" style="min-height: 100%; min-width: 100%; margin: 0px auto; padding: 0px auto;"></div>
    </div>

</body>
<script src="./app.js" defer></script>

</html>'''
              ];
              List<String> jss = [
                '''console.log("Hello")
mapboxgl.accessToken = 'pk.eyJ1Ijoia3VuYWxweTMiLCJhIjoiY2xjMjYwNHVrMGU5MzN2cWZzaGJldndqMSJ9.r7tWzKnyhCkQKbPbfN2hjg';
var map = new mapboxgl.Map({
    container: 'map',
    style: 'mapbox://styles/mapbox/streets-v11',
    center: [${value.currLoc.longitude}, ${value.currLoc.latitude}],
    zoom: 14,

});
map.addControl(new mapboxgl.NavigationControl());
const marker = new mapboxgl.Marker({
    color: "#0ea5e9"
})
    .setLngLat([${value.currLoc.longitude}, ${value.currLoc.latitude}])
    .addTo(map);
'''
              ];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                      "Your Current Location is: \nLatitude: ${value.currLoc.latitude} Longitude: ${value.currLoc.longitude}"),
                  SizedBox(
                    height: 30,
                  ),
                  ListTile(
                    title: Text("Sync Locations"),
                    trailing: Switch(
                      value: value.isSyncLocations,
                      onChanged: ((va) {
                        value.setIsSyncLoc(va);
                      }),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Stack(children: [
                    WebViewX(
                      onWebViewCreated: (controller) =>
                          webViewController = controller,
                      width: 400,
                      height: 400,
                      initialSourceType: SourceType.html,
                      initialContent: htl.join(),
                      jsContent: {
                        EmbeddedJsContent(
                          js: jss.join(),
                        )
                      },
                    ),
                    ElevatedButton(
                        onPressed: () {
                          webViewController.reload();
                        },
                        child: Icon(Icons.refresh))
                  ])
                ],
              );
            },
          )
        ],
      ),
    );
  }
}
