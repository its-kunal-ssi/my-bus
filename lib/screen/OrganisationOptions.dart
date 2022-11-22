import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class OrgOptionsPage extends StatefulWidget {
  const OrgOptionsPage({super.key});

  @override
  State<OrgOptionsPage> createState() => _OrgOptionsPageState();
}

class _OrgOptionsPageState extends State<OrgOptionsPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Organisation Options'),
    );
  }
}

// Join Organisation Modal
