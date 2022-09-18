import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:souq/src/ui/LoginPage.dart';
import '../Services/StoreAuthService.dart';
import '../blocs/CategoriesRepoitory.dart';
import '../models/CategoryList.dart';
import '../models/CategoryModel.dart';
import 'CustomProfileAppBar.dart';

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

  // define a list of options for the dropdown
  final List<String> Cities = ["Amman", "Irbid", "Zarqa"];
  // the selected value
  String? _selectedCity;
  int? dropdownvalue;
  @override
  Widget build(BuildContext context) {
    return Material(
        child: NestedScrollView(
      headerSliverBuilder: (context, index) {
        return [
          CustomProfileAppBar(false),
        ];
      },
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
                  LimitedBox(
                    maxHeight: MediaQuery.of(context).size.height * 0.25,
                    maxWidth: MediaQuery.of(context).size.width,
                    child: DropdownButton<String>(
                      value: _selectedCity,
                      onChanged: (value) {
                        setState(() {
                          _selectedCity = value;
                        });
                      },
                      hint: Center(
                          child: isArabic(context)
                              ? const Text(
                                  "  اختر المدينة",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : Text(
                                  'Choose City  ',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'SouqFont'),
                                )),
                      // Hide the default underline
                      underline: Container(),
                      // set the color of the dropdown menu
                      dropdownColor: Colors.white,
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.black,
                      ),
                      // isExpanded: true,

                      // The list of options
                      items: Cities.map((e) => DropdownMenuItem(
                            value: e,
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                e,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          )).toList(),

                      // Customize the selected item
                      selectedItemBuilder: (BuildContext context) =>
                          Cities.map((e) => Center(
                                child: Text(
                                  e,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              )).toList(),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * .03),
                  LimitedBox(
                    maxHeight: MediaQuery.of(context).size.height * .25,
                    maxWidth: MediaQuery.of(context).size.width,
                    child: StreamBuilder<QuerySnapshot>(
                        stream: repository.getCategoriesStream(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData)
                            return const LinearProgressIndicator();
                          return _buildCategoriesList(
                              context, snapshot.data?.docs ?? []);
                        }),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * .03),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            maximumSize: Size(
                                MediaQuery.of(context).size.height * .30,
                                MediaQuery.of(context).size.height * .07),
                            minimumSize: Size(
                                MediaQuery.of(context).size.height * .30,
                                MediaQuery.of(context).size.height * .07),
                            primary: Colors.black,
                            shape: const StadiumBorder(),
                          ),
                          onPressed: () {
                            final snackBar1 = SnackBar(
                                content: Text(
                              isArabic(context)
                                  ? 'تم التسجيل بنجاح '
                                  : 'Your account has been created successfully',
                              style: TextStyle(fontFamily: 'SouqFont'),
                            ));
                            final snackBar2 = SnackBar(
                              content: Text(
                                isArabic(context)
                                    ? 'حدث خطأ اثناء عملية التسجيل'
                                    : 'Error during sign up',
                                style: TextStyle(fontFamily: 'SouqFont'),
                              ),
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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            //crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(isArabic(context) ? 'التسجيل كمتجر' : 'Register as Store',
                                  style: TextStyle(fontWeight:FontWeight.bold ,   fontFamily:'SouqFont',fontSize: 16)),
                              Icon(
                                Icons.warehouse_outlined,
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
    ));
  }

  Widget _buildCategoriesList(
      BuildContext context, List<DocumentSnapshot>? snapshot) {
    var snapshots = snapshot?.first;
    var list = isArabic(context)
        ? CategoryList.categoryListFromJson(
            snapshots!['CategoryListAr'] as Map<String, dynamic>)
        : CategoryList.categoryListFromJson(
            snapshots!['CategoryList'] as Map<String, dynamic>);
    print(list.first.name);
    print("lwngth " + list.length.toString());
    List<CategoryModel> listOfCategories = [];
    for (int i = 0; i < list.length; i++) {
      listOfCategories.add(CategoryModel(list[i].name, list[i].value));
    }

    return DropdownButton(
        hint: Center(
            child: isArabic(context)
                ? const Text(
                    "  اختر الفئة",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : Text(
                    "Choose Category  ",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'SouqFont'),
                  )),
        // Hide the default underline
        underline: Container(),
        // set the color of the dropdown menu
        dropdownColor: Colors.white,

        // Down Arrow Icon
        icon: const Icon(Icons.keyboard_arrow_down),
        value: dropdownvalue,
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
        },
        selectedItemBuilder: (BuildContext context) =>
            listOfCategories.map((CategoryModel item) => Center(
              child: Text(
            item.type,
            style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.bold),
          ),
        )).toList(),);
  }

  bool isArabic(BuildContext context) {
    return context.locale.languageCode == 'ar';
  }
}
