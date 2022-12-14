import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:ui' as ui;
import 'package:souq/src/Services/AuthenticationService.dart';
import 'package:souq/src/Services/StoreAuthService.dart';
import 'package:souq/src/app.dart';
import 'package:souq/src/blocs/StoreRepository.dart';
import 'package:souq/src/models/CategoryWidget.dart';
import 'package:souq/src/models/Store.dart';
import 'package:souq/src/models/StoryItem.dart';
import 'package:souq/src/ui/CustomProfileAppBar.dart';
import 'package:souq/src/ui/SearchPage.dart';
import '../../Helpers/LoginHelper.dart';
import '../models/CategoryList.dart';
import '../models/CategoryModel.dart';
import '../models/ImageStoreModel.dart';
import '../models/PushNotification.dart';
import '../models/SeenImageModel.dart';
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
late final FirebaseMessaging _messaging;
PushNotification? _notificationInfo;
class _HomeScreenState extends State<HomeScreen> {
  final myController = TextEditingController();
  PickedFile? imageFile = null;
  late int roleId = 0;
  final box = GetStorage();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<CategoryList> categoryList = [];
  Color activeColor = Colors.deepPurpleAccent;
  Color seenColor = Colors.grey;
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
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(0.1),
          child: AppBar(
            backgroundColor: Colors.deepPurpleAccent,
            automaticallyImplyLeading: false,
          ),
        ),
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
                  return SafeArea(
                      child: LimitedBox(
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
                                      Image.asset('assets/images/HomeLogo.png',height: MediaQuery.of(context).size.width * .144,width: MediaQuery.of(context).size.width * .144,),
                                    ],
                                  ),
                                    Padding(
                                      padding: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.025),
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
                                      return Container();
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
                                    "??????????????????",
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
                                          child:  Container());
                                    }
                                    return _buildCategoryList(
                                        context, snapshot.data?.docs ?? [],data);}),
                            ),
                          ],
                        ),
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
                                    Image.asset('assets/images/HomeLogo.png',height: MediaQuery.of(context).size.width * .144,width: MediaQuery.of(context).size.width * .144,),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: MediaQuery.of(context).size.height * 0.025),
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
                            child: Text(isArabic(context) ? "???????? ?????????? ???????????? ???????????? ???? ???????????? ?????????????? ??????????????"  : "Please Sign up/in in order to follow your favorite stores",style: TextStyle(
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
                                  "??????????????????",
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
                                        child: Container());
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
              return  Center(
                child: Container(),
              );
            },

            // Future that needs to be resolved
            // inorder to display something on the Canvas
            future: loadUser(),
          ),

        ),
        bottomNavigationBar: roleId == 1 ?
        ConvexAppBar(
          height: MediaQuery.of(context).size.height * 0.07,
          style: TabStyle.textIn,
          color: CupertinoColors.white,
          backgroundColor: Colors.deepPurpleAccent,
          items: [
            TabItem(
                icon: Icons.home,
                title: isArabic(context) ? '????????????????' : 'Home'),

            TabItem(
                icon: Icons.people,
                title: isArabic(context) ? '????????????' : 'Account'),
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
                          builder: (context) => const profilepage()),
                    ),
                  }
                else
                  {
                    LoginHelper.showLoginAlertDialog(context),
                  }
              }
          },
        ) :
        ConvexAppBar(
          height: MediaQuery.of(context).size.height * 0.07,
          style: TabStyle.fixedCircle,
          color: CupertinoColors.white,
          backgroundColor: Colors.deepPurpleAccent,
          items: [
            TabItem(
                icon: Icons.home,
                title: isArabic(context) ? '????????????????' : 'Home'),
            TabItem(
                icon: Icons.camera_alt,
                title: isArabic(context) ? '??????????' : 'Add') ,
            TabItem(
                icon: Icons.people,
                title: isArabic(context) ? '????????????' : 'Account'),
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
                    Navigator.push(
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
      if(userModel.followedStores.isEmpty) {
        return Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02 , bottom: MediaQuery.of(context).size.height * 0.02 ),
          child: Center(child: Text(isArabic(context) ? "?????????? ???????????? ?????????????? ?????????????? ??????????" : "You can follow stores accounts to see their stories", style: TextStyle(
              fontFamily:'SouqFont'))),
        );
      }
      return ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.only(
            right: MediaQuery.of(context).size.width * 0.004,
            left: MediaQuery.of(context).size.width * 0.004),
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
    await FirebaseFirestore.instance.collection('Categories').get().then((value) => value.docs.forEach((doc) async {
      categoryList = isArabic(context) ? CategoryList.categoryListFromJson(doc['CategoryListAr'] as Map<String, dynamic>)
          : CategoryList.categoryListFromJson(doc['CategoryList'] as Map<String, dynamic>);
    }));
    if(FirebaseAuth.instance.currentUser?.email != null){
      await FirebaseFirestore.instance
          .collection('Users')
          .where('email', isEqualTo: FirebaseAuth.instance.currentUser?.email)
          .get()
          .then((value) => value.docs.forEach((doc) async {
        user = UserModel.fromJson(value.docs.first.data());
      }));

    }else {
      return null;
    }


    return user;
  }
  //StoryStart///////////////////////////////////////////////////////////////////
  Widget _buildListItem(BuildContext context, DocumentSnapshot snapshot, int length, int roleId, UserModel userModel) {
    final store = Store.fromSnapshot(snapshot);
    Color circleColor = activeColor;
    bool isSeen = isAllSeen(store);
    if(isSeen){
      circleColor = seenColor;
    }
    store.stories.sort((a, b) => a.createdAt.compareTo(b.createdAt));

    int startIndex = getLastSeenImageByStore(store);
    List<String> seenImgIds = [];
    return userModel.followedStores.contains(store.storeId.trim()) ?  CupertinoPageScaffold(
      backgroundColor: CupertinoColors.white,
      child: Padding(
        padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.002,
            right: MediaQuery.of(context).size.width * 0.002),
        child: Center(
          child: store.stories.isNotEmpty
              ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(70.0),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image:
                    Image.memory(base64Decode(store.stories.last.img))
                        .image,
                  ),
                  border: Border.all(
                    color: circleColor,
                    width: 3.5,
                    style: BorderStyle.solid,
                  ),
                ),
                width: MediaQuery.of(context).size.height * 0.11,
                height: MediaQuery.of(context).size.height * 0.11,
                child: GestureDetector(
                  onTap: () async {
                    await showCupertinoDialog(
                      context: context,
                      builder: (context) {
                        return CupertinoPageScaffold(
                          child: SafeArea(
                            child: GestureDetector(
                              onVerticalDragUpdate: (details) {
                                int sensitivity = 8;
                                if (details.delta.dy > sensitivity) {
                                  Navigator.pop(context);
                                } else if(details.delta.dy < -sensitivity){
                                  Navigator.pop(context);
                                }
                              },
                              child: StoryPageView(
                                initialStoryIndex: (_)=> startIndex,
                                itemBuilder: (context, pageIndex, storyIndex) {
                                  if(!seenImgIds.contains(store.stories[storyIndex].id)) {
                                    seenImgIds.add(store.stories[storyIndex].id);
                                  }
                                  return Stack(
                                    children: [
                                      Positioned.fill(
                                        child: Container(color: Colors.black),
                                      ),
                                      Positioned.fill(
                                        child: Image.memory(
                                          base64Decode(store.stories[storyIndex].img),
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Container(
                                          width: double.infinity,
                                          margin: EdgeInsets.only(
                                            bottom: 24,
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 24,
                                            vertical: 8,
                                          ),
                                          color:  store.stories[storyIndex].description != null ? Colors.black54 : Colors.transparent,
                                          child: store.stories[storyIndex].description != null
                                              ? DefaultTextStyle(
                                            child: Text(store.stories[storyIndex].description),
                                            style: TextStyle(
                                              decoration: null,
                                              fontSize: 15,
                                              color: Colors.white,
                                            ),
                                            textAlign: TextAlign.center,
                                          )
                                              : SizedBox(),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                                gestureItemBuilder: (context, pageIndex, storyIndex) {
                                  return Row(
                                    children: [
                                      GestureDetector(
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 50, left: 15),
                                            child: Row(
                                              children: [
                                                Container(
                                                  height: 32,
                                                  width: 32,
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: Image.memory(
                                                        base64Decode(store.stories.last.img),
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
                                                  isArabic(context) ? store.nameAr : store.nameEn,
                                                  style: TextStyle(
                                                    fontSize: MediaQuery.of(context).size.width * 0.04,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    decoration: TextDecoration.none,
                                                    fontFamily:'SouqFont',
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
                                                'storeId', isEqualTo:store.storeId.replaceAll(" ", ""))
                                                .get()
                                                .then((value) =>
                                                value.docs.forEach((doc) {
                                                  user = UserModel.fromJson(value.docs.first.data());
                                                }));

                                            await FirebaseFirestore.instance.collection('Users').where(
                                                'email', isEqualTo:AuthenticationService.getAuthInstance().currentUser!.email)
                                                .get()
                                                .then((value) =>
                                                value.docs.forEach((doc) {
                                                  currentUser = UserModel.fromJson(value.docs.first.data());
                                                }));

                                            if (user != null) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>  profilepage(searchStore: UserStore(user,store,),currentUser: currentUser,)),
                                              );
                                              //StoreProfile
                                            }else{
                                              LoginHelper.showErrorAlertDialog(context, "Error");
                                            }
                                          }else{
                                            LoginHelper.showLoginAlertDialog(context);
                                          }
                                        },
                                      ),

                                    ],
                                  );
                                },
                                pageLength: store.stories.length,
                                storyLength: (int pageIndex) {
                                  return store.stories.length;
                                },
                                onPageLimitReached: () {

                                  Navigator.pop(context);
                                },
                                onPageChanged: (_) async{
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ).whenComplete(() => {
                      if(AuthenticationService.isCurrentUserLoggedIn()){
                        markStoriesAsSeenUserStory(store,seenImgIds),
                      }

                    });
                  },
                ),
              ),
                Container(
                height: MediaQuery.of(context).size.height * 0.13,
                width: MediaQuery.of(context).size.height * 0.16,
                child: Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.02,
                    left: MediaQuery.of(context).size.height * 0.04,
               ),
                child: isArabic(context)
                    ? Text(store.nameAr, maxLines: 2,style: TextStyle(
                    fontFamily:'SouqFont'))
                    : Text(store.nameEn, maxLines: 2,style: TextStyle(
                    fontFamily:'SouqFont')),
              ),
    ),
            ],
          )
              : Container(),
        ),
      ),
    ) : Container();
  }
//StoryEnd////////////////////////////////////////////////////////////////////////////////////
//CategoryStart///////////////////////////////////////////////////////////////////////
  Widget _buildCategoryList(BuildContext context, List<DocumentSnapshot>? snapshot, [userData]) {
    List<Store> storesList = [];
    List<int> categories = [];
    List<CategoryWidget> categoryWidgets = [];
    List<StoryContent> storyByCategory = [];
    List<Widget> widgetsList = [];
    Store currentStore;
    List<CategoryList> remainingCategoriesList = [];
    bool isDoFollowing = false;

    snapshot?.reversed
        .map((data) => {
      currentStore = Store.fromSnapshot(data),
      currentStore.storeId = data.id,
      storesList.add(currentStore),
      /*if (!categories.contains(currentStore.category))
        {categories.add(currentStore.category)},*/
      if(currentStore.stories.length > 0)
        for(int i = 0; i< currentStore.stories.length ; i++){
          if(!categories.contains(currentStore.stories[i].category)){
            {categories.add(currentStore.stories[i].category)},
          }
        }
    }).toList();

    remainingCategoriesList = categoryList.where((e) => !categories.contains(e.value) && !remainingCategoriesList.contains(e.value)).toList();

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
        imgs.add(ImageStoreModel(sc.img,sc.storeName,sc.storeId,sc.seenBy.contains(AuthenticationService.getAuthInstance().currentUser?.uid),sc.id,sc.seenBy,sc.description));
      }

      String cateName =  categoryList.where((e) => e.value == category).first?.name ?? "-";

      CategoryWidget categoryWidget = CategoryWidget(getCategoryThumbnail(category),cateName,category, imgs);
      categoryWidgets.add(categoryWidget);
      storyByCategory.clear();
    }

    for(CategoryList category in remainingCategoriesList){
      categoryWidgets.add(CategoryWidget(getCategoryThumbnail(category.value), category.name ,category.value, []));
    }
    categoryWidgets.sort((a, b) => a.categoryID.compareTo(b.categoryID));
    for (CategoryWidget cw in categoryWidgets) {
      int startIndex = getLastSeenImage(cw);
      bool isSeen = isAllCategoryStoriesSeen(cw);
      Color circleColor = activeColor;
      if(isSeen){
         circleColor = seenColor;
      }
      widgetsList.add(CupertinoPageScaffold(
        backgroundColor: CupertinoColors.white,
        child: Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: cw.thumbnailImage,

                  ),
                  border: Border.all(
                    color: circleColor,
                    width: 3.0,
                    style: BorderStyle.solid,
                  ),
                ),
                width: MediaQuery.of(context).size.height * 0.12,
                height: MediaQuery.of(context).size.height * 0.11,
                child: GestureDetector(
                  onTap: () async{
                    if(cw.images.length == 0){
                      LoginHelper.showEmptyCategoryAlertDialog(context);
                      return;
                    }
                    List<SeenImageModel> seenImagesIndexList = [];
                    await showCupertinoDialog(
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
                                initialStoryIndex: (_)=> startIndex,
                                itemBuilder: (context, pageIndex, storyIndex) {
                                  SeenImageModel img = SeenImageModel(storyIndex,cw,cw.images[storyIndex].storeId,cw.images[storyIndex].imageId);
                                  try{
                                    var list = seenImagesIndexList.where((a) => a.imageId == cw.images[storyIndex].imageId);
                                    if(list.isEmpty && !cw.images[storyIndex].seenbyUserIds.contains(AuthenticationService.getAuthInstance().currentUser!.uid)) {
                                      seenImagesIndexList.add(img);
                                    }
                                  }catch (e) {
                                    print(e.toString());
                                  }

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
                                      Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Container(
                                          width: double.infinity,
                                          margin: EdgeInsets.only(
                                            bottom: 24,
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 24,
                                            vertical: 8,
                                          ),
                                          color:  cw.images[storyIndex].description != null ? Colors.black54 : Colors.transparent,
                                          child: cw.images[storyIndex].description != null
                                              ? Text(
                                            cw.images[storyIndex].description,
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.white,
                                            ),
                                            textAlign: TextAlign.center,
                                          )
                                              : SizedBox(),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                                gestureItemBuilder: (context, pageIndex, storyIndex) {
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
                                                        image: cw.thumbnailImage,
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
                                                  'storeId', isEqualTo:cw.images[storyIndex].storeId.replaceAll(" ", "").trim())
                                                  .get()
                                                  .then((value) =>
                                                  value.docs.forEach((doc) {
                                                    user = UserModel.fromJson(value.docs.first.data());
                                                  }));

                                              await FirebaseFirestore.instance.collection('Users').where(
                                                  'email', isEqualTo:AuthenticationService.getAuthInstance().currentUser!.email)
                                                  .get()
                                                  .then((value) =>
                                                  value.docs.forEach((doc) {
                                                    currentUser = UserModel.fromJson(value.docs.first.data());
                                                  }));

                                              if (user != null) {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>  profilepage(searchStore: UserStore(user,storesList.where((element) => element.storeId == cw.images[storyIndex].storeId).first,),currentUser: currentUser,)),
                                                );
                                                //StoreProfile
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
                                                userData != null && userData.storeId != cw.images[storyIndex].storeId && !userData.followedStores.contains(cw.images[storyIndex].storeId)? Visibility(
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
                                                        if(AuthenticationService.isCurrentUserLoggedIn() == false){
                                                          LoginHelper.showLoginAlertDialog(context);
                                                        }else{
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
                                                              await FirebaseFirestore.instance.collection('Store').doc(cw.images[storyIndex].storeId.replaceAll(" ", "")).update({'numOfFollowers': store.numOfFollowers}).then((value) => {
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
                                                          Text(isArabic(context) ? '????????????' :'Follow' , style: TextStyle(
                                                      fontFamily:'SouqFont')),
                                                        ],
                                                      ),

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
                                onPageChanged: (_) async{
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ).whenComplete(() => {
                      if(AuthenticationService.isCurrentUserLoggedIn() && seenImagesIndexList.isNotEmpty)
                            markStoriesAsSeen(seenImagesIndexList),
                        print(seenImagesIndexList),
                    });
                  },
                ),
              ),
              Expanded(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.24,
                  child: Text(cw.categoryName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                      fontFamily:'SouqFont')),
                ),
              ),
            ],
          ),
        ),
      ));
    }
    return Directionality(
      textDirection: isArabic(context) ? ui.TextDirection.rtl : ui.TextDirection.ltr,
      child: GridView.count(
        // Create a grid with 2 columns. If you change the scrollDirection to
        // horizontal, this produces 2 rows.
        crossAxisCount: 3,

        // Generate 100 widgets that display their index in the List.
        children: List.of(widgetsList),
      ),
    );
  }
  //CategoryEnd////////////////////////////////////////////////////////////////////////////////////

  int getLastSeenImageByStore(Store store) {

    var image = store.stories.where((element) => !element.seenBy.contains(AuthenticationService.getAuthInstance().currentUser!.uid));
    int index = 0;
    if(image.isNotEmpty){
      index = store.stories.indexOf(image.first);
    }

    return index;
  }


  bool isAllSeen(Store store){

      var image = store.stories.where((element) => !element.seenBy.contains(AuthenticationService.getAuthInstance().currentUser!.uid));
      if(image.isNotEmpty){
        return false;
      }

      return true;

  }

  void markStoriesAsSeenUserStory(Store store, List<String> seenImgIds) async{
    var storeId = store.storeId;
    List<dynamic> sList = [];
    try {
      for(StoryContent sc in store.stories){
        if(seenImgIds.contains(sc.id)){
          sc.seenBy.add(AuthenticationService.getAuthInstance().currentUser!.uid);
        }
        sList.add(sc.toJson());
      }
      await FirebaseFirestore.instance
          .collection('Store')
          .doc(storeId)
          .update(
          {'Stories': sList});
    }on FirebaseException catch  (e) {
      print(e.message);
    }
  }
}

void markStoriesAsSeen(List<SeenImageModel> seenImagesIndexList) async{
  try {
    for(SeenImageModel sim in seenImagesIndexList){

      var s = await FirebaseFirestore.instance
          .collection('Store')
          .doc(sim.storeId)
          .get();
      DocumentSnapshot snapshot = s;
      Store store = Store.fromSnapshot(snapshot);
      StoryContent sc = store.stories.where((element) => element.id == sim.imageId).first;
      List<dynamic> sList = [];
        sList.add(sc.toJson());
        for(StoryContent s in store.stories){
          if(s.id != sc.id) {
            sList.add(s.toJson());
          }
        }
      if(sc != null){
        int index = store.stories.indexOf(sc);
        if(!sc.seenBy.contains(AuthenticationService.getAuthInstance().currentUser!.uid)) {
          sc.seenBy.add(AuthenticationService.getAuthInstance().currentUser!.uid);
        }

        await FirebaseFirestore.instance
            .collection('Store')
            .doc(sim.storeId)
            .update(
            {'Stories': sList});
      }
    }
  }on FirebaseException catch  (e) {
    print(e.message);
  }
}

int getLastSeenImage(CategoryWidget cw) {

    var image = cw.images.where((element) => element.isSeen == false);
    int index = 0;
    if(image.isNotEmpty){
      index = cw.images.indexOf(image.first);
    }

    return index;
}

bool isAllCategoryStoriesSeen(CategoryWidget cw) {

  var image = cw.images.where((element) => element.isSeen == false);
  if(image.isNotEmpty){
    return false;
  }

  return true;
}


getCategoryThumbnail(int id){
  return AssetImage('assets/Categories/'+ id.toString()+ '.jpg');
}