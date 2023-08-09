import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/my_button.dart';
import '../components/my_textfield.dart';
import '../components/show_message.dart';

class ForgotPassPage extends StatefulWidget {
  final emailController;
  const ForgotPassPage({super.key, this.emailController});

  @override
  State<ForgotPassPage> createState() => _ForgotPassPageState();
}

class _ForgotPassPageState extends State<ForgotPassPage> {
  final _emailController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _emailController.text = widget.emailController;
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );

      //pop the loading circle
      Navigator.pop(context);

      ShowMessage().showMessage(
          "link to reset password for your account is sent to your email id ",
          context);
    } on FirebaseAuthException catch (e) {
      //pop the loading circle
      Navigator.pop(context);
      //show error message
      ShowMessage().showMessage(e.code.replaceAll('-', " "), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          elevation: 0,
          toolbarHeight: 100,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Container(
                  child: Text(
                    "       dont worry.\nwe've got your back!",
                    style: TextStyle(fontWeight: FontWeight.w200, fontSize: 25),
                  ),
                ),
              ),
              Container(
                height: 100,
                child: Icon(
                  Icons.train,
                  size: 80,
                ),
              ),
            ],
          ),
        ),
        body: Center(
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.87,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('lib/images/train_bg.jpg'),
                    fit: BoxFit.fitWidth)),
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.36,
                height: MediaQuery.of(context).size.height * 0.5,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Column(children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Text(
                      "Enter your email id so that we can send you a link to reset your password.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  MyTextField(
                      controller: _emailController,
                      hintText: 'email id',
                      obscureText: false),
                  const SizedBox(height: 30),
                  MyButton(
                    onTap: passwordReset,
                    text: 'send password reset link',
                    color: Colors.blue,
                  ),
                ]),
              ),
            ),
          ),
        ));
  }
}
