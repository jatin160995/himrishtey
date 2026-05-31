import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:himrishtey/utils/common.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({super.key});

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: headingBig("Privacy & Policy"),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          heading("OVERVIEW"),
          SizedBox(
            height: 10,
          ),
          Text("Your privacy is important to us, and so it is transparent about how we collect, use and share information about you. The purpose of this policy is to help you understand:-" +
              "What information do we collect from you? And where do you use it- We provide matrimony service through HimRishtey.com  so we ask for certain personal information which is displayed on the site on your behalf to find the right life partner. You consent through our term and condition to collect, process and share your personal information in order to provide the service. Himrishtey.com when you are availing our servicesCollects two types of information:- information that you give to us and other information that is given to us by someone else (parents etc.). In order to avail the service, you provide the following information:- When registering for our service, you share your personal data with us, such as name, your gender, date of birth, contact details, educational qualifications, employment details, photos, marital status and your interests and sensitive personal data such as health Data, community etc…. In this sequence, only a few fields are mandatory for the user / member, the rest some fields are optional, whether to fill the information in them or not, it is up to the user. The User/Member is solely responsible for maintaining the confidentiality of the Username/Identity and User Password and for all activities and transmissions/transactions. How do we use the information we collect? We use the collected information in the following ways: We create your profile that is visible to other users (male to female, male to female) from the information you submit to provide the service. Managing your account You are given full access to manage your account You can change your information at any time with our approval With whom does we share your information? Except where you are expressly informed on the site or as described in this privacy policy we do not sell, rent, share, trade or give away any of your personal information. with other users We publish  as a profile the information you share with other users in order to provide the Services. The information thus published is provided by you and be careful what you share with other users. You can always control your photo privacy settings by going to the Photo Privacy Options in Settings page. With our service providers and partners We may use third party service providers to provide website and application development, hosting, maintenance, backup, storage, payment processing, analysis and other services for us, which may require them to access or use information about you.  If a service provider needs to access information about you to perform services on our behalf, they do so under close instruction from us, including policies and procedures designed to protect your information. All of our service providers and partners agree to strict confidentiality obligations. but still disclaims any and all responsibility or liability for the accuracy, content, completeness, legality, reliability, or operability or availability of information or materials displayed on this web site by third parties ... With law enforcement agencies we will disclose your personally identifiable information as required by law and when we believe that disclosure is necessary to protect our rights, other members interest and protection and/or comply with a judicial proceeding, court order, or legal process served on our Web site. himrishtey.com is not responsible for any kind of cyber fraud. If someone contacts you and claims himself as our representative and asks for cash or bank transfer, be careful that we do not ask for such things. Our membership plans are done online only. If you are meeting any person with reference to this website, how you are treating him is solely your reaction.")
        ],
      ),
    );
  }
}
