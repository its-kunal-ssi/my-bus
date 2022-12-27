import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/ui/utils/stream_subscriber_mixin.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mybus/providers/ApplicationState.dart';
import 'package:mybus/screen/AdminCreateBus.dart';
import 'package:mybus/utils/Appbar.dart';
import 'package:mybus/utils/Drawer.dart';
import 'package:provider/provider.dart';
import 'package:webviewx/webviewx.dart';

class MyBuses extends StatelessWidget {
  const MyBuses({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: ((context) {
            return AdminCreateBus();
          })));
        },
        child: Icon(Icons.add),
      ),
      drawer: MyDrawer(context),
      appBar: MyAppBar(),
      body: Column(
        children: [MyBusesList()],
      ),
    );
  }
}

class MyBusesList extends StatefulWidget {
  const MyBusesList({super.key});

  @override
  State<MyBusesList> createState() => MyBusesListState();
}

class MyBusesListState extends State<MyBusesList> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Provider.of<ApplicationState>(context).getData();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Consumer<ApplicationState>(
        builder: ((context, value, child) {
          // value.getData();
          return ListView.builder(
              itemCount: value.lisBuses.length,
              itemBuilder: ((context, index) {
                return ListTile(
                  leading: SizedBox(
                    height: 40,
                    child: Image.asset('lib/assets/bus2.png'),
                  ),
                  onTap: () {
                    //
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return BusDetailPage(
                          busno: value.lisBuses[index]['busno'],
                        );
                      },
                    ));
                  },
                  trailing: SizedBox(
                    width: 50,
                    child: Row(
                      children: [
                        Builder(
                          builder: (context) {
                            if (value.fireauth.currentUser!.uid ==
                                value.lisBuses[index]['driverId']) {
                              return IconButton(
                                  onPressed: () {
                                    value.removeBus(
                                        value.lisBuses[index]['busno']);
                                  },
                                  icon: Icon(Icons.delete));
                            }
                            return Container();
                          },
                        )
                      ],
                    ),
                  ),
                  subtitle:
                      Text('Bus Number : ${value.lisBuses[index]['busno']}'),
                  title: Text(
                    "Driver Name : ${value.lisBuses[index]['driver']}",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                );
              }));
          // return Center(
          //   child: Text(
          //     'Please Log In',
          //     style: TextStyle(
          //         fontSize: 25,
          //         color: Colors.grey.shade700,
          //         fontWeight: FontWeight.bold),
          //   ),
          // );
        }),
      ),
    );
  }
}

class BusDetailPage extends StatefulWidget {
  final String busno;
  const BusDetailPage({super.key, required this.busno});

  @override
  State<BusDetailPage> createState() => _BusDetailPageState();
}

class _BusDetailPageState extends State<BusDetailPage> {
  late WebViewXController webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      drawer: MyDrawer(context),
      body: Padding(
        padding: EdgeInsets.all(30),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Bus Number : ${widget.busno}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(
                height: 20,
              ),
              Consumer<ApplicationState>(
                builder: (context, value, child) {
                  return StreamBuilder(
                    stream: value.firedb
                        .collection('buses')
                        .doc(widget.busno)
                        .snapshots(),
                    builder: (context, snapshot) {
                      var st = snapshot.data?.data() as Map<String, dynamic>;
                      st['busno'] = snapshot.data!.id;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bus Name : ${st['name']}',
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Bus Driver : ${st['driver']}',
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Bus Model : ${st['busModel']}',
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Divider(
                            thickness: 2,
                            height: 4,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          SingleChildScrollView(
                            child: StreamBuilder(
                              stream:
                                  value.db.ref('buses/${st['busno']}').onValue,
                              builder: (context, snapshot) {
                                var ad = snapshot.data!.snapshot.value as Map;
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
        const marker1 = new mapboxgl.Marker({
            color: "#dc2626"
        })
            .setLngLat([${ad['long']}, ${ad['lat']}])
            .addTo(map);
        '''
                                ];

                                print(ad['lat']);
                                print(ad['long']);
                                var dd = DateTime.fromMillisecondsSinceEpoch(
                                    ad['timestamp'] as int);
                                print(dd);
                                var adu = dd
                                    .difference(DateTime.now())
                                    .abs()
                                    .inMinutes;

                                return Container(
                                  child: Column(
                                    children: [
                                      Text(
                                        'Location of Bus',
                                        style: TextStyle(fontSize: 21),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                          "Latitude: ${ad['lat']}, Longitude: ${ad['long']}"),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        '${adu} min ago',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            color: Colors.grey.shade600),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Stack(
                                        children: [
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
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
