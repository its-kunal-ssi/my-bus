import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

Drawer MyDrawer(context) {
  return Drawer(
    child: ListView(
      children: [
        ListTile(
          onTap: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
          title: Text('Home'),
        ),
        ListTile(
          onTap: () {
            Navigator.pushNamed(context, '/buses');
          },
          title: Text('Buses'),
        )
      ],
    ),
  );
}
