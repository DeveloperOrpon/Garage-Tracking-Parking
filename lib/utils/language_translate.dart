import 'package:get/get_navigation/src/root/internacionalization.dart';

class LocaleString extends Translations {
  @override
  // TODO: implement keys
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'welcome': "Welcome to Garage Tracking And Parking",
          "welcome_info":
              'Find The best possible way to park your car in Garage Tracking And Parking',
          "phone_text": "CONTINUE WITH PHONE NO",
          "setting_title": "Change Setting",
          "notification": "Notification",
          "your_location": "Your Location",
          "terms": "Terms and Conditions",
          "privacy": "Privacy Policy",
          "help": "Help",
          "logout": "Logout",
        },
        //HINDI LANGUAGE
        'BD_IN': {
          'welcome': 'গ্যারেজ ট্র্যাকিং এবং পার্কিং স্বাগতম',
          "welcome_info":
              "গ্যারেজ ট্র্যাকিং এবং পার্কিং এ আপনার গাড়ি পার্ক করার সর্বোত্তম সম্ভাব্য উপায় খুঁজুন",
          "phone_text": "ফোন নম্বর দিয়ে চালিয়ে যান",
          "setting_title": "সেটিং পরিবর্তন করুন",
          "notification": "বিজ্ঞপ্তি",
          "your_location": "আপনার অবস্থান",
          "terms": "শর্তাবলী",
          "privacy": "গোপনীয়তা নীতি পরিবর্তন",
          "help": "সাহায্য",
          "logout": "লগআউট",
        },
      };
}
