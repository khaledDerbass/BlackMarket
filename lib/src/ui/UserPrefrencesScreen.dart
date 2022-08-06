import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'HomeScreen.dart';

class UserPrefrencesScreen extends StatefulWidget {
  const UserPrefrencesScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {

    return _UserPrefrencesScreenState();
  }

}


class _UserPrefrencesScreenState extends State<UserPrefrencesScreen>{
  String dropdownValue = 'Amman';
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: CupertinoColors.white,
        body:SafeArea(
          child: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.deepPurple, Colors.white])),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Select your City",style: TextStyle(fontSize: 22),),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1,),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: DecoratedBox(
                        decoration: BoxDecoration(
                            gradient: const LinearGradient(
                                colors: [
                                  Colors.black,
                                  Colors.deepPurpleAccent,
                                  //add more colors
                                ]),
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: const <BoxShadow>[
                              BoxShadow(
                                  color: Color.fromRGBO(0, 0, 0, 0.57), //shadow for button
                                  blurRadius: 5) //blur radius of shadow
                            ]
                        ),
                        child: Padding(
                            padding: const EdgeInsets.only(left:30, right:30),
                            child:DropdownButton(
                              value: dropdownValue,
                              items: const [
                                DropdownMenuItem(
                                  value: "Amman",
                                  child: Text("Amman"),
                                ),
                                DropdownMenuItem(
                                  value: "Irbid",
                                  child: Text("Irbid"),
                                ),
                                DropdownMenuItem(
                                  value: "Zarqa",
                                  child: Text("Zarqa"),
                                )
                              ],
                              onChanged: (value){
                                  setState(() {
                                    dropdownValue = value.toString();
                                  });
                                  print(dropdownValue);
                              },
                              isExpanded: true, //make true to take width of parent widget
                              underline: Container(), //empty line
                              style: TextStyle(fontSize: 18, color: Colors.white),
                              dropdownColor: Colors.deepPurpleAccent,
                              iconEnabledColor: Colors.white, //Icon color
                            )
                        )
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1,),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.black,
                        fixedSize: Size(MediaQuery.of(context).size.width * 0.3, MediaQuery.of(context).size.height * 0.06,)
                    ),
                    onPressed: ()=> {
                      _saveUserCity(),
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const HomeScreen()),
                      ),
                    }, child: Text("Next"),
                  ),
                ],
              ),
            ),
          ),
        )

      ),
    );

  }

  Future<void> _saveUserCity() async {
    final SharedPreferences prefs = await _prefs;

    setState(() {
      prefs.setString('city', dropdownValue);
    });
  }
}

bool isArabic(BuildContext context){
  return context.locale.languageCode == 'ar';
}





