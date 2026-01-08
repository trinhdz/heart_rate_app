import 'package:firebase_auth/firebase_auth.dart';
import 'package:heart_rate_app/auth/auth.dart';
import 'package:heart_rate_app/screens/loginpage.dart';
import 'package:heart_rate_app/widgets/backgroundwrapper.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerUsername = TextEditingController();

  String? errorMessage = "";

  Future<void> createUser() async {
    try {
      await Auth().creatUserWithEmailAndPassword(
        email: _controllerEmail.text.trim(),
        password: _controllerPassword.text.trim(),
      );

      // Nếu tạo thành công → chuyển về LoginPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Loginpage()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundWrapper(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Container(
            width: 270,
            height: 430,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(95),
              color: const Color(0xFF3B3A55),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 15,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                SizedBox(height: 10),
                avt(),
                SizedBox(height: 25),

                users(),

                SizedBox(height: 10),

                email(),
                SizedBox(height: 10),

                password(),

                SizedBox(height: 15),

                buttonres(),

                SizedBox(height: 5),

                if (errorMessage != "")
                  Text(
                    errorMessage!,
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),

                SizedBox(height: 5),

                // BACK BUTTON
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "back",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  GestureDetector buttonres() {
    return GestureDetector(
      onTap: () {
        createUser();
      },
      child: Container(
        width: 100,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Color.fromRGBO(14, 13, 16, 1),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 15,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Center(
          child: Text("Register", style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  Container password() {
    return Container(
      width: 230,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Color(0xff0E0D10),
      ),
      child: Row(
        children: [
          SizedBox(width: 10),
          Icon(Icons.key, color: Colors.blue),
          SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _controllerPassword,
              obscureText: true,
              style: TextStyle(color: Colors.white),
              cursorColor: Colors.white,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Password",
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                contentPadding: EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container email() {
    return Container(
      width: 230,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Color(0xff0E0D10),
      ),
      child: Row(
        children: [
          SizedBox(width: 10),
          Icon(Icons.email, color: Colors.blue),
          SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _controllerEmail,
              style: TextStyle(color: Colors.white),
              cursorColor: Colors.white,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Email",
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                contentPadding: EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container users() {
    return Container(
      width: 230,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Color(0xff0E0D10),
      ),
      child: Row(
        children: [
          SizedBox(width: 10),
          Icon(Icons.person, color: Colors.blue),
          SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _controllerUsername,
              style: TextStyle(color: Colors.white),
              cursorColor: Colors.white,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "UserName",
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                contentPadding: EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Align avt() {
    return Align(
      alignment: FractionalOffset(0.5, 0.1),
      child: CircleAvatar(
        radius: 40,
        backgroundImage: AssetImage('assets/images/person.png'),
      ),
    );
  }
}
