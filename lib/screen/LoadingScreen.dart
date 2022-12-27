import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:mybus/providers/ApplicationState.dart';
import 'package:provider/provider.dart';

class MyLoader extends StatefulWidget {
  const MyLoader({super.key});

  @override
  State<MyLoader> createState() => _MyLoaderState();
}

class _MyLoaderState extends State<MyLoader> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Consumer<ApplicationState>(
      builder: (context, value, child) {
        if (value.isLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          if (value.fireauth.currentUser != null) {
            Future.delayed(Duration(milliseconds: 100), () {
              Navigator.pushReplacementNamed(context, '/home');
            });
          } else {
            Navigator.pushReplacementNamed(context, '/');
          }
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    ));
  }
}
