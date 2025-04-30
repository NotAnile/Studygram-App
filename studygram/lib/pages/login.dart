import 'package:flutter/material.dart';
import 'package:studygram/components/textbutton.dart';
import '../components/textfield.dart';

//**The page for viewing a single post, including its comments*/
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController usernameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    return Center(
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 200, bottom: 30),
            child: Text("Login",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
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
              buttonBGColor: const Color.fromARGB(255, 159, 122, 165),
              rectangleShape: true,
              onPressed: () {
                // Gör anrop till server för att logga in, skicka med en json av username och password.
                // Ta emot svar och kolla om det är rätt.
                // Ja? Sätt logged in till true
                // Nej? Ändra inget på logged in
              },
            ),
          ),
        ],
      ),
    );
  }
}
