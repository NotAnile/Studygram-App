import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studygram/models/settings_model.dart';
import 'package:studygram/models/authentication.dart';
import 'package:studygram/models/session_view_model.dart';
import 'package:studygram/structure.dart';
import 'package:studygram/components/delete_button.dart';

/// A card that consists of the date that a session was started,
/// start and end time, subject, description and duration.
class SessionCard extends StatelessWidget {
  final Session session;
  const SessionCard({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    final String subject = session.subject;
    final String description = session.description;

    // Transforming the date, start and end times into the correct format that we want to display it in
    final String formattedDate = session.getFormattedDate(session.starttime);
    final String formattedStartTime =
        session.getFormattedTime(session.starttime);
    final String formattedEndTime = session.getFormattedTime(session.endtime);
    final String duration =
        session.getFormattedDuration(session.durationAsMinutes);

    String token =
        Provider.of<Authentication>(context, listen: false).accessToken;
    SessionViewModel sessionViewModel =
        Provider.of<SessionViewModel>(context, listen: false);

    return Consumer<Settings>(
      builder: (context, settings, state) {
        Map sizes = {Size.small: 12.0, Size.medium: 14.0, Size.large: 16.0};
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: Card(
            color: Theme.of(context).cardColor,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Displaying the date
                      Text(
                        formattedDate,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                          fontSize: sizes[settings.size],
                        ),
                      ),
                      DeleteButton(onPressed: () async {
                        Status status = await sessionViewModel.deleteSession(
                            token, session.id);
                        // Showing a snackbar to notify the user about how the login went
                        if (context.mounted) {
                          if (status == Status.success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Succesfully deleted post")));
                          } else if (status == Status.error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  (sessionViewModel.errorMessage.isEmpty
                                      ? "Unknown error"
                                      : sessionViewModel.errorMessage),
                                ),
                              ),
                            );
                          }
                        }
                      })
                    ],
                  ),
                  Row(
                    children: [
                      // Displaying the start and end time
                      Text(
                        '$formattedStartTime-$formattedEndTime',
                        style: TextStyle(
                          fontSize: sizes[settings.size],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      // Displaying the subject
                      Text(
                        "Subject: $subject",
                        style: TextStyle(
                          fontSize: sizes[settings.size],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      // Displaying the description
                      Text(
                        "Description: $description",
                        style: TextStyle(
                          fontSize: sizes[settings.size],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      // Displaying the duration of the session
                      Text(
                        "Duration: $duration",
                        style: TextStyle(
                          fontSize: sizes[settings.size],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
