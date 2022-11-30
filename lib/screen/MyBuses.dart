import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/ui/utils/stream_subscriber_mixin.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:mybus/providers/ApplicationState.dart';
import 'package:mybus/screen/AdminCreateBus.dart';
import 'package:mybus/utils/Appbar.dart';
import 'package:mybus/utils/Drawer.dart';
import 'package:provider/provider.dart';

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
          value.getData();
          if (value.loggedIn) {
            return StreamBuilder(
                stream: value.busesData,
                builder: ((context, snapshot) {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      if (ConnectionState.waiting == snapshot.connectionState) {
                        return SizedBox(
                            height: 50, child: CircularProgressIndicator());
                      }
                      var d = snapshot.data?.docs[index].data();
                      Map<String, dynamic> adb = d as Map<String, dynamic>;
                      adb['busno'] = snapshot.data?.docs[index].id as String;
                      return ListTile(
                        onTap: () {
                          //
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return BusDetailPage(
                                busno: adb['busno'],
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
                                      adb['driverId']) {
                                    return IconButton(
                                        onPressed: () {
                                          value.removeBus(adb['busno']);
                                        },
                                        icon: Icon(Icons.delete));
                                  }
                                  return Container();
                                },
                              )
                            ],
                          ),
                        ),
                        subtitle: Text('Bus Number : ${adb['busno']}'),
                        title: Text(
                          "Driver Name : ${adb['driver']}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      );
                    },
                  );
                }));
          }
          return Center(
            child: Text(
              'Please Log In',
              style: TextStyle(
                  fontSize: 25,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.bold),
            ),
          );
        }),
      ),
    );
  }
}

class BusDetailPage extends StatelessWidget {
  final String busno;
  const BusDetailPage({super.key, required this.busno});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      drawer: MyDrawer(context),
      body: Padding(
        padding: EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Bus Number : $busno',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(
              height: 20,
            ),
            Consumer<ApplicationState>(
              builder: (context, value, child) {
                return StreamBuilder(
                  stream:
                      value.firedb.collection('buses').doc(busno).snapshots(),
                  builder: (context, snapshot) {
                    var st = snapshot.data!.data() as Map<String, dynamic>;
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
                        StreamBuilder(
                          stream: value.db.ref('buses/${st['busno']}').onValue,
                          builder: (context, snapshot) {
                            var ad = snapshot.data!.snapshot.value as Map;
                            print(ad['lat']);
                            print(ad['long']);
                            var dd = DateTime.fromMillisecondsSinceEpoch(
                                ad['timestamp'] as int);
                            print(dd);
                            var adu =
                                dd.difference(DateTime.now()).abs().inMinutes;
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
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: SizedBox(
                            height: 150,
                            child: Image.asset('lib/assets/bus2.png'),
                          ),
                        )
                      ],
                    );
                  },
                );
              },
            )
          ],
        ),
      ),
    );
  }
}



