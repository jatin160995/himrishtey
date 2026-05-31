import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:himrishtey/controllers/get_values.dart';
import 'package:himrishtey/screens/search/search_result_page.dart';
import 'package:himrishtey/utils/common.dart';
import 'package:himrishtey/utils/container_radius.dart';
import 'package:himrishtey/utils/variables/api_endpoints.dart';
import 'package:himrishtey/utils/variables/shared_prefrences.dart';
import 'package:himrishtey/widgets/custom_edit_text.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class AdvanceSearch extends StatefulWidget {
  const AdvanceSearch({super.key});

  @override
  State<AdvanceSearch> createState() => _AdvanceSearchState();
}

class _AdvanceSearchState extends State<AdvanceSearch> {
  bool isLoading = false;
  SfRangeValues _ageRange = SfRangeValues(18.0, 70.0);
  SfRangeValues _heightRange = SfRangeValues(4.6, 7.0);
  SfRangeValues _incomeRange = SfRangeValues(0, 50);
  List<String> states = [
    '',
    "Andhra Pradesh",
    "Arunachal Pradesh",
    "Assam",
    "Bihar",
    "Chhattisgarh",
    "Goa",
    "Gujarat",
    "Haryana",
    "Himachal Pradesh",
    "Jammu and Kashmir",
    "Jharkhand",
    "Karnataka",
    "Kerala",
    "Madhya Pradesh",
    "Maharashtra",
    "Manipur",
    "Meghalaya",
    "Mizoram",
    "Nagaland",
    "Odisha",
    "Punjab",
    "Rajasthan",
    "Sikkim",
    "Tamil Nadu",
    "Telangana",
    "Tripura",
    "Uttarakhand",
    "Uttar Pradesh",
    "West Bengal",
    "Andaman and Nicobar Islands",
    "Chandigarh",
    "Dadra and Nagar Haveli",
    "Daman and Diu",
    "Delhi",
    "Lakshadweep",
    "Puducherry"
  ];
  List<String> religion = [
    '',
    'Hindu',
    "Sikh",
    "Christian",
    "Buddhist",
    "Muslim"
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
  List tongue = [
    '',
    'Punjabi',
    'Hindi',
    'Himachali/Pahadi',
    'Marathi',
  ];
  List employed = [
    '',
    'Govt Job',
    'Private',
    'Defence',
    'Business',
    'Self Employed',
    'Not Employed',
  ];
  List isMangik = [
    '',
    'Yes',
    'No',
  ];
  List maritalStatus = [
    '',
    'Never married',
    'Widow',
    'Divorcee',
    'Separated',
    'Any',
  ];
  List education = [
    '',
    "M.A.",
    "Aeronautical Engineering",
    "B.Arch",
    "BCA",
    "BE",
    "B.Plan",
    "B.Sc IT/ Computer Science",
    "B.Tech",
    "B.S.(Engineering)",
    "M.Arch.",
    "MCA",
    " ME",
    "M.Sc. IT / Computer Science",
    " M.S.(Engg.)",
    "M.Tech.",
    " Aviation Degree",
    "B.A.",
    " B.Com.",
    " BFA",
    " BFT",
    " BLIS",
    " B.M.M.",
    " B.Sc.",
    " B.S.W",
    " B.Phil.",
    " M.A.",
    " MCom",
    "M.Ed.",
    " MFA",
    " MLIS",
    " M.Sc.",
    " MSW",
    " M.Phil.",
    " BBA",
    " BHM (Hotel Management)",
    " MBA",
    " MBA",
    " MFM (Financial Management)",
    " MHM (Hotel Management)",
    "MHRM (Human Resource Management)",
    " PGDM",
    "MHA / MHM (Hospital Administration)",
    " B.A.M.S.",
    " BDS",
    " BHMS",
    "BSMS",
    " BUMS",
    " BVSc",
    "MBBS",
    " MDS",
    " MD / MS (Medical)",
    " MVSc",
    " MCh",
    " DNB",
    "B.Pharm",
    " BPT",
    " B.Sc. Nursing",
    " M.Pharm",
    " MPT",
    " BGL",
    " B.L.",
    " LL.B.",
    " LL.M.",
    " M.L.",
    "CA",
    "CFA (Chartered Financial Analyst)",
    " CS",
    " ICWA",
    " IAS",
    " IES",
    " IFS",
    " IRS",
    " Ph.D.",
    " DM",
    "Postdoctoral fellow",
    " Fellow of National Board (FNB)",
    " Diploma",
    " Polytechnic",
    " Trade School",
    " Higher Secondary School / High School",
    "Any",
    "PGDCA",
    "B.ed",
    "ITI",
    "Under Matric"
  ];
  //
  TextEditingController profileIdController = new TextEditingController();

  TextEditingController stateController = new TextEditingController();
  TextEditingController religionController = new TextEditingController();
  TextEditingController communityController = new TextEditingController();

  TextEditingController motherTongueController = new TextEditingController();
  TextEditingController educationController = new TextEditingController();
  TextEditingController employedInController = new TextEditingController();
  TextEditingController isManglikController = new TextEditingController();
  TextEditingController maritalStatusController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor(),
      appBar: AppBar(
        title: headingBig("Advance search"),
      ),
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 70),
            children: [
              Text(
                "** Fill fields that you want to filter. All fields are not required. **",
                style: TextStyle(color: textLightest()),
              ),
              SizedBox(height: 10),
              heading("Profile Id"),
              SizedBox(height: 10),
              CustomEditText(!isLoading, 16, profileIdController,
                  TextInputType.text, "Enter Profile Id"),
              SizedBox(height: 10),
              heading("Age ((" +
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
              heading("Height (ft) (" +
                  double.parse(_heightRange.start.toString())
                      .toStringAsFixed(1) +
                  "-" +
                  double.parse(_heightRange.end.toString()).toStringAsFixed(1) +
                  ")"),
              SfRangeSlider(
                min: 4.6,
                max: 7.0,
                values: _heightRange,
                stepSize: 0.1,
                interval: 0.4,
                showTicks: true,
                showLabels: true,
                enableTooltip: true,
                minorTicksPerInterval: 1,
                activeColor: primaryColor,
                onChanged: (SfRangeValues values) {
                  setState(() {
                    _heightRange = values;
                  });
                },
              ),
              //

              SizedBox(height: 20),
              heading("State"),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  multiSelectDialogBox(
                      state_url, "States", "name", stateController,
                      map: {"country_id": "1"});
                  tempController = stateController;
                },
                child: CustomEditText(
                    false, 16, stateController, TextInputType.text, "State"),
              ),
              SizedBox(height: 10),
              //
              SizedBox(height: 10),
              heading("Religion"),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  //  searchPressed("Religion", religion, religionController);
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
              heading("Manglik"),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  // dialogBox(income_url, "Annual_Incomes", "annual_income",
                  //     incomeController);
                  staticDialigBox(isManglikController, ["Yes", "No"]);
                },
                child: CustomEditText(false, 15, isManglikController,
                    TextInputType.text, "Manglik",
                    backgroundColor: Color(0xFFf8f8f8)),
              ),
              //
              SizedBox(height: 10),
              heading("Community"),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  multiSelectDialogBox(
                      casts_url, "Casts", "cast", communityController);
                  tempController = communityController;
                  //  searchPressed("Community", communities, communityController);
                },
                child: CustomEditText(false, 16, communityController,
                    TextInputType.text, "Community"),
              ),
              SizedBox(height: 10),
              //
              SizedBox(height: 10),
              heading("Annual Income (lpa) ((" +
                  double.parse(_incomeRange.start.toString())
                      .toStringAsFixed(0) +
                  "-" +
                  double.parse(_incomeRange.end.toString()).toStringAsFixed(0) +
                  ")"),
              SfRangeSlider(
                min: 0,
                max: 50,
                values: _incomeRange,
                stepSize: 1,
                interval: 5,
                showTicks: true,
                showLabels: true,
                enableTooltip: true,
                minorTicksPerInterval: 1,
                activeColor: primaryColor,
                onChanged: (SfRangeValues values) {
                  setState(() {
                    _incomeRange = values;
                  });
                },
              ),
              SizedBox(height: 20),
              //
              SizedBox(height: 10),
              heading("Mother tongue"),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  //  searchPressed(
                  //    "Mother tongue", tongue, motherTongueController);
                  multiSelectDialogBox(toungue_url, "Mother_Tongues",
                      "mother_tongue", motherTongueController);
                  tempController = motherTongueController;
                },
                child: CustomEditText(false, 16, motherTongueController,
                    TextInputType.text, "Mother tongue"),
              ),
              SizedBox(height: 10),
              //
              SizedBox(height: 10),
              heading("Education"),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  // searchPressed("Education", education, educationController);
                  multiSelectDialogBox(education_url, "Educations", "education",
                      educationController);
                  tempController = educationController;
                },
                child: CustomEditText(false, 16, educationController,
                    TextInputType.text, "Education"),
              ),
              SizedBox(height: 10),
              //
              SizedBox(height: 10),
              heading("Employed in"),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  //searchPressed("Employed in", employed, employedInController);
                  multiSelectDialogBox(employer_url, "Employers", "employer",
                      employedInController);
                  tempController = employedInController;
                },
                child: CustomEditText(false, 16, employedInController,
                    TextInputType.text, "Employed in"),
              ),
              // SizedBox(height: 10),
              //
              // SizedBox(height: 10),
              // heading("Is manglik"),
              // SizedBox(height: 10),
              // GestureDetector(
              //   onTap: () {
              //     searchPressed("Is manglik", isMangik, isManglikController);
              //   },
              //   child: CustomEditText(false, 16, isManglikController,
              //       TextInputType.text, "Is manglik"),
              // ),
              SizedBox(height: 10),
              //
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
                },
                child: CustomEditText(false, 16, maritalStatusController,
                    TextInputType.text, "Marital Status"),
              ),
              SizedBox(height: 50),
              //
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: Container(
                height: 60,
                width: double.infinity,
                color: primaryColor,
                child: TextButton(
                  child: Text(
                    "Search",
                    style: TextStyle(
                        color: white, fontSize: 18, fontFamily: "medium"),
                  ),
                  onPressed: () {
                    getSearchObject();
                  },
                ),
              ),
            ),
          ),
          showDialog ? showCustomDialog() : Container()
        ],
      ),
    );
  }

  staticDialigBox(TextEditingController controller, List values) {
    _showDialog(CupertinoPicker(
      magnification: 1.22,
      squeeze: 1.2,
      useMagnifier: true,
      itemExtent: 30,
      scrollController: FixedExtentScrollController(
        initialItem: 0,
      ),
      onSelectedItemChanged: (int selectedItem) {
        setState(() {
          controller.text = values[selectedItem];
          // if (key == "Countries") {
          //   stateController.text = "";
          //   cityController.text = "";
          //   selectedCountryId = ids[selectedItem];
          //   selectedStateId = 0;
          // }
          // if (controller == stateController) {
          //   cityController.text = "";
          //   selectedStateId = ids[selectedItem];
          // }
        });
      },
      children: List<Widget>.generate(values.length, (int index) {
        controller.text = values[0];
        return Center(child: Text(values[index]));
      }),
    ));
  }

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 265,
        padding: const EdgeInsets.only(top: 6.0),
        // The Bottom margin is provided to align the popup above the system navigation bar.
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        // Provide a background color for the popup.
        color: CupertinoColors.systemBackground.resolveFrom(context),
        // Use a SafeArea widget to avoid system overlaps.
        child: Column(
          children: [
            Container(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                      decoration:
                          borderRadius(Color.fromARGB(255, 233, 233, 233), 8),
                      margin: EdgeInsets.only(right: 20),
                      child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("Done")))
                ],
              ),
            ),
            Container(height: 200, child: child),
          ],
        ),
      ),
    );
  }

  dialogBox(
      String url, String key, String subKey, TextEditingController controller,
      {Map? map}) async {
    List<String> values = [];
    List<String> ids = [];

    showLoadingDialog(context, "Loading...");
    dynamic temp = map == null
        ? await getData(url, key)
        : await getDataPost(url, key, map);
    for (var val in temp) {
      values.add(val[subKey]);
      ids.add(val['id']);
    }
    hideLoadingDialog(context);

    _showDialog(CupertinoPicker(
      magnification: 1.22,
      squeeze: 1.2,
      useMagnifier: true,
      itemExtent: 30,
      scrollController: FixedExtentScrollController(
        initialItem: 0,
      ),
      onSelectedItemChanged: (int selectedItem) {
        setState(() {
          controller.text = values[selectedItem];
        });
      },
      children: List<Widget>.generate(values.length, (int index) {
        controller.text = values[0];
        return Center(child: Text(values[index]));
      }),
    ));
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

  getSearchObject() async {
    List<Map> searchObj = [];
    //searchObj.add({"name": "profile_id", "value": profileIdController.text});
    //age
    searchObj
        .add({"name": "age_from", "value": _ageRange.start.toStringAsFixed(1)});
    searchObj
        .add({"name": "age_to", "value": _ageRange.end.toStringAsFixed(1)});
    //height
    searchObj.add({
      "name": "height_from",
      "value": _heightRange.start.toStringAsFixed(1)
    });
    searchObj.add(
        {"name": "height_to", "value": _heightRange.end.toStringAsFixed(1)});
    //income
    searchObj.add({
      "name": "annual_income",
      "value": _incomeRange.start.toStringAsFixed(1)
    });
    searchObj.add({
      "name": "annual_income_to",
      "value": _incomeRange.end.toStringAsFixed(1)
    });
    //
    if (profileIdController.text.trim() != "") {
      searchObj.add({"name": "profile_id", "value": profileIdController.text});
    }
    // if (isManglikController.text.trim() != "") {
    //   searchObj.add({"name": "manglik", "value": isManglikController.text});
    // }
    if (stateController.text != "") {
      searchObj.add({"name": "state_name", "value": stateController.text});
    }
    if (religionController.text != "") {
      searchObj.add({"name": "religion", "value": religionController.text});
    }
    if (communityController.text != "") {
      searchObj.add({"name": "cast", "value": communityController.text});
    }
    if (motherTongueController.text != "") {
      searchObj
          .add({"name": "mother_tongue", "value": motherTongueController.text});
    }
    if (educationController.text != "") {
      searchObj.add({"name": "education", "value": educationController.text});
    }
    if (employedInController.text != "") {
      searchObj
          .add({"name": "employed_in", "value": employedInController.text});
    }
    if (isManglikController.text != "") {
      searchObj.add({"name": "manglik", "value": isManglikController.text});
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
    print(searchObj);
    Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) => SearchResultPage(finalObj, searchObj)));

    //  return searchObj;
  }

  GetValues getValues = new GetValues();

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

  loadingState(bool state) {
    setState(() {
      isLoading = state;
    });
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
