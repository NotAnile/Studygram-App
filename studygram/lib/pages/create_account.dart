import 'package:flutter/material.dart';
import 'package:studygram/components/textbutton.dart';
import 'package:studygram/models/authentication.dart';
import '../components/textfield.dart';
import 'package:provider/provider.dart';
import 'package:studygram/models/create_account_model.dart';
import 'package:studygram/components/appbar.dart';
import 'package:studygram/models/url.dart';

class CreateAccountPage extends StatelessWidget {
  const CreateAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController usernameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController passwordController2 = TextEditingController();
    return Scaffold(
      appBar: getMyAppBar(context, const Text("Create account")),
      body: Consumer<Authentication>(
        builder: (context, auth, child) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Create account",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MyTextField(
                    labelText: "Username",
                    controller: usernameController,
                    obscureText: false,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MyTextField(
                    labelText: "Password",
                    controller: passwordController,
                    obscureText: true,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MyTextField(
                    labelText: "Confirm password",
                    controller: passwordController2,
                    obscureText: true,
                  ),
                ),
                CreateButton(
                  passwordController: passwordController,
                  passwordController2: passwordController2,
                  usernameController: usernameController,
                  auth: auth,
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

// Creating a stateful class for button since we need to update UI depending on user input
class CreateButton extends StatefulWidget {
  final TextEditingController passwordController;
  final TextEditingController passwordController2;
  final TextEditingController usernameController;
  final Authentication auth;
  const CreateButton(
      {super.key,
      required this.passwordController,
      required this.passwordController2,
      required this.auth,
      required this.usernameController});

  @override
  State<CreateButton> createState() => _CreateButtonState();
}

class _CreateButtonState extends State<CreateButton> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CreateAccountModel>(
      builder: (context, model, child) {
        return Column(
          children: [
            (model.status == Status.error)
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(model.errorMessage),
                  )
                : const Text(""),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MyTextButton(
                buttonText: "Create",
                textColor: Colors.white,
                backgroundColor: const Color.fromARGB(255, 159, 122, 165),
                rectangleShape: true,
                onPressed: () async {
                  // Handling error of empty fields
                  if (widget.usernameController.text == "") {
                    setState(() {
                      model.setErrorMessage("Missing username");
                    });
                  } else if (widget.passwordController.text == "" ||
                      widget.passwordController2.text == "") {
                    // Handle UI when one of the password fields are empty
                    setState(() {
                      model.setErrorMessage("Missing password");
                    });
                  } else {
                    // Making a call to the server to log in by sending up the username and password
                    // Also handles errors when password fields don't match
                    if (widget.passwordController.text ==
                        widget.passwordController2.text) {
                      final status = await model.createAccount(
                          widget.usernameController.text,
                          widget.passwordController.text,
                          context);

                      // Showing snackbar to notify the user that the account has successfully been created
                      if (status == Status.success) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text(
                                "Account successfully created! You are now logged in.")));
                      }
                    } else {
                      // Handle UI when the passwords aren't matching
                      setState(() {
                        model.setErrorMessage("Passwords aren't matching");
                      });
                    }
                  }
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
