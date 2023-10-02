import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:yaquby/config.dart';
import 'package:yaquby/servives/global_variables.dart';
import 'package:yaquby/servives/shared_services.dart';
import 'package:yaquby/views/customWidgets/CurrentTimeAndDateWidget.dart';
import 'package:yaquby/views/customWidgets/DashboardButtonWidget.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yaquby/views/customWidgets/TargetProgressCustomWidget.dart';
import 'package:yaquby/views/sampleScreens/ProfileV.dart';
import 'package:yaquby/views/screens/sales_list_history_screen.dart';
import 'package:yaquby/views/screens/sales_screen.dart';
import '../../models/login_response_model.dart';
import '../../providers/location_providers.dart';
import '../../servives/token_manager.dart';
import 'attendanceScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final double sales;
}

class _HomeScreenState extends State<HomeScreen> {
  LoginResponseModel? _loginResponse;
  Userlocations? _selectedLocation;
  List<_SalesData> data = [_SalesData('Jan', 35), _SalesData('Feb', 28), _SalesData('Mar', 34), _SalesData('Apr', 32), _SalesData('May', 40)];

  late String username = "";
  late String userlocation = "selected_location";
  late DateTime _expirationTime;
  late String platformVersion;
  bool isProductDataLoaded = false;

  @override
  void initState() {
    super.initState();
    getSavedData();
    TokenManager().setContext(context);

    // Call the initialization method here
    initData();
  }

  DataManagerProvider dataManagerProvider = DataManagerProvider();

  Future<void> initData() async {
    print("START API CALL");
    // username = dataManagerProvider.loginResponse_DM!.data.userName;

    await dataManagerProvider.getCurrentLocation();
    await dataManagerProvider.fetchReptargets(dataManagerProvider.loginResponse_DM!.data.userId);

    await dataManagerProvider.fetchAllCategories();
    await dataManagerProvider.fetchAllBrands();
    await dataManagerProvider.fetchProductsByStockWithName(" ");

    print("REP TARGETS ${dataManagerProvider.repTargets}");
    setState(() {
      isProductDataLoaded = true;
    });
  }

  bool isProfileLoaded = false;

  Future<void> getSavedData() async {
    _loginResponse = await SharedService.loginDetails();
    _selectedLocation = await SharedService.getSelectedUserLocation();

    dataManagerProvider.loginResponse_DM = _loginResponse;
    dataManagerProvider.selectedLocation_DM = _selectedLocation;

    if (_loginResponse != null) {
      setState(() {
        username = _loginResponse!.data.userName;
        isProfileLoaded = true;
        _expirationTime = DateTime.parse(_loginResponse!.data.expires);
        TokenManager().expirationTime = _expirationTime;
        print(_expirationTime);
        print("USER - " + username);
      });
    }
    if (_selectedLocation != null) {
      setState(() {
        userlocation = _selectedLocation!.description;
        print(userlocation);
        print(_selectedLocation!.description);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final locationProvider = Provider.of<LocationProvider>(context);
    //final selectedLocation = ;

    if (_selectedLocation == null) {
      setState(() {
        _selectedLocation = locationProvider.selectedLocation;
        print(userlocation);
      });
    }

    void navigateToAttendanceScreen() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const AttendanceScreen(),
        ),
      );
    }

    void navigateToSalesHistoryListScreen() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SalesListHistoryScreen(),
        ),
      );
    }

    void navigateToSalesScreen() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SalesScreen(),
        ),
      );
    }

    // Access the DataManagerProvider instance
    final dataManagerProvider = Provider.of<DataManagerProvider>(context);

    return Scaffold(
      appBar: AppBar(toolbarHeight: 0, title: null, backgroundColor: AppColors.cenmetrixBlue, leading: null),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/dashboard_background.png'),
              // Replace with the path to your background image
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            children: [
              // ignore: sized_box_for_whitespace
              Container(
                height: 48,
                color: Colors.white60,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    Image.asset(
                      'assets/icons/ic_store1.png',
                      width: 24,
                      height: 24,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.35,
                      child: _selectedLocation != null
                          ? Text(
                              'Store: ${_selectedLocation!.description}',
                              style: const TextStyle(color: Colors.black, fontSize: 13),
                            )
                          : const Text('No location selected.'),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.35,
                      child: const Text(
                        " Logout ",
                        // username,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        SharedService.logout(context);
                        //    SharedService.
                      },
                      icon: SvgPicture.asset(
                        'assets/icons/ic_log_out.svg',
                        // Replace with the path to your SVG icon
                        color: Colors.redAccent,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ),
              Container(
                  width: MediaQuery.of(context).size.width * 0.9, // Get the device width using MediaQuery

                  child: const Text("Beta 0.3", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12))),

              const CurrentDateTimeWidget(),
              Container(
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.white,
                  // Replace with the desired background color
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      // Replace 'Colors.grey' with the desired shadow color
                      spreadRadius: 2,
                      blurRadius: 4,
                      offset: const Offset(6, 5), // Offset of the shadow (x, y)
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // ProfileWidget(
                      //   name: username,
                      //   loginResponse: _loginResponse,
                      // ),
                      if (username.isEmpty || dataManagerProvider.loginResponse_DM!.data.userId.isEmpty)
                        SizedBox(
                            height: 120,
                            width: 200,
                            child: Center(
                              child: LoadingAnimationWidget.stretchedDots(
                                color: AppColors.cenmetrixBlue,
                                // secondRingColor: AppColors.cenmetrixOrange,
                                // thirdRingColor: AppColors.cenmetrixRed,
                                size: 150,
                              ),
                            )) // Show loading indicator
                      else
                        ProfileWidget(
                          name: username,
                          loginResponse: _loginResponse,
                        ),

                      //  visible: isGettingUserData(), // Show LoadingAnimationWidget when isLoading is true

                      // replacement: ProfileWidget(
                      //   name: username,
                      //   loginResponse: _loginResponse,
                      // ),
                      // ),
                      const SizedBox(
                        height: 10,
                      ),

                      Row(
                        children: [
                          const Spacer(),
                          if (!isProductDataLoaded || dataManagerProvider.products.isEmpty)
                            Container(
                                height: 100,
                                width: 100,
                                child: Center(
                                  child: LoadingAnimationWidget.threeArchedCircle(
                                    color: AppColors.cenmetrixBlue,
                                    // secondRingColor: AppColors.cenmetrixOrange,
                                    // thirdRingColor: AppColors.cenmetrixRed,
                                    size: 50,
                                  ),
                                )) // Show loading indicator
                          else
                            DashboardButtonWidget(
                              iconPath: 'assets/icons/ic_cart_add.svg',
                              iconColor: AppColors.teal700,
                              label: 'Sales',
                              color: const Color.fromARGB(255, 235, 235, 235),
                              textColor: AppColors.textColor2,
                              onPressed: navigateToSalesScreen,
                            ),
                          const Spacer(),
                          DashboardButtonWidget(
                            iconPath: 'assets/icons/ic_total_sales.svg',
                            iconColor: AppColors.textColor1,
                            label: 'History',
                            color: const Color.fromARGB(255, 235, 235, 235),
                            textColor: AppColors.textColor2,
                            onPressed: () {
                              navigateToSalesHistoryListScreen();
                              Fluttertoast.showToast(
                                msg: "Development in Progress...",
                                toastLength: Toast.LENGTH_SHORT, // Duration for which the toast should be displayed (SHORT or LONG)
                                gravity: ToastGravity.BOTTOM, // Location where the toast should appear (TOP, BOTTOM, CENTER)
                                timeInSecForIosWeb: 1, // Duration for iOS (in seconds)
                                backgroundColor: Colors.black54, // Background color of the toast
                                textColor: Colors.white, // Text color of the toast message
                                fontSize: 16.0, // Font size of the toast message
                              );
                              print(_loginResponse!.data.expires);

                              // Parse the string into a DateTime object
                              DateTime dateTime = DateTime.parse(_loginResponse!.data.expires);
                              // Convert to the system's local time zone
                              DateTime localDateTime = dateTime.toLocal();
                              DateTime now = DateTime.now();
                              DateTime utcNow = now.toUtc();
                              print(utcNow);
                            },
                          ),
                          const Spacer(),
                          DashboardButtonWidget(
                            iconPath: 'assets/icons/ic_attendance_history.png',
                            iconColor: AppColors.cenmetrixOrange,
                            label: 'Attendance',
                            color: const Color.fromARGB(255, 235, 235, 235),
                            textColor: AppColors.textColor2,
                            onPressed: navigateToAttendanceScreen,
                          ),
                          const Spacer(),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),

                      const Text("Targets",
                          textAlign: TextAlign.start, style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 15)),

                      TargetProgressCustomWidget(targetData: dataManagerProvider.repTargets.data
                          //targetData:sampleTargetData,

                          ),
                      // const Padding(
                      //   padding: EdgeInsets.all(0),
                      //   child: TargetsProgressWidget(
                      //       dailyProgress: 5,
                      //       monthlyProgress: 20,
                      //       quarterlyProgress: 30,
                      //       dailyTarget: 20,
                      //       dailyCompleted: 5,
                      //       monthlyTarget: 100,
                      //       monthlyCompleted: 50,
                      //       quarterlyTarget: 300,
                      //       quarterlyCompleted: 250),
                      // ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
