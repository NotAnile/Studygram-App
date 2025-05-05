import 'package:flutter/material.dart';
import 'package:studygram/components/textbutton.dart';
import 'package:studygram/models/authentication.dart';
import '../components/textfield.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../models/login.dart';

class CreateAccountPage extends StatelessWidget {
  const CreateAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController usernameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController passwordController2 = TextEditingController();
    return Consumer<Authentication>(
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
    );
  }
}

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
    return Consumer<LoginModel>(
      builder: (context, model, child) {
        return Column(
          children: [
            model.showErrorMessage
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
                  // Making a call to the server to log in by sending up the username and password
                  if (widget.passwordController.text ==
                      widget.passwordController2.text) {
                    model.setShowErrorMessage(false);
                    widget.auth.createAccount(widget.usernameController.text,
                        widget.passwordController.text, context);
                  } else {
                    // Handle UI when the passwords aren't matching
                    setState(() {
                      model.setErrorMessage("Passwords aren't matching");
                      model.setShowErrorMessage(true);
                    });
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
