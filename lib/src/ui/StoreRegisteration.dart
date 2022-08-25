import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:souq/src/ui/LoginPage.dart';
import '../Services/StoreAuthService.dart';
import '../blocs/CategoriesRepoitory.dart';
import '../models/CategoryList.dart';
import '../models/CategoryModel.dart';


class StoreRegisteration extends StatefulWidget {
  const StoreRegisteration({Key? key}) : super(key: key);

  @override
  StoreRegisterationState createState() => StoreRegisterationState();
}

class StoreRegisterationState extends State<StoreRegisteration> {
  final TextEditingController _nameArController = TextEditingController();
  final TextEditingController _nameEnController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  CategoriesRepository repository = CategoriesRepository();
  int dropdownvalue = 1;
  String dropdownValueCity = 'Amman';

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
        title: Center(
          child: Text(
              isArabic(context) ? 'التسجيل كمتجر' : "Registration as Store"),
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
                    controller: _nameArController,
                    decoration: InputDecoration(
                      fillColor: Colors.transparent,
                      labelText:
                          isArabic(context) ? 'الإسم بالعربي' : 'Arabic Name',
                      filled: true,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * .05),
                  TextField(
                    controller: _nameEnController,
                    decoration: InputDecoration(
                      fillColor: Colors.transparent,
                      filled: true,
                      labelText: isArabic(context)
                          ? 'الإسم بالإنجليزية'
                          : 'English Name',
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * .05),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      fillColor: Colors.transparent,
                      filled: true,
                      labelText:
                          isArabic(context) ? 'البريد الإلكتروني' : 'Email',
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * .05),
                  TextField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      fillColor: Colors.transparent,
                      filled: true,
                      labelText: isArabic(context) ? 'رقم الهاتف' : 'Phone',
                    ),
                  ),

                  SizedBox(height: MediaQuery.of(context).size.height * .05),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      fillColor: Colors.transparent,
                      filled: true,
                      labelText: isArabic(context) ? 'كلمة السر' : 'Password',
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * .05),
                  Align(
                    alignment: isArabic(context)
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.width * 0.02,
                          left: MediaQuery.of(context).size.width * 0.02,
                          right: MediaQuery.of(context).size.width * 0.02,
                          bottom: MediaQuery.of(context).size.width * 0.04),
                      child: isArabic(context)
                          ? const Text(
                        ": اختر المدينة",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,

                        ),
                      )
                          : const Text(
                        "Choose City :",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,

                        ),
                      ),
                    ),),
                  LimitedBox(
                    maxHeight: MediaQuery.of(context).size.height * 0.25,
                    maxWidth: MediaQuery.of(context).size.width,
                    child: StreamBuilder<QuerySnapshot>(
                        builder: (context, snapshot) {

                          if (!snapshot.hasData)
                            return const LinearProgressIndicator();
                          return _buildCitiesList(context, snapshot.data?.docs ?? []);
                        }),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * .05),
                  Align(
                    alignment: isArabic(context)
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.width * 0.02,
                          left: MediaQuery.of(context).size.width * 0.02,
                          right: MediaQuery.of(context).size.width * 0.02,
                          bottom: MediaQuery.of(context).size.width * 0.04),
                      child: isArabic(context)
                          ? const Text(
                        ": اختر الفئة",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,

                        ),
                      )
                          : const Text(
                        "Choose Category :",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,

                        ),
                      ),
                    ),),
                  LimitedBox(
                    maxHeight: MediaQuery.of(context).size.height * 0.25,
                    maxWidth: MediaQuery.of(context).size.width,
                    child: StreamBuilder<QuerySnapshot>(
                        stream: repository.getCategoriesStream(),
                        builder: (context, snapshot) {

                          if (!snapshot.hasData)
                            return const LinearProgressIndicator();
                          return _buildCategoriesList(context, snapshot.data?.docs ?? []);
                        }),
                  ),

                  SizedBox(height: MediaQuery.of(context).size.height * .03),
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
                              content: Text(isArabic(context)
                                  ? 'تم التسجيل بنجاح '
                                  : 'Your account has been created successfully'),
                            );
                            final snackBar2 = SnackBar(
                              content: Text(isArabic(context)
                                  ? 'حدث خطأ اثناء عملية التسجيل'
                                  : 'Error during sign up'),
                            );

                            // Find the ScaffoldMessenger in the widget tree
                            // and use it to show a SnackBar.

                            StoreAuthService.register(
                              _emailController.text.toLowerCase().trim(),
                              _passwordController.text,
                              _phoneController.text,
                              _nameArController.text,
                              _nameEnController.text,
                              _categoryController.text,
                            ).then((value) => {
                                  if (value)
                                    {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar1),
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginScreen()),
                                      )
                                    }
                                  else
                                    {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar2),
                                    }
                                });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(isArabic(context) ? 'التسجيل' : 'REGISTER'),
                              Icon(
                                Icons.content_paste_rounded,
                                color: Colors.white,
                              ),
                            ],
                          )),
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
  Widget _buildCategoriesList(BuildContext context, List<DocumentSnapshot>? snapshot) {
    var snapshots = snapshot?.first;
    var list = snapshot!
        .map((data) => CategoryList.fromJson(snapshots!['CategoryList']))
        .toList();
    print("lwngth "   + list.length.toString());
    List<CategoryModel> listOfCategories = [];
    for(int i =0 ;i < list.first.toJson().entries.length; i++){
      if(list.first.toJson().entries.toList().elementAt(i).value != null)
        listOfCategories.add(CategoryModel(list.first.toJson().entries.toList().elementAt(i).key,list.first.toJson().entries.toList().elementAt(i).value));
    }
    return DropdownButton(
      // Down Arrow Icon
        icon: const Icon(Icons.keyboard_arrow_down),
        value:  dropdownvalue,

        items: listOfCategories.map((CategoryModel item) {
          return DropdownMenuItem(
            value: item.value,
            child: Text(item.type),
          );
        }).toList(),

        onChanged: (int? newValue) {
          setState(() {
            dropdownvalue = newValue!;
          });
        });
  }
  Widget _buildCitiesList(BuildContext context, List<DocumentSnapshot>? snapshot) {

    return DropdownButton(
      // Down Arrow Icon
        icon: const Icon(Icons.keyboard_arrow_down),
        value:  dropdownValueCity,

        items:  const [
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
          dropdownValueCity = value.toString();
        });
      },
    //  isExpanded: true, //make true to take width of parent widget
     underline: Container(), //empty line
      style: TextStyle(fontSize: 18,color: Colors.black),
     // dropdownColor: Colors.transparent,
     // iconEnabledColor: Colors.white, //Icon color
    );
  }
  bool isArabic(BuildContext context) {
    return context.locale.languageCode == 'ar';
  }
}
