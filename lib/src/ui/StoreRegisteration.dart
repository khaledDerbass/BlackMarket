import 'package:flutter/material.dart';
import 'CustomProfileAppBar.dart';
import 'HomeScreen.dart';

class StoreRegisteration extends StatefulWidget
{
  const StoreRegisteration({Key? key}) : super(key: key);

  @override
  StoreRegisterationState createState() => StoreRegisterationState();
}
class StoreRegisterationState extends State<StoreRegisteration> {

  @override
  Widget build(BuildContext context) {
    return Material(

      child: NestedScrollView(
        headerSliverBuilder: (context,index) {
          return [
            CustomProfileAppBar(),
          ];
        },
        body: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [


              ],
            ),
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
                      decoration: InputDecoration(
                        fillColor: Colors.transparent,
                        labelText: 'Arabic Name',
                        filled: true,
                      ),
                    ),
                    SizedBox(height:  MediaQuery.of(context).size.height * .05),
                    TextField(
                      decoration: InputDecoration(
                        fillColor: Colors.transparent,
                        filled: true,
                        labelText: 'English Name',
                      ),
                    ),
                    SizedBox(height:  MediaQuery.of(context).size.height * .05),
                    TextField(
                      decoration: InputDecoration(
                        fillColor: Colors.transparent,
                        filled: true,
                        labelText: 'Email',
                      ),
                    ),
                    SizedBox(height:  MediaQuery.of(context).size.height * .05),
                    TextField(
                      decoration: InputDecoration(
                        fillColor: Colors.transparent,
                        filled: true,
                        labelText: 'Phone',
                      ),
                    ),
                    SizedBox(height:  MediaQuery.of(context).size.height * .05),
                    TextField(
                      decoration: InputDecoration(
                        fillColor: Colors.transparent,
                        filled: true,
                        labelText: 'Type of product',
                      ),
                    ),
                    SizedBox(height:  MediaQuery.of(context).size.height * .05),
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        fillColor: Colors.transparent,
                        filled: true,
                        labelText: 'Password',
                      ),
                    ),
                    SizedBox(height:  MediaQuery.of(context).size.height * .05),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              maximumSize: Size(MediaQuery.of(context).size.height * .20, MediaQuery.of(context).size.height * .07),
                              minimumSize: Size(MediaQuery.of(context).size.height * .20, MediaQuery.of(context).size.height * .07),
                              primary: Colors.black,
                              shape: const StadiumBorder(),
                            ),
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()),
                              );
                            },
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              //crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('REGISTER'),
                                Icon(
                                  Icons.content_paste_rounded,
                                  color: Colors.white,
                                ),
                              ],
                            )),
                      ],),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}