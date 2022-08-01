import 'package:flutter/material.dart';
import 'package:souq/src/ui/LoginPage.dart';
import '../ui/RegisterPage.dart';


class SideDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          DrawerHeader(
            child: Center(
              child: Text(
                'Souq Story',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.deepPurpleAccent,
            ),
          ),
          ListTile(
            leading: Icon(Icons.app_registration),
            title: Text('Sign up'),
            onTap: () => {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterPage()),
              ),
            },
          ),
          ListTile(
            leading: Icon(Icons.login),
            title: Text('Sign in'),
            onTap: () => {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()),
              ),
            },
          ),
          ListTile(
            leading: Icon(Icons.language),
            title: Text('Language'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.home_filled),
            title: Text('Country/State'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Sign out'),
            onTap: () => {Navigator.of(context).pop()},
          ),
        ],
      ),
    );
  }
}