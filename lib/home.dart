import 'dart:io';
import 'package:acad_me/widgets/custom_button.dart';
import 'package:acad_me/widgets/teste.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn();
final FirebaseAuth _auth = FirebaseAuth.instance;

Future<FirebaseUser> _handleSignIn() async {
  final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
  print("signed in " + user.displayName);
  return user;
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FirebaseMessaging _fbm = FirebaseMessaging();
  void chamarqrcode(){
    debugPrint('CHANGING SCREEN...');
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Test()));
  }

  @override
  void initState() {
    super.initState();
    _handleSignIn();
    _registrarDevice();
    _fbm.configure(onMessage: (Map<String, dynamic> msg) async {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                content: ListTile(title: Text(msg['notification']['body'])),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Fechar"),
                    onPressed: () {
                     
                    },
                  )
                ],
              ));
    });
  }

  @override
  Widget build(BuildContext context) {
    RoundedRectangleBorder shape;
    
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 64, top: 41
                  ),
                  child: Image.asset(
                    "images/logo.png",
                    alignment: Alignment.topCenter,
                  ),
                ),
                Text(
                  "Gabriel",
                  style: TextStyle(
                    color: Color(0xff373737),
                    fontSize: 35.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 45),
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        CustomButton(nomeButton: "Dados da matrícula",),
                        CustomButton(nomeButton: "Escanear código", ),
                        CustomButton(nomeButton: "Convidar amigo",),
                        

                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ));

        class Navbar extends StatefulWidget {
          @override
          _NavbarState createState() => _NavbarState();
        }
        

  }

          class _NavbarState extends State<Navbar> {
          @override
          Widget build(BuildContext context) {
            return Container();
            BottomNavigationBar: BottomNavigationBar(
              items:[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  title: Text('Home')
                ),
            BottomNavigationBarItem(
              icon: Icon(Icons.photo),
              title: Text('Perfil')
                ),
              ]

            ),
          }
        };

  _registrarDevice() async {
    String tk = await _fbm.getToken();
    if (Platform.isIOS) {
      _fbm.onIosSettingsRegistered.listen((dado) {
        _fbm.subscribeToTopic('ios');
      });
      _fbm.requestNotificationPermissions(IosNotificationSettings());
    } else {
      _fbm.subscribeToTopic('android');
    }
  }
}
