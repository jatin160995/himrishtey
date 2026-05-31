import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:himrishtey/utils/common.dart';
import 'package:himrishtey/utils/container_radius.dart';
import 'package:himrishtey/widgets/loading_image.dart';
import 'package:pinch_zoom/pinch_zoom.dart';

class GalleryDetail extends StatefulWidget {
  dynamic index;
  List images;
  dynamic user;
  bool isUser;
  GalleryDetail(this.index, this.images, this.user, this.isUser, {super.key});

  @override
  State<GalleryDetail> createState() => _GalleryDetailState();
}

class _GalleryDetailState extends State<GalleryDetail> {
  late PageController pageController;
  double currentPage = 0;

  @override
  void initState() {
    pageController = new PageController(initialPage: widget.index);
    currentPage = double.parse(widget.index.toString());
    pageController.addListener(() {
      setState(() {
        currentPage = pageController.page!;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black26,
      body: Stack(
        children: [
          PageView(
            controller: pageController,
            children: loadingImageArray(),
          ),
          topBar(),
        ],
      ),
    );
  }

  List<Widget> loadingImageArray() {
    List<Widget> imgArray = [];
    for (int i = 0; i < widget.images.length; i++) {
      imgArray.add(
        PinchZoom(
          child: CachedNetworkImage(
            imageUrl: widget.images[i],
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                Container(
                    child: Image.asset(
              placeholder,
              fit: BoxFit.cover,
            )),
            errorWidget: (context, url, error) => Image.asset(placeholder),
          ),
          maxScale: 2.5,
          onZoomStart: () {
            //print('Start zooming');
          },
          onZoomEnd: () {
            // print('Stop zooming');
          },
        ),
      );
    }

    return imgArray;
  }

  topBar() {
    return Align(
      alignment: Alignment.topCenter,
      child: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 0),
          color: transparentBlack2,
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    //decoration: borderRadius(transparentBlack, 40),
                    padding: EdgeInsets.all(10),
                    child: Icon(
                      Icons.arrow_back_rounded,
                      color: white,
                    ),
                  )),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  (currentPage + 1).toStringAsFixed(0) +
                      "/" +
                      widget.images.length.toString(),
                  style: TextStyle(
                      color: white, fontWeight: FontWeight.bold, fontSize: 17),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
