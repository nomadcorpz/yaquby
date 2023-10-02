import 'package:flutter/material.dart';

// class GlobalVariables {
//   // ignore: constant_identifier_names
//   static const String BASE_URL = "http://20.24.27.195:8093";
// }

class Config {
  // Cenmetrix APIs
  //    http://20.93.155.92:8091/index.html
  static const String appName = "Yaquby";
  // static const String apiURL = "20.24.27.195:8092"; // cenmetrix azure
  static const String apiURL = "20.93.155.92:8091"; // yaquby azure
  static const String loginAPI = "/api/Authenticate/login";
  static const String getAttendanceDetailsAPI = "/api/EmployeeAttendance/GetAttendanceDetails";
  static const String postAttendanceDetailsnAPI = "/api/EmployeeAttendance/SaveAttendanceDetails";
  static const String postSalesData = "/api/Sales/SaveSalesDetails";
  static const String getRepSalesTarget = "/api/Sales/GetRepSalesTarget";
  static const String getSalesSummeryList = "/api/Sales/GetSalesSummaryDetails";
  static const String getSalesSummeryDetailed = "/api/Sales/GetSalesDetails";

  // Yaquby APIs
  static const String apiURLYaquby = "84.255.173.194:8001";
  //http://84.255.173.194:8001/product_by_brand?USER=SUPER&PASS=SUPER&product_brand=BRAUN
  //  {
  //     "product_id": "3410+1106+5103",
  //     "product_name": "BRN.SE3410 + FG1106 + SELS5103",
  //     "product_category": "BRAUN PERSONAL CARE",
  //     "product_brand": "BRAUN P&G",
  //     "selling_price": 0,
  //     "cost_price": 20.4652666666667,
  //     "product_image_url": "http://192.10.164.45:8080/webpage?partno=3410+1106+5103"
  // },
  static const String getProductsByBrand = "product_by_brand?USER=SUPER&PASS=SUPER&product_brand=BRAUN";

  static String MACAddress = "NOT DEFIND";
}

class AppColors {
  static const Color purple200 = Color(0xFFBB86FC);
  static const Color purple500 = Color(0xFF6200EE);
  static const Color purple700 = Color(0xFF3700B3);
  static const Color teal200 = Color(0xFF03DAC5);
  static const Color teal700 = Color(0xFF018786);
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color myButtonColor = Color(0xFF3BC1AC);
  static const Color lightGray = Color(0xFFD9D9D9);
  static const Color colorPrimary1 = Color(0xFF0AB681);
  static const Color colorPrimary2 = Color(0xFF0055A5);
  static const Color colorPrimaryDark = Color(0xFF0055A5);
  static const Color baseColor = Color(0xFFBA181B);
  static const Color colorAccent = Color(0xFFC61C1C);
  static const Color colorAccent2 = Color(0xFFD6785A);
  static const Color colorOrange = Color(0xFFF07524);
  static const Color colorPrimaryText = Color(0xFF212121);
  static const Color colorRed = Color(0xFFED1C24);
  static const Color colorFontGrey = Color(0xFF747474);
  static const Color colorPrimaryText2 = Color(0xFFC5C5C5);
  static const Color colorWhite = Color(0xFFFFFFFF);
  static const Color colorSmokeWhite = Color(0xFFEEEEEE);
  static const Color colorGreen = Color(0xFF50B748);
  static const Color colorDarkGray = Color(0xFF282828);
  static const Color textColor1 = Color(0xFF1F9600);
  static const Color textColor2 = Color(0xFF4F4F4F);
  static const Color textColor3 = Color(0xFFFF0101);
  static const Color textColor4 = Color(0xFFFC6E6E);
  static const Color textColor5 = Color(0xFF6C6C6C);
  static const Color cenmetrixBlue = Color(0xFF0177B8);
  static const Color cenmetrixOrange = Color(0xFFF57435);
  static const Color cenmetrixRed = Color(0xFFEA0034);
}
