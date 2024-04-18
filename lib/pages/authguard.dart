import 'package:basup_ver2/controller/sessionmanager.dart';
import 'package:basup_ver2/pages/index.dart';
import 'package:basup_ver2/pages/login.dart';
import 'package:flutter/material.dart';

class AuthGuard extends StatelessWidget {
  final Widget child;

  AuthGuard({required this.child});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: SessionManager.getLoginStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data == true) {
            print("snapshot.data == tru");
            // User is logged in
            return child;
          } else if (child.runtimeType == LoginScreen) {
            print("child.runtimeType == LoginScreen");
            // If the child is a LoginScreen and user is not logged in, navigate to Index
            // Using a Future to delay the navigation until the build method is completed
            // to avoid calling setState or markNeedsBuild during build.
            Future.microtask(() => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Index())));
            return Container(); // Return an empty container or a loading indicator
          } else {
            print("LoginScreen");
            // Not logged in, show the login screen
            return LoginScreen();
          }
        } else {
          // Still determining the login status, show a loading indicator
          return CircularProgressIndicator();
        }
      },
    );
  }
}
