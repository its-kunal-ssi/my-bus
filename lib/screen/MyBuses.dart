import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/ui/utils/stream_subscriber_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:mybus/utils/Appbar.dart';
import 'package:mybus/utils/Drawer.dart';

class MyBuses extends StatelessWidget {
  const MyBuses({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(context),
      appBar: MyAppBar(),
      body: Column(
        children: [
          Container(
            child: Text('Hello from My Buses'),
          ),
          myBusesList()
        ],
      ),
    );
  }
}

class myBusesList extends StatefulWidget {
  const myBusesList({super.key});

  @override
  State<myBusesList> createState() => _myBusesListState();
}

class _myBusesListState extends State<myBusesList> {
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('buses').snapshots();
  late List<Map<String, dynamic>> lis = [];

  Future<void> init() async {
    StreamSubscription _userSubs =
        FirebaseFirestore.instance.collection('buses').snapshots().listen((v) {
      setState(() {
        lis.clear();
      });
      v.docs.forEach((element) {
        setState(() {
          lis.add(element.data());
        });
      });
      print(lis);
    });
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StreamBuilder<QuerySnapshot>(
          stream: _usersStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.data!.docs.isNotEmpty) {
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var bus =
                        snapshot.data!.docs[index] as Map<String, dynamic>;
                    print("Hello");
                    return Container(
                      child:
                          Text(snapshot.data!.docs[index].data()!.toString()),
                    );
                  },
                );
              } else {
                return CircularProgressIndicator();
              }
            }
            if (ConnectionState.waiting == snapshot.connectionState) {
              return CircularProgressIndicator();
            }
            return CircularProgressIndicator();
          },
        ),
        Text(lis![0]!['driver'])
      ],
    );
  }
}
