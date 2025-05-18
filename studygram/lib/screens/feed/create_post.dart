import 'package:flutter/material.dart';
import 'package:studygram/components/appbar.dart';
import 'package:studygram/components/textarea.dart';
import 'package:studygram/components/textbutton.dart';
import 'package:provider/provider.dart';
import 'package:studygram/providers/create_post_provider.dart';
import '../../services/settings_model.dart';
import 'package:go_router/go_router.dart';
import 'package:studygram/services/url.dart';
import 'package:studygram/services/authentication.dart';

class CreatePostPage extends StatelessWidget {
  const CreatePostPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController bodyController = TextEditingController();
    Map sizes = {
      Size.small: {'textarea': 500.0, 'textbutton': 70.0},
      Size.medium: {'textarea': 600.0, 'textbutton': 120.0},
      Size.large: {'textarea': 700.0, 'textbutton': 170.0},
    };
    return Consumer<CreatePostProvider>(builder: (context, model, state) {
      return Consumer<Settings>(
        builder: (context, settings, state) {
          return Scaffold(
            appBar: getMyAppBar(
                context,
                const Text("Create post",
                    style: TextStyle(color: Colors.white))),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: sizes[settings.size]['textarea'],
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: TextArea(
                            labelText: "What would you like to say?",
                            controller: bodyController,
                            obscureText: false,
                            width: sizes[settings.size]['textarea'],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 30.0),
                          child: Row(
                            children: [
                              MyTextButton(
                                buttonText: "Create",
                                textColor: Colors.white,
                                backgroundColor:
                                    const Color.fromARGB(255, 191, 152, 197),
                                rectangleShape: false,
                                onPressed: () async {
                                  // Getting token
                                  String token = Provider.of<Authentication>(
                                          context,
                                          listen: false)
                                      .accessToken;
                                  await model.createPost(
                                      token, bodyController.text);
                                  Status status = model.status;
                                  if (status == Status.success) {
                                    // Shows a snackbar that the post was successfully created
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text("Post succesfully created"),
                                      ),
                                    );
                                    model.status = Status.idle;
                                    context.pop();
                                  } else if (status == Status.error) {
                                    // Shows a snackbar if something went wrong
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(model.errorMessage),
                                      ),
                                    );
                                  }
                                },
                                width: sizes[settings.size]['textbutton'],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }
}
