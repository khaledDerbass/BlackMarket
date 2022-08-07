import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Services/AuthenticationService.dart';
import 'CustomProfileAppBar.dart';
import 'HomeScreen.dart';
import 'StoreRegisteration.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        automaticallyImplyLeading: false,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(25),
                bottomLeft: Radius.circular(25))),
        title: const Center(
          child: Text("Registration"),
        ),
      ),

      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * .07,
                left: MediaQuery.of(context).size.height * .05,
                right: MediaQuery.of(context).size.height * .05,
              ),
              child: Column(
                children: [
                  TextField(
                    onChanged: (value) {},
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      fillColor: Colors.transparent,
                      labelText: 'Username',
                      filled: true,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * .05),
                  TextField(
                    onChanged: (value) {},
                    controller: _emailController,
                    decoration: const InputDecoration(
                      fillColor: Colors.transparent,
                      filled: true,
                      labelText: 'Email',
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * .05),
                  TextField(
                    onChanged: (value) {},
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      fillColor: Colors.transparent,
                      filled: true,
                      labelText: 'Phone',
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * .05),
                  TextField(
                    onChanged: (value) {},
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      fillColor: Colors.transparent,
                      filled: true,
                      labelText: 'Password',
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * .05),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            maximumSize: Size(
                                MediaQuery.of(context).size.height * .20,
                                MediaQuery.of(context).size.height * .07),
                            minimumSize: Size(
                                MediaQuery.of(context).size.height * .20,
                                MediaQuery.of(context).size.height * .07),
                            primary: Colors.black,
                            shape: const StadiumBorder(),
                          ),
                          onPressed: () {
                            final snackBar1 = SnackBar(
                              content: const Text('Your account has been created successfully'),
                            );
                            final snackBar2 = SnackBar(
                              content: const Text('Error during sign up...'),
                            );

                            // Find the ScaffoldMessenger in the widget tree
                            // and use it to show a SnackBar.

                            AuthenticationService.register(
                                _emailController.text,
                                _passwordController.text,
                                _phoneController.text,
                                _usernameController.text)
                                .then((value) => {
                              if (value)
                                {
                                ScaffoldMessenger.of(context).showSnackBar(snackBar1),
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                        const HomeScreen()),
                                  )
                                }else{
                                ScaffoldMessenger.of(context).showSnackBar(snackBar2),
                              }
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //crossAxisAlignment: CrossAxisAlignment.center,
                            children: const [
                              Text('REGISTER'),
                              Icon(
                                Icons.content_paste_rounded,
                                color: Colors.white,
                              ),
                            ],
                          )),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * .05),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                const StoreRegisteration()),
                          );
                        },
                        child: const Text(
                          'Register as Store',
                          style: TextStyle(color: Colors.black),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

}
