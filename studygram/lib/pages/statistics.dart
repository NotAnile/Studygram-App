import 'package:flutter/material.dart';
import 'package:studygram/components/appbar.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getMyAppBar(
          context,
          const Text(
            "Statistics",
            style: TextStyle(color: Colors.white),
          )),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(""),
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
