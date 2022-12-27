import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mybus/main.dart';
import 'package:provider/provider.dart';

import '../providers/ApplicationState.dart';

AppBar MyAppBar() {
  return AppBar(
      title: Text(
        'My Bus',
        style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold),
      ),
      actions: [
        Consumer<ApplicationState>(
          builder: (context, value, child) {
            return (value.isLoading
                ? CircularProgressIndicator(
                    color: Colors.white,
                  )
                : value.loggedIn
                    ? TextButton(
                        child: Text('Sign Out',
                            style: TextStyle(color: Colors.white)),
                        onPressed: () {
                          FirebaseAuth.instance.signOut();
                          Provider.of<ApplicationState>(context).SignOutUser();
                        },
                      )
                    : TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/sign-in');
                        },
                        child: Text(
                          'Sign In',
                          style: TextStyle(color: Colors.white),
                        ),
                      ));
          },
        )
      ]);
}
