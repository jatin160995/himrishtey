import 'package:himrishtey/utils/variables/globals.dart' as globals;

String domain_url = globals.isHimrishtey == 1
    ? "https://himrishtey.com/apis/"
    : globals.isHimrishtey == 2
        ? "https://devbhoomirishtey.com/apis/"
        : "https://dogririshtey.com/apis/";
String domain_live_url = globals.isHimrishtey == 1
    ? "https://himrishtey.com/apis/"
    : globals.isHimrishtey == 2
        ? "https://devbhoomirishtey.com/apis/"
        : "https://dogririshtey.com/apis/";
//End Points

//User
String login_url = domain_url + "user/login";
String get_profile_url = domain_url + "profile/user/";
String get_stats_url = domain_url + "profile/stats/";
String reset_password_url = domain_url + "user/reset_password";
String get_other_profile_url = domain_url + "profile/view";
String upload_profile_pic = domain_url + "user/update_profile_photo";
String shortList_profile = domain_url + "profile/shortlist_profile";
String remove_shortList_profile = domain_url + "profile/remove_from_shortlist";
String update_profile_url = domain_url + "profile/profile_update";
String viewed_profile_url = domain_url + "profile/viewed_contacts";
String delete_profile_url = domain_url + "profile/delete_profile";
String hide_profile_url = domain_url + "profile/hide_profile";
String report_profile_url = domain_url + "profile/report_profile";
String view_my_profile_url = domain_url + "profile/view_my_profile/";

String view_profile_url = domain_url + "profile/view_contact";
String set_partner_preferences_url =
    domain_url + "profile/set_partner_preferences";
String add_gallery_url = domain_url + "profile/add_gallery";
String delete_gallery_url = domain_url + "profile/delete_gallery_image";

//Wallet, Plans, Payment
String get_memberships_url = domain_url + "profile/get_memberships";
String get_memberships_plans_url = domain_url + "profile/get_plans";
String get_wallet_url = domain_url + "profile/wallet_details";
String update_wallet_url = domain_url + "profile/update_wallet_balance";
String update_payment_status_url = domain_url + "profile/update_payment_status";

//Signup
String signup_step_one = domain_url + "user/step_one_registration";
String signup_step_one_ios = domain_url + "user/step_one_ios_registration";
String signup_step_two = domain_url + "user/registration_step_two";
String signup_step_three = domain_url + "user/registration_step_three";
String signup_step_four = domain_url + "user/registration_step_four";

// Home Page
String recent_profile_url = domain_url + "profile/recent_profiles";
String shortlisted_profiles_url = domain_url + "profile/shortlisted_profiles";
String verified_profiles_url = domain_url + "profile/verified_profiles";
String matching_profiles_url = domain_url + "profile/matching_profiles";
String who_viewed_profile_url = domain_url + "profile/who_viewed";
String who_liked_profile_url = domain_url + "profile/who_likes";
String viewed_by_me_url = domain_url + "profile/viewed_by_me";

// Search
String search_by_id_url = domain_url + "profile/search_profile_by_id";
String advance_search_url = domain_url + "profile/advance_search";
String quick_search_url = domain_url + "profile/quick_search";

// Get Values
String configs_url = domain_url + "user/app_config";
String profile_for_url = domain_url + "user/profile_created_for";
String religion_url = domain_url + "user/religions";
String casts_url = domain_url + "user/casts";
String countries_url = domain_url + "user/countries";
String state_url = domain_url + "user/states";
String city_url = domain_url + "user/cities";
String education_url = domain_url + "user/educations";
String employer_url = domain_url + "user/employer";
String occupations_url = domain_url + "user/occupations";
String income_url = domain_url + "user/annual_incomes";
String marital_url = domain_url + "user/marital_status";
String toungue_url = domain_url + "user/mother_tongues";
String heights_url = domain_url + "user/heights";
String family_url = domain_url + "user/family_status";

// Interests
String get_interests_url = domain_url + "profile/all_interest_list";
String send_interests_url = domain_url + "profile/send_interest";
String accept_interests_url = domain_url + "profile/interest_action";
String delete_interests_url = domain_url + "profile/delete_interest";

//like
String like_url = domain_url + "profile/profile_like";
String unlike_url = domain_url + "profile/profile_unlike";

// Success Stories
String success_stories_url = domain_url + "profile/success_stories";
String add_success_stories_url = domain_url + "profile/add_success_story";

//OTP
String otp_login_url = domain_live_url + "user/otp_login";
String otp_verify_url = domain_live_url + "user/get_user_data_from_otp";
String callback_number_url = domain_live_url + "profile/callback_number";
String callback_url = domain_live_url + "profile/call_back";
String forgot_password_url = domain_live_url + "user/forget_password";
String forgot_password_update_url = domain_live_url + "user/update_password";
String verify_mobile_otp_url = domain_live_url + "user/verify_mobile_otp";
String verify_mobile_url = domain_live_url + "user/verify_mobile";

//Rating
String add_rating_url = domain_url + "profile/rating_us";
