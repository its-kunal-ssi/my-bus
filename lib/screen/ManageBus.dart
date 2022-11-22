import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ManageBus extends StatefulWidget {
  const ManageBus({super.key});

  @override
  State<ManageBus> createState() => _ManageBusState();
}

class _ManageBusState extends State<ManageBus> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Manage Buses'),
    );
  }
}
