import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:mybus/utils/Appbar.dart';
import 'package:mybus/utils/utils.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Text('Authenticate', style: googlePoppinsHead),
            Center(
                child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(label: Text('Enter Mail Id')),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    decoration:
                        InputDecoration(label: Text('Enter Your Password')),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Confirm Your Password'),
                              content: SingleChildScrollView(
                                  child: TextField(
                                decoration: InputDecoration(
                                    label: Text('Confirm Password')),
                              )),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Okay'))
                              ],
                            );
                          },
                        );
                      },
                      child: Text('Okay'))
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}
