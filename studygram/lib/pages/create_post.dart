import 'package:flutter/material.dart';
import 'package:studygram/components/appbar.dart';
import 'package:studygram/components/textarea.dart';
import 'package:studygram/components/textbutton.dart';
import 'package:provider/provider.dart';
import 'package:studygram/models/create_post_model.dart';
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
                const Text("Create post",
                    style: TextStyle(color: Colors.white))),
            body: Center(
              child: Column(
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
                                  onPressed: () {
                                    Provider.of<CreatePostModel>(context,
                                            listen: false)
                                        .createPost(
                                            context, bodyController.text);
                                  },
                                  width: sizes[settings.size]['textbutton'],
                                ),
                              ],
                            ),
                          )
                        ],
                      )),
                  model.showErrorMessage
                      ? Text(model.errorMessage)
                      : const Text("")
                ],
              ),
            ),
          );
        },
      );
    });
  }
}
