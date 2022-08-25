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
                  const Text("Select state or province",style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                      fontFamily:'SouqFont'
                  ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
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
                              style: TextStyle(fontSize: 18, color: Colors.white,fontFamily:'SouqFont'),
                              dropdownColor: Colors.transparent,
                              iconEnabledColor: Colors.white, //Icon color
                            ),
                        ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.3,),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.black,
                        fixedSize: Size(MediaQuery.of(context).size.width * 0.31,
                          MediaQuery.of(context).size.height * 0.03,)
                    ),
                    onPressed: ()=> {
                      _saveUserCity(),
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const HomeScreen()),
                      ),
                    }, child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      maximumSize: Size(
                          MediaQuery.of(context).size.height * .12,
                          MediaQuery.of(context).size.height * .03),
                      minimumSize: Size(
                          MediaQuery.of(context).size.height * .12,
                          MediaQuery.of(context).size.height * .03),
                      primary: Colors.black,
                      shape: StadiumBorder(),
                    ),
                    onPressed: () {Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const HomeScreen()),);},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                            isArabic(context) ? 'التالي' : 'Next'),
                        Icon(
                          Icons.navigate_next
                          ,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
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





