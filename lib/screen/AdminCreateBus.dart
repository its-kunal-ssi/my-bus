import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mybus/utils/Appbar.dart';

class AdminCreateBus extends StatefulWidget {
  const AdminCreateBus({super.key});

  @override
  State<AdminCreateBus> createState() => _AdminCreateBusState();
}

class _AdminCreateBusState extends State<AdminCreateBus> {
  final TextPoppinStyle =
      GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.normal);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: SingleChildScrollView(
            child: Column( //Bus Details Form
              children: [
                // Heading
                Text('Create Bus',
                    style: GoogleFonts.poppins(
                        fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 20,
                ),
                // Divider
                Divider(thickness: 2),
                TextField(
                  decoration: InputDecoration(
                    label: Text(
                      'Bus Name',
                      style: TextPoppinStyle,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  decoration: InputDecoration(
                    label: Text(
                      'Bus Number',
                      style: TextPoppinStyle,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  decoration: InputDecoration(
                    label: Text(
                      'Bus Driver Name',
                      style: TextPoppinStyle,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  decoration: InputDecoration(
                    label: Text(
                      'Bus Model Name',
                      style: TextPoppinStyle,
                    ),
                  ),
                ),
                SizedBox(height: 30,),
                // Okay Button
                ElevatedButton(
                  onPressed: (){
                    // Link to Next Page
          
                  }, child: Text('Confirm'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
