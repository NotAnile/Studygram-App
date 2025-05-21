import 'package:flutter/material.dart';
import 'package:studygram/components/appbar.dart';
import 'package:provider/provider.dart';
import 'package:studygram/models/session_view_model.dart';
import 'package:studygram/components/session_card.dart';
import 'package:studygram/components/loading_indicator.dart';
import '../structure.dart';
import 'package:studygram/models/authentication.dart';
import 'package:studygram/models/settings_model.dart';

class StudyHistoryPage extends StatelessWidget {
  const StudyHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
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
  }
}

///Listview to display all the sessions in a column
class SessionView extends StatelessWidget {
  const SessionView({super.key});

  @override
  Widget build(BuildContext context) {
    Map textSize = {Size.small: 14.0, Size.medium: 16.0, Size.large: 18.0};
    return Consumer<SessionViewModel>(builder: (context, model, child) {
      // Getting the access token
      String token =
          Provider.of<Authentication>(context, listen: false).accessToken;
      // Getting the textsize
      Settings settings = Provider.of<Settings>(context, listen: false);
      // Getting all the sessions
      Future<dynamic> request = model.getSessions(token);
      return FutureBuilder(
        future: request,
        builder: (context, snapshot) {
          // Checking for errors
          if (snapshot.hasError) {
            String errorMessage = model.errorMessage;
            return Center(
                child: Text(
                    errorMessage.isEmpty
                        ? "An error has occurred. Could not get sessions."
                        : errorMessage,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: textSize[settings.size])));
          }
          // Everything went well
          if (snapshot.connectionState == ConnectionState.done) {
            final sessions = snapshot.data!;
            if (sessions.isEmpty) {
              return Expanded(
                  child: Text(
                "No sessions yet",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: textSize[settings.size]),
              ));
            }
            return Expanded(
              child: ListView.builder(
                itemCount: sessions.length,
                itemBuilder: (context, index) {
                  // Getting the right session with the index and returns a SessionCard with the body and username
                  Session session = sessions[index] as Session;
                  return SessionCard(session: session);
                },
              ),
            );
          } else {
            return const LoadingIndicator();
          }
        },
      );
    });
  }
}
