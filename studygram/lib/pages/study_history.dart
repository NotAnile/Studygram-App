import 'package:flutter/material.dart';
import 'package:studygram/components/appbar.dart';
import 'package:provider/provider.dart';
import 'package:studygram/models/study_history_model.dart';

class StudyHistoryPage extends StatelessWidget {
  const StudyHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<StudyHistoryModel>(
      builder: (context, studyHistoryModel, child) {
        return Scaffold(
          appBar: getMyAppBar(
              context,
              const Text(
                "Study History",
                style: TextStyle(color: Colors.white),
              )),
          body: const Center(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(""),
                ),
                Divider(),
              ],
            ),
          ),
        );
      },
    );
  }
}
