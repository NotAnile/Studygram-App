import 'package:flutter/material.dart';
import 'package:studygram/components/sessioncard.dart';
import 'package:studygram/components/loading_indicator.dart';
import 'package:studygram/models/session.dart';
import 'package:provider/provider.dart';
import 'package:studygram/services/session_view_model.dart';
import 'package:studygram/services/authentication.dart';
import 'package:studygram/services/settings_model.dart';

//**Listview to display all the sessions in a column*/
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
          if (snapshot.hasError) {
            String errorMessage = model.errorMessage;
            return Center(
                child: Text(
                    errorMessage.isEmpty
                        ? "An error has occurred. Could not get sessions."
                        : errorMessage,
                    style: TextStyle(fontSize: textSize[settings.size])));
          }
          if (snapshot.connectionState == ConnectionState.done) {
            final sessions = snapshot.data!;
            if (sessions.isEmpty) {
              return Expanded(
                  child: Text(
                "No sessions yet",
                style: TextStyle(fontSize: textSize[settings.size]),
              ));
            }
            return Expanded(
              child: ListView.builder(
                itemCount: sessions.length,
                itemBuilder: (context, index) {
                  Session session = sessions[index] as Session;
                  // Getting the right post with the index and returns a PostCard with the body and username
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
