import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../utils/common.dart';

class LoadingImage extends StatefulWidget {
  String imageUrl;
  LoadingImage(this.imageUrl);
  @override
  _LoadingImageState createState() => _LoadingImageState();
}

class _LoadingImageState extends State<LoadingImage> {
  @override
  Widget build(BuildContext context) {
    //print(widget.imageUrl);
    return /* Container(
      color: primaryColor,
      child: FadeInImage.assetNetwork(
          placeholder: loadImgPath,
          fit: BoxFit.cover,
          image: widget
              .imageUrl 
          ),
    )*/
        Container(
      color: backgroundColor(),
      child: CachedNetworkImage(
        imageUrl: widget.imageUrl,
        fit: BoxFit.cover,
        progressIndicatorBuilder: (context, url, downloadProgress) => Container(
            child: Image.asset(
          placeholder,
          fit: BoxFit.cover,
        )),
        errorWidget: (context, url, error) => Image.asset(placeholder),
      ),
    );
  }
}
