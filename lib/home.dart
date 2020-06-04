import 'package:flutter/material.dart';
import 'package:google_signin/auth.dart';

AuthService authService = AuthService();

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Homepage"),
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              authService.signOut();
              Navigator.pop(context);
            },
            child: Icon(Icons.close),
          ),
          SizedBox(
            width: 20,
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
                maxRadius: 50,
                minRadius: 30,
                backgroundImage: NetworkImage(authService.getUserPicture())),
            SizedBox(
              height: 20,
            ),
            Text(
              "Welcome \nMr. ${authService.getUserdisplayname()}",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Text(authService.getUserEmail()),
            SizedBox(
              height: 10,
            ),
            Text('Status: ${authService.isUserApproved()}')
          ],
        ),
      ),
    );
  }
}
