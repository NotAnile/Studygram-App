import 'package:flutter/material.dart';
import 'package:studygram/components/textbutton.dart';
import 'package:studygram/data.dart';
import 'package:studygram/models/authentication.dart';
import 'package:studygram/models/user.dart';
import '../components/textfield.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

//**The page for viewing a single post, including its comments*/
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController usernameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    return Consumer<Authentication>(builder: (context, auth, child) {
      // Checks if the user is already logged in or not
      if (auth.isLoggedIn) {
        return Center(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 200, bottom: 30),
                child: Text("Login",
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
                child: MyTextButton(
                  buttonText: "Log in",
                  textColor: Colors.white,
                  backgroundColor: const Color.fromARGB(255, 159, 122, 165),
                  rectangleShape: true,
                  onPressed: () {
                    // Making a call to the server to log in by sending up the username and password
                    Data.login(usernameController.text, passwordController.text,
                        context);
                  },
                ),
              ),
            ],
          ),
        );
      } else {
        String username =
            Provider.of<UserModel>(context, listen: false).username;
        return Center(
          child: Column(
            children: [
              Padding(
                  padding: const EdgeInsets.only(top: 250, bottom: 50),
                  child: Text("Welcome back $username",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 25))),
              Padding(
                padding: const EdgeInsets.all(20),
                child: MyTextButton(
                    buttonText: "Go to home page",
                    textColor: Colors.white,
                    backgroundColor: const Color.fromARGB(255, 159, 122, 165),
                    rectangleShape: true,
                    onPressed: () {
                      context.go('/');
                    }),
              )
            ],
          ),
        );
      }
    });
  }
}
