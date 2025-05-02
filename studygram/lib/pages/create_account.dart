import 'package:flutter/material.dart';
import 'package:studygram/components/textbutton.dart';
import 'package:studygram/models/authentication.dart';
import '../components/textfield.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

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
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 200, bottom: 30),
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MyTextButton(
                  buttonText: "Create",
                  textColor: Colors.white,
                  backgroundColor: const Color.fromARGB(255, 159, 122, 165),
                  rectangleShape: true,
                  onPressed: () async {
                    // Making a call to the server to log in by sending up the username and password
                    if (passwordController.text == passwordController2.text) {
                      auth.createAccount(usernameController.text,
                          passwordController.text, context);
                    } else {
                      // Handle UI when the passwords aren't matching
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
