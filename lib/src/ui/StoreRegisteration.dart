import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:souq/src/ui/LoginPage.dart';
import '../../Helpers/LoginHelper.dart';
import '../Services/StoreAuthService.dart';
import '../blocs/CategoriesRepoitory.dart';
import '../models/CategoryList.dart';
import '../models/CategoryModel.dart';
import 'CustomProfileAppBar.dart';
import 'HandleScrollWidget.dart';

class StoreRegisteration extends StatefulWidget {
  StoreRegisteration({
    Key? key,
  }) : super(key: key);

  @override
  StoreRegisterationState createState() => StoreRegisterationState();
}

class StoreRegisterationState extends State<StoreRegisteration> {
  final _formKey = GlobalKey<FormState>();
  final _key=GlobalKey<FormFieldState> ;

  bool _submitted = false;

  TextEditingController _nameArController = TextEditingController();
  TextEditingController _nameEnController = TextEditingController();
  final TextEditingController _storeDesc = TextEditingController();
  final TextEditingController _storeLoc = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  CategoriesRepository repository = CategoriesRepository();

  String dropdownvalueName = "Choose Category";
  int? dropdownvalue;
  Timer? _timer;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    EasyLoading.addStatusCallback((status) {
      print('EasyLoading Status $status');
      if (status == EasyLoadingStatus.dismiss) {
        _timer?.cancel();
      }
    });
  }

  String? _errorText(value) {
    if (value.isEmpty) {
      return 'Can\'t be empty';
    } else if (value!.length < 4) {
      return 'Too short, Name must be more than 4 charater';
    } else
      return null;
  }

  String? _errorTextEN(value) {
    if (value.isEmpty) {
      return 'Can\'t be empty';
    } else if (value!.length < 4) {
      return 'Too short, Name must be more than 4 charater';
    } else
      return null;
  }

  String? _errorTextEM(value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    if (value.isEmpty) {
      return 'Can\'t be empty';
    } else if (!regex.hasMatch(value!)) {
      return 'Enter Valid Email';
    } else
      return null;
  }

  String? _errorTextPH(String? value) {
    if (value!.isEmpty) {
      return 'Can\'t be empty, Mobile Number must be of 10 digit';
    } else if (value!.length != 10) {
      return 'Mobile Number must be of 10 digit';
    } else
      return null;
  }

  String? _errorTextPASS(String? value) {
    if (value!.isEmpty) {
      return 'Can\'t be empty, ';
    } else if (value!.length < 6) {
      return 'Too short, Password must be more than 6 digits';
    } else
      return null;
  }

  void _submit() {
    setState(() => _submitted = true);
    if (_formKey.currentState!.validate()) {
      // TODO SAVE DATA
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        automaticallyImplyLeading: false,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(15),
                bottomLeft: Radius.circular(15))),
        title: Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 4,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(Icons.arrow_back_ios_new))
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 2,
              child: Row(
                children: [
                  Center(
                    child: Image.asset(
                      'assets/images/offerstorylogo.png',
                      height: MediaQuery.of(context).size.width * 0.4,
                      width: MediaQuery.of(context).size.width * 0.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Stack(children: [
        SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * .04,
              left: MediaQuery.of(context).size.height * .05,
              right: MediaQuery.of(context).size.height * .05,
              bottom: MediaQuery.of(context).size.height * .01,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    textAlign: TextAlign.center,
                    validator: _errorText,
                    controller: _nameArController,
                    decoration: InputDecoration(
                      //  errorText: _submitted ? _errorTextAR(_nameArController) : null,
                      fillColor: Colors.transparent,
                      labelText:
                          isArabic(context) ? 'الإسم بالعربي' : 'Arabic Name',
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * .05),
                  TextFormField(
                    textAlign: TextAlign.center,
                    validator: _errorTextEN,
                    controller: _nameEnController,
                    decoration: InputDecoration(
                      fillColor: Colors.transparent,
                      labelText: isArabic(context)
                          ? 'الإسم بالإنجليزية'
                          : 'English Name',
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * .05),
                  TextFormField(
                    textAlign: TextAlign.center,
                    validator: _errorTextEM,
                    controller: _emailController,
                    decoration: InputDecoration(
                      fillColor: Colors.transparent,
                      labelText:
                          isArabic(context) ? 'البريد الإلكتروني' : 'Email',
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * .05),
                  TextFormField(
                    textAlign: TextAlign.center,
                    validator: _errorTextPH,
                    controller: _phoneController,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r"[0-9]"),
                      )
                    ],
                    decoration: InputDecoration(
                      fillColor: Colors.transparent,
                      labelText: isArabic(context) ? 'رقم الهاتف' : 'Phone',
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * .05),
                  TextFormField(
                    textAlign: TextAlign.center,
                    validator: _errorTextPASS,
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      fillColor: Colors.transparent,
                      labelText: isArabic(context) ? 'كلمة السر' : 'Password',
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * .05),
                  TextFormField(
                    scrollPadding: EdgeInsets.only(bottom: 150),
                    controller: _storeDesc,
                    decoration: InputDecoration(
                      fillColor: Colors.transparent,
                      labelText: isArabic(context)
                          ? ' وصف المتجر (اختياري)'
                          : 'Store Description (Optional)',
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * .05),
                  LimitedBox(
                    maxHeight: MediaQuery.of(context).size.height * .05,
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
                  SizedBox(height: MediaQuery.of(context).size.height * .05),
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
                          onPressed: () async {
                            _submit();
                            _timer?.cancel();
                            await EasyLoading.show(
                                status: 'loading...',
                                maskType: EasyLoadingMaskType.black,
                                dismissOnTap: false);
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
                              _storeDesc.text,
                              _storeLoc.text,
                            ).then((value) async => {
                                  if (value)
                                    {
                                      LoginHelper.showSuccessAlertDialog(
                                          context,
                                          isArabic(context)
                                              ? 'تم التسجيل بنجاح '
                                              : 'Your account has been created successfully'),

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
                                    },
                                  _timer?.cancel(),
                                  await EasyLoading.dismiss(),
                                });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            //crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                  isArabic(context)
                                      ? 'التسجيل كمتجر'
                                      : 'Register as Store',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'SouqFont',
                                      fontSize: 16)),
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
        )
      ]),
    );
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

    return DropdownButtonFormField(

      decoration: InputDecoration(
        label:
        isArabic(context)
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
          ),
          labelStyle: TextStyle(),
          ),
      // set the color of the dropdown menu
      dropdownColor: Colors.white,
      // Down Arrow Icon
      icon: const Icon(Icons.add_circle_outline),

      //name: dropdownvalueName,
      validator: (value) => value == null ? 'Field Required' : null,
      items: listOfCategories.map((CategoryModel item) {

        return DropdownMenuItem(
          value: item.value,
          child: Text(item.type),
        );
      }).toList(),
      //onReset: ,
      onChanged: (int? newValue) {
        setState(
          () {
            dropdownvalue = newValue!;
          },
        );
      },
      selectedItemBuilder: (BuildContext context) => listOfCategories
          .map((CategoryModel item) => Center(
                child: Text(
                  item.type,
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ))
          .toList(),
    );
  }

  bool isArabic(BuildContext context) {
    return context.locale.languageCode == 'ar';
  }
}
