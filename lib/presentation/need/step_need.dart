import 'package:evolum_package/main.dart';
import 'package:flutter/material.dart';

class StepNeed extends StatelessWidget {
  const StepNeed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.3;

    return Scaffold(
      backgroundColor: kevoBlack,
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            Container(
              height: height,
              color: Colors.yellow,
            ),
            Container(
              height: height,
              color: Colors.yellow,
            ),
          ],
        ),
      ),
    );
  }
}
