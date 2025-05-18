import 'package:flutter/material.dart';
import 'package:studygram/components/appbar.dart';
import 'package:provider/provider.dart';
import 'package:studygram/models/session_view_model.dart';
import 'package:studygram/components/session_view.dart';

class StudyHistoryPage extends StatelessWidget {
  const StudyHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SessionViewModel>(
      builder: (context, studyHistoryModel, child) {
        return Scaffold(
          appBar: getMyAppBar(
            context,
            const Text(
              "Study History",
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: const Center(
            child: Column(
              children: [
                SessionView(),
              ],
            ),
          ),
        );
      },
    );
  }
}
