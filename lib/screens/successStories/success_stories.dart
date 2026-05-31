import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:himrishtey/controllers/get_values.dart';
import 'package:himrishtey/screens/successStories/add_story.dart';
import 'package:himrishtey/utils/common.dart';
import 'package:himrishtey/utils/container_radius.dart';
import 'package:himrishtey/utils/variables/api_endpoints.dart';
import 'package:himrishtey/widgets/loader.dart';
import 'package:himrishtey/widgets/loading_image.dart';

class SuccessStories extends StatefulWidget {
  const SuccessStories({super.key});

  @override
  State<SuccessStories> createState() => _SuccessStoriesState();
}

class _SuccessStoriesState extends State<SuccessStories> {
  bool isLoading = false;
  List stories = [];

  @override
  void initState() {
    //getData(success_stories_url);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: headingBig("Success Stories"),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddStory()),
                );
              },
              child: Text(
                "Add story +",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: primaryColor),
              ))
        ],
      ),
      body: isLoading
          ? Center(child: Container(height: 40, child: Loader()))
          : ListView(
              padding: EdgeInsets.all(20),
              children: successCell(),
            ),
    );
  }

  successCell() {
    List<Widget> storyCells = [];
    storyCells.add(Container(
      decoration: borderRadius(Colors.blue[50]!, 8),
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Icon(
            Icons.security_outlined,
            color: Colors.blue,
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text(
              "We don't post all the success stories here. Your privacy is our top most priority. You can send us your story by clicking the button in top right corner.",
              style: TextStyle(color: textMedium(), fontSize: 12),
            ),
          ),
        ],
      ),
    ));
    for (var story in stories) {
      storyCells.add(Container(
        decoration: borderRadius(background, 10),
        margin: EdgeInsets.symmetric(vertical: 7.5),
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: MediaQuery.of(context).size.width - 60,
              width: MediaQuery.of(context).size.width - 60,
              decoration: borderRadius(white, 8),
              clipBehavior: Clip.antiAlias,
              child: LoadingImage(
                  "http://himrishtey.com/photos/ss/" + story['photo']),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              story['groom_name'] + " and " + story['bride_name'],
              style: TextStyle(fontSize: 16, fontFamily: 'medium'),
            ),
            SizedBox(
              height: 6,
            ),
            Text(
              story['detail'],
              style: TextStyle(fontSize: 14, color: textLightest()),
            )
          ],
        ),
      ));
    }
    return storyCells;
  }

  GetValues getValues = new GetValues();

  getData(String url) async {
    loadingState(true);
    dynamic responseData = await getValues.get(url);
    if (responseData['success']) {
      loadingState(false);
      stories = responseData["data"] as List;
      return;
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
