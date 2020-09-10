import 'package:auth0/auth0_client.dart';
import 'package:auth0_example/login.dart';
import 'package:auth0_example/profile.dart';
import 'package:flutter/material.dart';

const AUTH0_DOMAIN = 'dev-mpl7u4pn.auth0.com';
const AUTH0_CLIENT_ID = 'Fg52qlqEGpvTp8C0RvUVk3x5ZHoQMu0q';
const AUTH0_REDIRECT_URI = 'com.poetadigital.auth0://callback';

void main() {
  Auth0Client.initial(AUTH0_DOMAIN, AUTH0_CLIENT_ID, AUTH0_REDIRECT_URI);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isBusy = false;
  bool isLoggedIn = false;
  String errorMessage;
  String name;
  String picture;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auth0 Demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Auth0 Demo'),
        ),
        body: Center(
          child: isBusy
              ? CircularProgressIndicator()
              : isLoggedIn
                  ? Profile(logoutAction, name, picture)
                  : Login(loginAction, errorMessage),
        ),
      ),
    );
  }

  @override
  void initState()  {
    refreshAction();
    super.initState();
  }

  Future<void> refreshAction() async {
    final decodedToken = await Auth0Client.refreshToken();
    setState(() {
      isBusy = false;
      isLoggedIn = true;
      name = decodedToken['name'];
      picture = decodedToken['picture'];
    });
  }

  Future<void> loginAction() async {
    try {
      final decodedToken = await Auth0Client.login();
      setState(() {
        isBusy = false;
        isLoggedIn = true;
        name = decodedToken['name'];
        picture = decodedToken['picture'];
      });
    } catch (e) {
      setState(() {
        isBusy = false;
        isLoggedIn = false;
        errorMessage = e.toString();
      });
    }
  }

  void logoutAction() async {
    await Auth0Client.logout();
    setState(() {
      isLoggedIn = false;
      isBusy = false;
    });
  }
}
