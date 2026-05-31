import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:himrishtey/controllers/get_values.dart';
import 'package:himrishtey/screens/search/quick_search_result.dart';
import 'package:himrishtey/screens/search/search_result_page.dart';
import 'package:himrishtey/utils/common.dart';
import 'package:himrishtey/utils/container_radius.dart';
import 'package:himrishtey/utils/send_analytics.dart';
import 'package:himrishtey/utils/variables/api_endpoints.dart';
import 'package:himrishtey/utils/variables/globals.dart';
import 'package:himrishtey/utils/variables/shared_prefrences.dart';
import 'package:himrishtey/widgets/custom_edit_text.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class QuickSearch extends StatefulWidget {
  const QuickSearch({super.key});

  @override
  State<QuickSearch> createState() => _QuickSearchState();
}

class _QuickSearchState extends State<QuickSearch> {
  SfRangeValues _ageRange = SfRangeValues(18.0, 70.0);
  List<String> religion = [
    '',
    'Hindu',
    "Sikh",
    "Christian",
    "Buddhist",
    "Muslim"
  ];
  List maritalStatus = [
    '',
    'Never married',
    'Widow',
    'Divorcee',
    'Separated',
    'Any',
  ];
  List<String> communities = [
    '',
    'Brahmin',
    'Agarwal',
    'Bhandari',
    'Arora',
    'Aryasamaj',
    'Bahi',
    'Balija Naidu',
    'Bhatia',
    'Chaudhary - Ghirth',
    'Chaurasia',
    'chimbbe',
    'Dhaneshawat Vaish',
    'Dhiman - Vishwakarma',
    'Dhobi',
    'Dumana - SC',
    'Gaddi',
    'Garhwali Rajput',
    'Goswami',
    'Gour',
    'Gujjar',
    'Gupta',
    'Jangumar',
    'Jaat',
    'Jogi',
    'Kavirpanthi',
    'Kalar',
    'Kalinga Vysya',
    'Kamboj',
    'Kamma',
    'Kannada Mogaveera',
    'Karuneekar',
    'Kashmiri Pandit (Brahmin)',
    'Kashyap',
    'Kayasth',
    'Kayastha',
    'Khatri',
    'Koli',
    'Kongu Vellala Gounder',
    'Kori',
    'Koshti',
    'Kshatriya',
    'Kumawat',
    'Kumbara',
    'Kunbi',
    'Kuruba',
    'Labana',
    'Leva Patil',
    'Lingayat',
    'Lohana',
    'Lohar',
    'Maharashtrian',
    'Mali',
    'Mana',
    'Maratha',
    'Maruthuvar',
    'Marvar',
    'Marwari',
    'Mehra',
    'Menon',
    'Mudaliar',
    'Nai- Barbar',
    'Naidu',
    'Nair',
    'Nair Vaniya',
    'Nambiar',
    'Nath',
    'OBC (Barber-Naayee)',
    'other',
    'Padmashali',
    'Prajapati - kumhar',
    'Punjabi',
    'Rajput',
    'Ramdasiya -sc',
    'Rana',
    'Ravidasia',
    'Rawat',
    'Reddy',
    'Sahu',
    'Saini',
    'Sarare  SC',
    'Scheduled Caste',
    'Sepahia',
    'Setti Balija',
    'Shippy',
    'Sindhi',
    'Somvanshi',
    'Sonar',
    'Sood',
    'Sowrashtra',
    'Sutar',
    'Swarnakar',
    'Vaishnav',
    'Walia',
    'Yadav',
    'Any',
    'Valmiki',
  ];

  @override
  void initState() {
    // Send stats to firebase and Pixel
    sendStats("quick_search", map: {
      'event': 'view',
    });
    super.initState();
  }

  TextEditingController religionController = new TextEditingController();
  TextEditingController communityController = new TextEditingController();
  TextEditingController maritalStatusController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor(),
      appBar: AppBar(
        title: headingBig("Quick Search"),
      ),
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.all(20),
            children: [
              heading("Age (" +
                  double.parse(_ageRange.start.toString()).toStringAsFixed(0) +
                  "-" +
                  double.parse(_ageRange.end.toString()).toStringAsFixed(0) +
                  ")"),
              SfRangeSlider(
                min: 18,
                max: 70,
                values: _ageRange,
                stepSize: 1,
                interval: 5,
                showTicks: true,
                showLabels: true,
                enableTooltip: true,
                minorTicksPerInterval: 1,
                activeColor: primaryColor,
                onChanged: (SfRangeValues values) {
                  setState(() {
                    _ageRange = values;
                  });
                },
              ),
              SizedBox(height: 20),
              heading("Religion"),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  // searchPressed("Religion", religion, religionController);
                  multiSelectDialogBox(religion_url, "Religions", "religion",
                      religionController);
                  tempController = religionController;
                },
                child: CustomEditText(false, 16, religionController,
                    TextInputType.text, "Religion"),
              ),
              SizedBox(height: 10),
              //
              SizedBox(height: 10),
              heading("Community"),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  // searchPressed("Community", communities, communityController);
                  multiSelectDialogBox(
                      casts_url, "Casts", "cast", communityController);
                  tempController = communityController;
                },
                child: CustomEditText(false, 16, communityController,
                    TextInputType.text, "Community"),
              ),
              SizedBox(height: 10),
              heading("Marital Status"),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  searchPressed(
                      "Marital Status", maritalStatus, maritalStatusController);
                  // multiSelectDialogBox(marital_url, "Marital_Status",
                  //     "marital_status", maritalStatusController);
                  // tempController = maritalStatusController;
                  // searchPressed("Marital Status", maritals as List,
                  //     maritalStatusController);
                },
                child: CustomEditText(false, 16, maritalStatusController,
                    TextInputType.text, "Marital Status"),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: Container(
                width: double.infinity,
                decoration: borderRadius(primaryColor, 0),
                child: TextButton(
                  onPressed: () {
                    getSearchObject();
                  },
                  child: Text(
                    "Search",
                    style: TextStyle(color: white, fontSize: 15),
                  ),
                ),
              ),
            ),
          ),
          showDialog ? showCustomDialog() : Container()
        ],
      ),
    );
  }

  getSearchObject() async {
    List<Map> searchObj = [];
    //searchObj.add({"name": "profile_id", "value": profileIdController.text});
    //age
    searchObj.add({"name": "age_from", "value": _ageRange.start.toString()});
    searchObj.add({"name": "age_to", "value": _ageRange.end.toString()});
    //height

    if (religionController.text != "") {
      searchObj.add({"name": "religion", "value": religionController.text});
    }
    if (communityController.text != "") {
      searchObj.add({"name": "cast", "value": communityController.text});
    }

    if (maritalStatusController.text != "") {
      searchObj.add(
          {"name": "marital_status", "value": maritalStatusController.text});
    }
    var user_id = await getString(key: userId);
    var genderSaved = await getString(key: gender);
    searchObj.add({"name": "user_id", "value": user_id});
    searchObj
        .add({"name": "gender", "value": genderSaved.toString().toLowerCase()});

    Map finalObj = {};
    for (var val in searchObj) {
      finalObj[val['name']] = val['value'];
    }
    print(finalObj);
    Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) =>
                //QuickSearchResultPage(finalObj, searchObj)
                SearchResultPage(finalObj, searchObj)));

    //  return searchObj;
  }

  searchPressed(String title, List data, TextEditingController controller) {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Scaffold(
            backgroundColor: white,
            appBar: AppBar(
              title: Text(title),
            ),
            body: Container(
              height: 400,
              //color: Colors.amber,
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          height: 400,
                          child: CupertinoPicker(
                            itemExtent:
                                40.0, // Height of each item in the picker
                            onSelectedItemChanged: (int index) {
                              // Callback function when an item is selected
                              // Use 'index' to determine which item was selected
                              setState(() {
                                controller.text = data[index];
                              });
                            },
                            children: listChilds(data),
                          ),
                        )
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      decoration: borderRadius(primaryColor, 6),
                      margin: EdgeInsets.only(right: 10),
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Done',
                          style: TextStyle(color: white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  List<Widget> listChilds(List data) {
    List<Widget> childs = [];
    for (var cellData in data) {
      childs.add(
        Center(
          child: Text(cellData),
        ),
      );
    }
    return childs;
  }

  GetValues getValues = new GetValues();
  bool isLoading = false;

  getData(String url, String keyword) async {
    dynamic responseData = await getValues.get(url);
    loadingState(true);
    if (responseData['success']) {
      loadingState(false);
      return responseData[keyword];
    } else {
      loadingState(false);
      showToast("Something went wrong");
      return [];
    }
  }

  getDataPost(String url, String keyword, Map map) async {
    dynamic responseData = await getValues.getValues(url, map);
    loadingState(true);
    if (responseData['success']) {
      loadingState(false);

      return responseData[keyword];
    } else {
      loadingState(false);
      showToast("Something went wrong");
      return [];
    }
  }

  multiSelectDialogBox(
      String url, String key, String subKey, TextEditingController controller,
      {Map? map}) async {
    showLoadingDialog(context, "Loading...");
    dynamic temp = map == null
        ? await getData(url, key)
        : await getDataPost(url, key, map);
    print(temp);

    for (var val in temp) {
      setState(() {
        valuesCustomWidget.add(val[subKey]);
        idCustomWidget.add(val['id']);
      });
    }
    setState(() {
      showDialog = true;
    });
    hideLoadingDialog(context);
  }

  loadingState(bool state) {
    setState(() {
      isLoading = state;
    });
  }

  bool showDialog = false;
  Widget customWidget = Container();
  late TextEditingController tempController;
  List<String> valuesCustomWidget = [];
  List<String> idCustomWidget = [];
  showCustomDialog() {
    // ignore: use_build_context_synchronously
    List<Widget> childrenWidget = [];
    for (int i = 0; i < valuesCustomWidget.length; i++) {
      childrenWidget.add(GestureDetector(
        onTap: () {
          // showToast(values[index]);
          if (tempController.text == '') {
            setState(() {
              if (tempController.text
                  .split(",")
                  .contains(valuesCustomWidget[i])) {
                List finalVal = tempController.text.split(",");
                finalVal.remove(valuesCustomWidget[i]);
                tempController.text = finalVal.join(",");
                return;
              }
              tempController.text = valuesCustomWidget[i];
            });
          } else {
            setState(() {
              if (tempController.text
                  .split(",")
                  .contains(valuesCustomWidget[i])) {
                List finalVal = tempController.text.split(",");
                finalVal.remove(valuesCustomWidget[i]);
                tempController.text = finalVal.join(",");
                return;
              }
              tempController.text =
                  tempController.text + "," + valuesCustomWidget[i];
            });
          }
          // print(tempController.text.split(","));
        },
        child: Container(
          color: transparent,
          child: Row(
            children: [
              Container(
                  height: 50,
                  child: Center(
                      child: Text(
                    valuesCustomWidget[i],
                    style: TextStyle(fontSize: 19, fontFamily: 'medium'),
                  ))),
              tempController.text.split(",").contains(valuesCustomWidget[i])
                  ? Icon(
                      Icons.done,
                      color: primaryColor,
                    )
                  : Container(),
            ],
          ),
        ),
      ));
    }

    customWidget = ListView(
      children: childrenWidget,
    );
    return Stack(
      children: [
        Container(
          color: transparentBlack,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  height: 300,
                  decoration: borderRadius(white, 20),
                  width: MediaQuery.of(context).size.width - 40,
                  child: customWidget,
                ),
                Container(
                  height: 50,
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  decoration: borderRadius(white, 20),
                  clipBehavior: Clip.antiAlias,
                  child: Row(children: [
                    Expanded(
                        child: Container(
                      color: white,
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            tempController.text = "";
                          });
                        },
                        child: Text(
                          "Reset",
                          style: TextStyle(fontFamily: "medium"),
                        ),
                      ),
                    )),
                    Expanded(
                        child: Container(
                      color: white,
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            valuesCustomWidget.clear();
                            idCustomWidget.clear();
                            tempController = new TextEditingController();

                            showDialog = false;
                          });
                        },
                        child: Text(
                          "Done",
                          style: TextStyle(
                              color: primaryColor, fontFamily: "medium"),
                        ),
                      ),
                    )),
                  ]),
                )
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              setState(() {
                valuesCustomWidget.clear();
                idCustomWidget.clear();
                tempController = new TextEditingController();

                showDialog = false;
              });
            },
          ),
        )
      ],
    );
  }
}
