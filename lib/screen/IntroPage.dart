import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mybus/main.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Text
            Text("Track your Journey With Us.",
                style: GoogleFonts.poppins(
                    fontSize: 30, fontWeight: FontWeight.bold)),
            SizedBox(
              height: 40,
            ),
            // Image Asset
            SizedBox(height: 200, child: Image.asset('lib/assets/bus.png')),
            // Button,
            SizedBox(
              height: 50,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return HomePage();
                      },
                    ),
                  );
                },
                child: Text('Get Started'))
          ],
        ),
      ),
    ));
  }
}
