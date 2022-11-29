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
        children: [
          Container(
            child: Text('Hello from My Buses'),
          ),
          MyBusesList()
        ],
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
      child: Consumer<ApplicationState>(builder: ((context, value, child) {
        value.getData();

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
                    },
                    trailing: SizedBox(
                      width: 50,
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                value.removeBus(adb['busno']);
                              },
                              icon: Icon(Icons.delete))
                        ],
                      ),
                    ),
                    subtitle: Text('Bus Number : ${adb['busno']}'),
                    title: Text(
                      "Driver Name : ${adb['driver']}",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  );
                },
              );
            }));
      })),
    );
  }
}
