import 'package:flutter/material.dart';

class Gallery extends StatefulWidget {
  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  late OverlayEntry _popupDialog;
  List<String> imageUrls = [
    'https://placeimg.com/640/480/animals',
    'https://placeimg.com/640/480/arch',
    'https://placeimg.com/640/480/nature',
    'https://placeimg.com/640/480/people',
    'https://placeimg.com/640/480/tech',
    'https://placeimg.com/640/480/animals',
    'https://placeimg.com/640/480/arch',
    'https://placeimg.com/640/480/nature',
    'https://placeimg.com/640/480/people',
    'https://placeimg.com/640/480/tech',
    'https://placeimg.com/640/480/nature',
    'https://placeimg.com/640/480/people',
    'https://placeimg.com/640/480/tech',
    'https://placeimg.com/640/480/animals',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.count(
        crossAxisCount: 3,
        childAspectRatio: .5,
        padding: EdgeInsets.all(MediaQuery.of(context).size.height * .002),
        children: imageUrls.map(_createGridTileWidget).toList(),
      ),
    );
  }

  Widget _createGridTileWidget(String url) => Builder(
    builder: (context) => GestureDetector(
      onLongPress: () {
        _popupDialog = _createPopupDialog(url);
        Overlay.of(context)!.insert(_popupDialog);
      },
      onLongPressEnd: (details) => _popupDialog.remove(),
      child: Image.network(url, fit: BoxFit.fill),

    ),
  );

  OverlayEntry _createPopupDialog(String url) {
    return OverlayEntry(
      builder: (context) => AnimatedDialog(
        child: _createPopupContent(url),
      ),
    );
  }
  Widget _createPhotoTitle() => Container(
      width: double.infinity,
      color: Colors.white,
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage('https://placeimg.com/640/480/people'),
        ),
        title: Text(
          'Khaled Derbass',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ));

  Widget _createActionBar() => Container(
    padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * .01),
    color: Colors.white,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Icon(
          Icons.favorite_border,
          color: Colors.black,
        ),
        Icon(
          Icons.chat_bubble_outline_outlined,
          color: Colors.black,
        ),
        Icon(
          Icons.send,
          color: Colors.black,
        ),
      ],
    ),
  );

  Widget _createPopupContent(String url) => Container(
    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.height * .01),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height * .01),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _createPhotoTitle(),
          Image.network(url, fit: BoxFit.fitWidth),
          _createActionBar(),
        ],
      ),
    ),
  );
}

class AnimatedDialog extends StatefulWidget {
  const AnimatedDialog({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  State<StatefulWidget> createState() => AnimatedDialogState();
}

class AnimatedDialogState extends State<AnimatedDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> opacityAnimation;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.easeOutExpo);
    opacityAnimation = Tween<double>(begin: 0.0, end: 0.6).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeOutExpo));

    controller.addListener(() => setState(() {}));
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(opacityAnimation.value),
      child: Center(
        child: FadeTransition(
          opacity: scaleAnimation,
          child: ScaleTransition(
            scale: scaleAnimation,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}