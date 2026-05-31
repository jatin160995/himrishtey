import 'package:flutter/material.dart';
import 'package:himrishtey/controllers/get_values.dart';
import 'package:himrishtey/screens/add_gallery_image.dart';
import 'package:himrishtey/screens/gallery_detail.dart';
import 'package:himrishtey/utils/common.dart';
import 'package:himrishtey/utils/container_radius.dart';
import 'package:himrishtey/utils/variables/api_endpoints.dart';
import 'package:himrishtey/utils/variables/globals.dart';
import 'package:himrishtey/widgets/loading_image.dart';

class Gallery extends StatefulWidget {
  dynamic galleryImages;
  dynamic userInfo;
  bool isUser;
  Gallery(this.galleryImages, this.userInfo, this.isUser, {super.key});

  @override
  State<Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor(),
      appBar: AppBar(
        title: Text(
          widget.userInfo['full_name'] + "'s Gallery",
          style: TextStyle(color: textDark(), fontWeight: FontWeight.bold),
        ),
        actions: [
          widget.isUser
              ? Container(
                  decoration: borderRadius(primaryAccent, 10),
                  margin: EdgeInsets.only(right: 10),
                  height: 38,
                  child: TextButton(
                      onPressed: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddGalleryImages()),
                        );
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.upload,
                            color: textDark(),
                            size: 22,
                          ),
                          SizedBox(width: 3),
                          Text("Add more",
                              style: TextStyle(
                                  color: textDark(),
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold))
                        ],
                      )),
                )
              : Container()
        ],
      ),
      body: GridView.count(
        primary: false,
        padding: const EdgeInsets.all(3),
        crossAxisSpacing: 3,
        mainAxisSpacing: 3,
        crossAxisCount: 3,
        children: loadingImageArray(),
      ),
    );
  }

  List<Widget> loadingImageArray() {
    List<Widget> imgArray = [];
    for (int i = 0; i < widget.galleryImages.length; i++) {
      imgArray.add(GestureDetector(
          onLongPress: () {
            widget.isUser ? _showMyDialog(widget.galleryImages[i], i) : null;
          },
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => GalleryDetail(
                      i, widget.galleryImages, widget.userInfo, widget.isUser)),
            );
          },
          child: LoadingImage(widget.galleryImages[i])));
    }
    widget.isUser
        ? imgArray.add(GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddGalleryImages()),
              );
            },
            child: Container(
              color: darkLightText,
              child: Center(
                child: Icon(
                  Icons.add_a_photo,
                  size: 35,
                ),
              ),
            ),
          ))
        : null;
    return imgArray;
  }

  Future<void> _showMyDialog(dynamic image, int index) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: white,
          title: Row(
            children: [
              Container(
                  height: 50,
                  width: 50,
                  child: LoadingImage(userImages[index]['images'])),
              SizedBox(
                width: 10,
              ),
              const Text('Delete Image'),
            ],
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete this image ?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                deleteImage(index);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  GetValues getValues = new GetValues();
  bool isLoading = false;
  deleteImage(int index) async {
    dynamic responseData = await getValues.getValues(delete_profile_url,
        {"user_id": userInfo['id'], "photo_id": userImages[index]['id']});

    print(responseData.toString());
    loadingState(true);
    if (responseData['success']) {
      loadingState(false);
      // Navigator.pop(context, "1");
      userImages.removeAt(index);
      showToast('Request to delete profile submitted Successfully');
    } else {
      loadingState(false);
      showToast("Something went wrong");
      return [];
    }
  }

  loadingState(bool state) {
    setState(() {
      isLoading = state;
    });
  }
}
