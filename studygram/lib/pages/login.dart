import 'package:flutter/material.dart';
import 'package:studygram/components/textbutton.dart';
import 'package:studygram/models/authentication.dart';
import '../components/textfield.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:studygram/structure.dart';

/// The page for logging in
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController usernameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Consumer<Authentication>(builder: (context, auth, child) {
          // Checks if the user is already logged in or not
          if (!auth.isLoggedIn) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Login",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Theme.of(context).colorScheme.onSurface,
                        )),
                  ),
                  // Textfield for username
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MyTextField(
                      labelText: "Username",
                      controller: usernameController,
                      obscureText: false,
                    ),
                  ),
                  // Textfield for password
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MyTextField(
                      labelText: "Password",
                      controller: passwordController,
                      obscureText: true,
                    ),
                  ),
                  // Log in button
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MyTextButton(
                      buttonText: "Log in",
                      backgroundColor: Theme.of(context).primaryColor,
                      rectangleShape: true,
                      onPressed: () async {
                        // Making a call to the server to log in by sending up the username and password
                        final status = await auth.login(usernameController.text,
                            passwordController.text, context);

                        // Showing a snackbar to notify the user about how the login went
                        if (context.mounted) {
                          if (status == Status.success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Succesfully logged in")));
                          } else if (status == Status.error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  (auth.errorMessage.isEmpty
                                      ? "Unknown error"
                                      : auth.errorMessage),
                                ),
                              ),
                            );
                          }
                        }
                      },
                    ),
                  ),
                  // Sign up button
                  GestureDetector(
                    onTap: () {
                      context.push('/create/account');
                    },
                    child: Text(
                      "No account? Sign up!",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  )
                ],
              ),
            );
          }
          // If the user is already logged, then display "Welcome back"
          else {
            return Center(
              child: Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.only(top: 250, bottom: 50),
                      child: Text("Welcome back",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            color: Theme.of(context).colorScheme.onSurface,
                          ))),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: MyTextButton(
                      buttonText: "Go to home page",
                      backgroundColor: Theme.of(context).primaryColor,
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
