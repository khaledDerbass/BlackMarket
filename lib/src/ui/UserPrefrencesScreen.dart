
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../blocs/StoreRepository.dart';
import '../models/Store.dart';
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

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: CupertinoColors.systemPurple,
        body:SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

              DropdownButton<String>(
                value: dropdownValue,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: const TextStyle(color: Colors.black),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (String? newValue) {
                setState(() {
                  dropdownValue = newValue!;
                });
              },
              items: <String>['Amman', 'Irbid', 'Zarqa']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.black,
                      fixedSize: Size(MediaQuery.of(context).size.width * 0.3, MediaQuery.of(context).size.height * 0.06,)
                  ),
                  onPressed: ()=> {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HomeScreen()),
                    ),
                  }, child: Text("Next"),
                ),
              ],
            ),
          ),
        )

      ),
    );

  }
}

bool isArabic(BuildContext context){
  return context.locale.languageCode == 'ar';
}




