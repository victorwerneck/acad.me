import 'package:acad_me/helpers/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'home.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  void signInWithGoogle() async {
    try {
      AuthenticationHelper auth = AuthenticationHelper();
      final _user = await auth.signInWithGoogle();
      debugPrint(_user.displayName);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Home(
                    user: _user,
                  )));
    } catch (e) {
      debugPrint('Error Google: ' + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final _buttonGoogle = OutlineButton(
      padding: EdgeInsets.all(10.0),
      child: Row(
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
            child: Image.asset(
              "images/google_logo.png",
              alignment: Alignment.topCenter,
              width: 42,
            ),
          ),
          Text(
            'Logar com Google',
            style:
                TextStyle(color: Color.fromRGBO(0, 0, 0, 0.54), fontSize: 18.0),
          )
        ],
      ),
      borderSide: BorderSide(color: Color.fromRGBO(0, 0, 0, 0.54)),
      shape: new RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(4.0),
      ),
      onPressed: signInWithGoogle,
    );

    return FutureBuilder(
      future: AuthenticationHelper().currentUser(),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("images/background.png"),
                  fit: BoxFit.cover),
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: SafeArea(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 36.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Image.asset(
                          "images/logo.png",
                          alignment: Alignment.topCenter,
                        ),
                        _buttonGoogle,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }
        return Home(
          user: snapshot.data,
        );
      },
    );
  }
}
