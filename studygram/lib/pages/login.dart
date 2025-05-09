import 'package:flutter/material.dart';
import 'package:studygram/components/textbutton.dart';
import 'package:studygram/models/authentication.dart';
import '../components/textfield.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

//**The page for loggin in*/
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController usernameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    return Scaffold(
        body: Consumer<Authentication>(builder: (context, auth, child) {
      // Checks if the user is already logged in or not
      if (!auth.isLoggedIn) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
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
                    Provider.of<Authentication>(context, listen: false).login(
                        usernameController.text,
                        passwordController.text,
                        context);
                  },
                ),
              ),
              GestureDetector(
                onTap: () {
                  context.push('/create/account');
                },
                child: const Text(
                  "No account? Sign up!",
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              )
            ],
          ),
        );
      } else {
        return Center(
          child: Column(
            children: [
              const Padding(
                  padding: EdgeInsets.only(top: 250, bottom: 50),
                  child: Text("Welcome back",
                      style: TextStyle(
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
                  },
                ),
              )
            ],
          ),
        );
      }
    }));
  }
}
