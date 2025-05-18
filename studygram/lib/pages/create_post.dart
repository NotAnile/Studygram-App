import 'package:flutter/material.dart';
import 'package:studygram/components/appbar.dart';
import 'package:studygram/components/textarea.dart';
import 'package:studygram/components/textbutton.dart';
import 'package:provider/provider.dart';
import 'package:studygram/models/authentication.dart';
import 'package:studygram/models/create_post_model.dart';
import 'package:studygram/models/url.dart';
import '../models/settings_model.dart';
import 'package:go_router/go_router.dart';

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
    return Consumer<CreatePostModel>(builder: (context, model, state) {
      return Consumer<Settings>(
        builder: (context, settings, state) {
          return Scaffold(
            appBar: getMyAppBar(
                context,
                Text("Create post",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inverseSurface,
                    ))),
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
                          // Textarea
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
                              // Button for creating post
                              MyTextButton(
                                buttonText: "Create",
                                backgroundColor: Theme.of(context).primaryColor,
                                rectangleShape: false,
                                onPressed: () async {
                                  CreatePostModel createPostModel =
                                      Provider.of<CreatePostModel>(context,
                                          listen: false);
                                  // Getting token
                                  String token = Provider.of<Authentication>(
                                          context,
                                          listen: false)
                                      .accessToken;

                                  Status status = await createPostModel
                                      .createPost(token, bodyController.text);
                                  if (context.mounted) {
                                    if (status == Status.success) {
                                      // Shows a snackbar that the post was successfully created
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content:
                                              Text("Post succesfully created"),
                                        ),
                                      );
                                      context.pop();
                                    } else {
                                      // Shows a snackbar if something went wrong
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              createPostModel.errorMessage),
                                        ),
                                      );
                                    }
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
