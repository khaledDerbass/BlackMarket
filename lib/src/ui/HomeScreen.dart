import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:souq/Helpers/GEnums.dart';
import 'package:souq/src/Services/AuthenticationService.dart';
import 'package:souq/src/Services/StoreAuthService.dart';
import 'package:souq/src/blocs/StoreRepository.dart';
import 'package:souq/src/models/CategoryWidget.dart';
import 'package:souq/src/models/Store.dart';
import 'package:souq/src/models/StoryItem.dart';
import 'package:souq/src/ui/SearchPage.dart';
import 'package:flutter_stories/flutter_stories.dart';
import '../../Helpers/LoginHelper.dart';
import '../models/ImageStoreModel.dart';
import '../models/UserModel.dart';
import '../models/UserStore.dart';
import 'AddPostScreen.dart';
import 'HeaderWidget.dart';
import 'SideBar Home.dart';
import 'ProfilePage.dart';
import 'dart:async';
import 'package:story/story.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  final myController = TextEditingController();
  PickedFile? imageFile = null;
  late int roleId = 0;
  final box = GetStorage();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isLoading = false;
  @override
  void initState() {
    super.initState();

  }

  String dropdownValue = 'Amman';
  @override
  Widget build(BuildContext context) {
    roleId = box.read("roleID") ?? 0;
    StoreRepository repository = StoreRepository();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: _scaffoldKey,
        drawer: SideDrawer(),
        backgroundColor: CupertinoColors.white,
        body:  RefreshIndicator(
          onRefresh: loadUser,
          child: FutureBuilder(
            builder: (ctx, snapshot) {
              // Checking if future is resolved or not
              if (snapshot.connectionState == ConnectionState.done) {
                // If we got an error
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      '${snapshot.error} occurred',
                      style: TextStyle(fontSize: 18),
                    ),
                  );

                  // if we got our data
                } else if (snapshot.hasData) {
                  // Extracting data from snapshot object
                  var data = snapshot.data as UserModel;
                  print(data.email);
                  return SafeArea(
                      child: Column(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.12,
                            child:  Stack(
                              children: [
                                HeaderWidget(MediaQuery.of(context).size.height * 0.12, false, Icons.account_circle_rounded),
                                Positioned(
                                  left: 13,
                                  child: IconButton(
                                    onPressed: (){
                                      _scaffoldKey.currentState?.openDrawer();
                                    },
                                    icon: Icon(Icons.menu_outlined,color: Colors.white,size: MediaQuery.of(context).size.height * 0.032,),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset('assets/images/logo2.png',height: MediaQuery.of(context).size.width * 0.15,width: MediaQuery.of(context).size.width * 0.15,),

                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.03),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(onPressed: (){
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => const SearchPage()),
                                        );
                                      }, icon: Icon(Icons.search_rounded,color: Colors.white,size: MediaQuery.of(context).size.height * 0.032,))

                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          LimitedBox(
                            maxHeight: MediaQuery.of(context).size.height * 0.25,
                            maxWidth: MediaQuery.of(context).size.width,
                            child: StreamBuilder<QuerySnapshot>(
                                stream: repository.getStores(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData)
                                    return const LinearProgressIndicator();
                                  return _buildList(context, snapshot.data?.docs ?? [],roleId,data);
                                }),
                          ),
                          Align(
                              alignment: isArabic(context)
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context).size.width * 0.02,
                                    left: MediaQuery.of(context).size.width * 0.02,
                                    right: MediaQuery.of(context).size.width * 0.02),
                                child: isArabic(context)
                                    ? const Text(
                                  "التصنيفات",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                      fontFamily:'SouqFont'
                                  ),
                                )
                                    : const Text(
                                  "Categories",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                      fontFamily:'SouqFont'
                                  ),
                                ),
                              )),
                          Expanded(
                            child: StreamBuilder<QuerySnapshot>(
                                stream: repository.getStores(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return SizedBox(
                                        height: MediaQuery.of(context).size.height * 0.01,
                                        width: MediaQuery.of(context).size.width * 0.01,
                                        child: const CircularProgressIndicator());
                                  }
                                  return _buildCategoryList(
                                      context, snapshot.data?.docs ?? [],data);
                                }),
                          ),
                        ],
                      ));
                }else if(snapshot.data == null && FirebaseAuth.instance.currentUser == null){
                  return SafeArea(
                      child: Column(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.12,
                            child:  Stack(
                              children: [
                                HeaderWidget(MediaQuery.of(context).size.height * 0.12, false, Icons.account_circle_rounded),
                                Positioned(
                                  top: 25,
                                  left: 13,
                                  child: IconButton(
                                    onPressed: (){
                                      _scaffoldKey.currentState?.openDrawer();
                                    },
                                    icon: Icon(Icons.menu_outlined,color: Colors.white,size: MediaQuery.of(context).size.height * 0.032,),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset('assets/images/logo2.png',height: MediaQuery.of(context).size.width * 0.16,width: MediaQuery.of(context).size.width * 0.16,),

                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.025,right: MediaQuery.of(context).size.width * 0.03),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(onPressed: (){
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => const SearchPage()),
                                        );
                                      }, icon: Icon(Icons.search_rounded,color: Colors.white,size: MediaQuery.of(context).size.height * 0.032,))

                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding:  EdgeInsets.all(MediaQuery.of(context).size.height * 0.06),
                            child: Text(isArabic(context) ? "يرجى تسجيل الدخول لتتمكن من متابعة المتاجر"  : "Please Sign up/in in order to follow stores",style: TextStyle(
              fontFamily:'SouqFont')),
                          ),
                          Align(
                              alignment: isArabic(context)
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context).size.width * 0.02,
                                    left: MediaQuery.of(context).size.width * 0.02,
                                    right: MediaQuery.of(context).size.width * 0.02),
                                child: isArabic(context)
                                    ? const Text(
                                  "التصنيفات",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                      fontFamily:'SouqFont'
                                  ),
                                )
                                    : const Text(
                                  "Categories",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                      fontFamily:'SouqFont'
                                  ),
                                ),
                              )),
                          Expanded(
                            child: StreamBuilder<QuerySnapshot>(
                                stream: repository.getStores(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return SizedBox(
                                        height: MediaQuery.of(context).size.height * 0.01,
                                        width: MediaQuery.of(context).size.width * 0.01,
                                        child: const CircularProgressIndicator());
                                  }
                                  return _buildCategoryList(
                                      context, snapshot.data?.docs ?? []);
                                }),
                          ),
                        ],
                      ));
                }
              }

              // Displaying LoadingSpinner to indicate waiting state
              return const Center(
                child: CircularProgressIndicator(),
              );
            },

            // Future that needs to be resolved
            // inorder to display something on the Canvas
            future: loadUser(),
          ),

        ),
        bottomNavigationBar: roleId == 1 ? ConvexAppBar(
          height: MediaQuery.of(context).size.height * 0.07,
          style: TabStyle.textIn,
          color: CupertinoColors.white,
          backgroundColor: Colors.deepPurple.withOpacity(0.85),
          items: [
            TabItem(
                icon: Icons.home,
                title: isArabic(context) ? 'الرئيسية' : 'Home'),

            TabItem(
                icon: Icons.people,
                title: isArabic(context) ? 'الحساب' : 'Account'),
          ],
          initialActiveIndex: 0, //optional, default as 0
          onTap: (int i) => {

             if (i == 1)
              {
                if (AuthenticationService.isCurrentUserLoggedIn())
                  {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const profilepage()),
                    ),
                  }
                else
                  {
                    LoginHelper.showLoginAlertDialog(context),
                  }
              }
          },
        ) :ConvexAppBar(
          height: MediaQuery.of(context).size.height * 0.07,
          style: TabStyle.fixedCircle,
          color: CupertinoColors.white,
          backgroundColor: Colors.deepPurple.withOpacity(0.85),
          items: [
            TabItem(
                icon: Icons.home,
                title: isArabic(context) ? 'الرئيسية' : 'Home'),
            TabItem(
                icon: Icons.camera_alt,
                title: isArabic(context) ? 'إضافة' : 'Add') ,
            TabItem(
                icon: Icons.people,
                title: isArabic(context) ? 'الحساب' : 'Account'),
          ],
          initialActiveIndex: 0, //optional, default as 0
          onTap: (int i) => {
            if (i == 1)
              {
                if (AuthenticationService.isCurrentUserLoggedIn())
                  {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddPostPage()),
                    ),
                  }
                else
                  {
                    LoginHelper.showLoginAlertDialog(context),
                  }

                //_showChoiceDialog(context),
              }
            else if (i == 2)
              {
                if (AuthenticationService.isCurrentUserLoggedIn())
                  {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const profilepage()),
                    ),
                  }
                else
                  {
                    LoginHelper.showLoginAlertDialog(context),
                  }
              }
          },
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot>? snapshot, int roleId, UserModel userModel) {
    print(context.locale.languageCode);
    String? loggedInStore = "";
    bool isSignedIn = false;
    if(roleId == 1){
      isSignedIn = AuthenticationService.isCurrentUserLoggedIn();
    }else if(roleId == 2){
      isSignedIn = StoreAuthService.isCurrentUserLoggedIn();
    }else{
      isSignedIn = false;
    }
    if(isSignedIn){
      loggedInStore = AuthenticationService.getAuthInstance().currentUser?.uid;
      print("Num of followed stores " + userModel.followedStores.length.toString());
      if(userModel.followedStores.isEmpty) {
        print("No followed stores");
        return Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02 , bottom: MediaQuery.of(context).size.height * 0.02 ),
          child: Center(child: Text(isArabic(context) ? "يمكنك متابعة المتاجر لمشاهدة قصصهم" : "You can follow stores accounts to see their stories")),
        );
      }
      return ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.only(
            right: MediaQuery.of(context).size.width * 0.01,
            left: MediaQuery.of(context).size.width * 0.01),
        children: snapshot!
            .map((data) => _buildListItem(
            context, data, Store.fromSnapshot(data).stories.length,roleId,userModel))
            .toList(),
      );
    }
    return Container();
  }

  bool isArabic(BuildContext context) {
    return context.locale.languageCode == 'ar';
  }
  Future<UserModel?> loadUser() async {
    late UserModel? user =null;
    if(FirebaseAuth.instance.currentUser?.email != null){
      await FirebaseFirestore.instance
          .collection('Users')
          .where('email', isEqualTo: FirebaseAuth.instance.currentUser?.email)
          .get()
          .then((value) => value.docs.forEach((doc) async {
        user = UserModel.fromJson(value.docs.first.data());
        print(user?.name);
      }));
    }else {
      return null;
    }


    return user;
  }
  Widget _buildListItem(BuildContext context, DocumentSnapshot snapshot, int length, int roleId, UserModel userModel) {
    final store = Store.fromSnapshot(snapshot);
    return userModel.followedStores.contains(store.storeId.trim()) ?  CupertinoPageScaffold(
      backgroundColor: CupertinoColors.white,
      child: Padding(
        padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.004,
            right: MediaQuery.of(context).size.width * 0.004),
        child: Center(
          child: store.stories.isNotEmpty
              ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(60.0),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image:
                    Image.memory(base64Decode(store.stories.last.img))
                        .image,
                  ),
                  border: Border.all(
                    color: CupertinoColors.activeOrange,
                    width: 2.0,
                    style: BorderStyle.solid,
                  ),
                ),
                width: MediaQuery.of(context).size.height * 0.12,
                height: MediaQuery.of(context).size.height * 0.12,
                child: GestureDetector(
                  onTap: () {
                    showCupertinoDialog(
                      context: context,
                      builder: (context) {
                        return CupertinoPageScaffold(
                          child: Story(
                            fullscreen: false,
                            topOffset:
                            MediaQuery.of(context).size.height * 0.06,
                            onFlashForward: Navigator.of(context).pop,
                            onFlashBack: Navigator.of(context).pop,
                            momentCount: store.stories.length,
                            momentDurationGetter: (idx) => const Duration(seconds: 5),
                            momentBuilder: (context, index) => Scaffold(
                              body: Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: CupertinoColors.darkBackgroundGray,
                                      image: DecorationImage(
                                        fit: BoxFit.contain,
                                        image: Image.memory(base64Decode(
                                            store.stories[index].img))
                                            .image,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 70,
                                    left: 20,
                                    child: Row(
                                      children: [
                                        ClipOval(
                                          child: Image(image: Image.memory(base64Decode(store.stories.last.img)).image, height: 25,width: 25,),
                                        ),
                                        SizedBox(width: MediaQuery.of(context).size.width * 0.02,),
                                        Text(isArabic(context) ? store.nameAr : store.nameEn,style: const TextStyle(color: Colors.white,fontSize: 17),),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.005),
                child: isArabic(context)
                    ? Text(store.nameAr)
                    : Text(store.nameEn),
              ),
            ],
          )
              : Container(),
        ),
      ),
    ) : Container();
  }


  Widget _buildCategoryList(BuildContext context, List<DocumentSnapshot>? snapshot, [userData]) {
    List<Store> storesList = [];
    List<int> categories = [];
    List<CategoryWidget> categoryWidgets = [];
    List<StoryContent> storyByCategory = [];
    List<Widget> widgetsList = [];
    Store currentStore;
    bool isDoFollowing = false;

    snapshot!
        .map((data) => {
      currentStore = Store.fromSnapshot(data),
      storesList.add(currentStore),
      if (!categories.contains(Store.fromSnapshot(data).category))
        {categories.add(Store.fromSnapshot(data).category)},
      if(currentStore.stories.length > 0)
        for(int i = 0; i< currentStore.stories.length ; i++){
          if(!categories.contains(currentStore.stories[i].category)){
            {categories.add(currentStore.stories[i].category)},
          }
        }
    })
        .toList();
    print(categories);
    for (int category in categories) {
      for (Store store in storesList) {
        if (store.isApprovedByAdmin) {
          for(StoryContent sc in store.stories){
            sc.storeName = isArabic(context) ? store.nameAr : store.nameEn;
            sc.storeId = store.storeId;
          }
          storyByCategory.addAll(store.stories.where((e) => e.category == category).toList());

        }
      }
      if (storyByCategory.isEmpty) {
        continue;
      }
      List<ImageStoreModel> imgs = [];
      for (StoryContent sc in storyByCategory) {
        imgs.add(ImageStoreModel(sc.img,sc.storeName,sc.storeId));
      }
      CategoryWidget categoryWidget = CategoryWidget(storyByCategory.first.img, Category.fromId(category).name, imgs);
      categoryWidgets.add(categoryWidget);
      storyByCategory.clear();
    }

    for (CategoryWidget cw in categoryWidgets) {
      widgetsList.add(CupertinoPageScaffold(
        backgroundColor: CupertinoColors.white,
        child: Padding(
          padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.004,
              right: MediaQuery.of(context).size.width * 0.004),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: Image.memory(
                        base64Decode(cw.thumbnailImage),

                      ).image,
                    ),
                    border: Border.all(
                      color: CupertinoColors.activeOrange,
                      width: 2.0,
                      style: BorderStyle.solid,
                    ),
                  ),
                  width: MediaQuery.of(context).size.height * 0.12,
                  height: MediaQuery.of(context).size.height * 0.12,
                  child: GestureDetector(
                    onTap: () {
                      showCupertinoDialog(
                        context: context,
                        builder: (context) {
                          return SafeArea(
                            child: Scaffold(
                              body: GestureDetector(
                                onVerticalDragUpdate: (details) {
                                  int sensitivity = 8;
                                  if (details.delta.dy > sensitivity) {
                                    Navigator.pop(context);
                                  } else if(details.delta.dy < -sensitivity){
                                    Navigator.pop(context);
                                  }
                                },
                                child: StoryPageView(
                                  itemBuilder: (context, pageIndex, storyIndex) {
                                    return Stack(
                                      children: [
                                        Positioned.fill(
                                          child: Container(color: Colors.black),
                                        ),
                                        Positioned.fill(
                                          child: Image.memory(
                                            base64Decode(cw.images[storyIndex].img),
                                            fit: BoxFit.contain,
                                          ),
                                        ),

                                      ],
                                    );
                                  },
                                  gestureItemBuilder: (context, pageIndex, storyIndex) {
                                    print(cw.images[storyIndex].storeName + " -- " + cw.images[storyIndex].isFollowButtonVisible.value.toString());
                                    return ValueListenableBuilder(builder: (BuildContext context, value, Widget? child)
                                    {
                                      return Row(
                                        children: [
                                          GestureDetector(
                                            child: Align(
                                              alignment: Alignment.topLeft,
                                              child: Padding(
                                                padding: const EdgeInsets.only(top: 44, left: 8),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      height: 32,
                                                      width: 32,
                                                      decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                          image: Image.memory(
                                                            base64Decode(cw.thumbnailImage),
                                                            fit: BoxFit.cover,
                                                          ).image,
                                                          fit: BoxFit.cover,
                                                        ),
                                                        shape: BoxShape.circle,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 8,
                                                    ),
                                                    Text(
                                                      cw.images[storyIndex].storeName,
                                                      style: TextStyle(
                                                        fontSize: 17,
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            onTap: () async{
                                              if(AuthenticationService.isCurrentUserLoggedIn()){
                                                late UserModel user;
                                                late UserModel currentUser;
                                                await FirebaseFirestore.instance.collection('Users').where(
                                                    'storeId', isEqualTo:cw.images[storyIndex].storeId.replaceAll(" ", ""))
                                                    .get()
                                                    .then((value) =>
                                                    value.docs.forEach((doc) {
                                                      user = UserModel.fromJson(value.docs.first.data());
                                                      print(user.name);
                                                    }));

                                                await FirebaseFirestore.instance.collection('Users').where(
                                                    'email', isEqualTo:AuthenticationService.getAuthInstance().currentUser!.email)
                                                    .get()
                                                    .then((value) =>
                                                    value.docs.forEach((doc) {
                                                      currentUser = UserModel.fromJson(value.docs.first.data());
                                                      print(user.name);
                                                    }));

                                                if (user != null) {
                                                  Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>  profilepage(searchStore: UserStore(user,storesList.where((element) => element.storeId == cw.images[storyIndex].storeId).first,),currentUser: currentUser,)),
                                                  );
                                                }else{
                                                  LoginHelper.showErrorAlertDialog(context, "Error");
                                                }
                                              }else{
                                                LoginHelper.showLoginAlertDialog(context);
                                              }
                                            },
                                          ),
                                          Align(
                                            alignment: Alignment.topRight,
                                            child: Padding(
                                              padding: const EdgeInsets.only(top: 35,left: 10,right: 10),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  userData != null && !userData.followedStores.contains(cw.images[storyIndex].storeId)? Visibility(
                                                    visible: cw.images[storyIndex].isFollowButtonVisible.value && !userData.followedStores.contains(cw.images[storyIndex].storeId),
                                                    child: ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                          maximumSize: Size(
                                                              MediaQuery.of(context).size.height *
                                                                  .1,
                                                              MediaQuery.of(context).size.height *
                                                                  .04),
                                                          minimumSize: Size(
                                                              MediaQuery.of(context).size.height *
                                                                  .1,
                                                              MediaQuery.of(context).size.height *
                                                                  .04),
                                                          primary: Colors.pinkAccent.withOpacity(0.3),
                                                        ),
                                                        onPressed: () async{
                                                          print("Try to follow");
                                                          if(AuthenticationService.isCurrentUserLoggedIn() == false){
                                                            LoginHelper.showLoginAlertDialog(context);
                                                          }else{

                                                            print("follow");
                                                            UserModel user = userData;
                                                            WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
                                                              isDoFollowing = true;
                                                              cw.images[storyIndex].isFollowButtonVisible.value = false;
                                                              user.followedStores.add(cw.images[storyIndex].storeId.replaceAll(" ", ""));
                                                            },));
                                                            Store store = Store.fromSnapshot(await FirebaseFirestore.instance.collection('Store').doc(cw.images[storyIndex].storeId.replaceAll(" ", "")).get());
                                                            store.numOfFollowers +=1;
                                                            await FirebaseFirestore.instance.collection('Users').where('email' , isEqualTo: FirebaseAuth.instance.currentUser!.email).get().then((value) async => {
                                                              await FirebaseFirestore.instance.collection('Users').doc(value.docs.first.id).update(
                                                                  {
                                                                    'followedStores':FieldValue.arrayUnion(user.followedStores)
                                                                  }).then((value) async => {

                                                                await FirebaseFirestore.instance.collection('Store').doc(store.storeId.trim()).update({'numOfFollowers': store.numOfFollowers}).then((value) => {
                                                                  setState(() {
                                                                    isDoFollowing = false;
                                                                  })
                                                                })

                                                              }),
                                                            });


                                                          }


                                                        },
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment.center,
                                                          children:  [
                                                            Text(isArabic(context) ? 'متابعة' :'Follow'),
                                                          ],
                                                        )
                                                    ),
                                                  ) : Container(),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    }, valueListenable: cw.images[storyIndex].isFollowButtonVisible,
                                    );
                                  },
                                  pageLength: cw.images.length,
                                  storyLength: (int pageIndex) {
                                    return cw.images.length;
                                  },
                                  onPageLimitReached: () {
                                    Navigator.pop(context);
                                  },
                                  onPageChanged: (_) {
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.005),
                  child: Text(cw.categoryName),

                ),
              ],
            ),
          ),
        ),
      ));
    }
    return GridView.count(
      // Create a grid with 2 columns. If you change the scrollDirection to
      // horizontal, this produces 2 rows.
      crossAxisCount: 3,
      // Generate 100 widgets that display their index in the List.
      children: List.of(widgetsList),
    );
  }
}
