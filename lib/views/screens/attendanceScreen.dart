import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:yaquby/models/attendance_request_model.dart';
import 'package:yaquby/servives/api_services.dart';
import 'package:yaquby/servives/shared_services.dart';
import 'package:yaquby/servives/token_manager.dart';
import '../../config.dart';
import '../../models/attendance_response_model.dart';
import '../../models/login_response_model.dart';
import '../customWidgets/CurrentTimeAndDateWidget.dart';
import '../customWidgets/DashboardButtonWidget.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({Key? key}) : super(key: key);

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  late Future<AttendanceResponseModel>? attendanceFuture;

  LoginResponseModel? _loginResponse;
  AttendanceRequestModel? _attendanceRequestModel;

  late String userid = "1";
  Userlocations? _selectedLocation;
  double? latitude;
  double? longitude;
  bool geoLoading = true;

  @override
  void initState() {
    super.initState();
    setUpDate();
    getCurrentLocation();
    getSavedData();
    getSavedDataAttendance();

    TokenManager().setContext(context);
    print(TokenManager().expirationTime);
    DateTime now = DateTime.now();
    DateTime utcNow = now.toUtc();
    print(utcNow);
    attendanceFuture = null;
  }

  Future<void> getSavedData() async {
    _loginResponse = await SharedService.loginDetails();
    _selectedLocation = await SharedService.getSelectedUserLocation();
    setState(() {
      userid = _loginResponse!.data.userId;
      attendanceFuture = APIService.getAttendanceDetails(userid, startDate, endDate);
    });
  }

  var model;
  bool current_in = true;
  bool current_out = true;

  Future<void> getSavedDataAttendance() async {
    _attendanceRequestModel = await SharedService.getPostedAttendance();

    if (_attendanceRequestModel != null) {
      setState(() {
        current_in = _attendanceRequestModel!.checkInTime as bool;
        current_out = _attendanceRequestModel!.checkOutTime as bool;
        model = _attendanceRequestModel;
      });
    } else {
      setState(() {
        current_in = false;
        current_out = false;
      });
    }
  }

  Future<void> setCheckIn() async {
    DateTime currentDate = DateTime.now();
    // DateTime formattedDate = DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'").format(currentDate.toUtc());
    model = AttendanceRequestModel(
      date: currentDate,
      checkInTime: currentDate,
      checkOutTime: null,
      employeeId: userid,
      locationId: _selectedLocation!.locationId,
      deviceMAC: "Config.Mac_Address",
      deviceDateTime: currentDate,
      latitude: latitude,
      longitude: longitude,
    );
    SharedService.setPostedAttendance(model);
  }

  Future<void> setCheckOut() async {
    DateTime currentDate = DateTime.now();
    String formattedDate = DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'").format(currentDate.toUtc());
    model = AttendanceRequestModel(
      date: currentDate,
      checkInTime: _attendanceRequestModel?.checkInTime,
      checkOutTime: currentDate,
      employeeId: userid,
      locationId: _selectedLocation!.locationId,
      deviceMAC: "Config.Mac_Address",
      deviceDateTime: currentDate,
      latitude: latitude,
      longitude: longitude,
    );
    SharedService.setPostedAttendance(model);
  }

// Get the latitude and longitude
  void getCurrentLocation() async {
    try {
      // Request permission to access location
      bool serviceEnabled;
      LocationPermission permission;
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Location services are not enabled
        return;
      }
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        return;
      }
      if (permission == LocationPermission.denied) {
        // Request permission to access location
        permission = await Geolocator.requestPermission();
        if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
          // Permissions are denied, handle appropriately.
          return;
        }
      }
      // Get the current position
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      // Get the latitude and longitude
      latitude = position.latitude;
      longitude = position.longitude;
      // Get the city name or address
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude!, longitude!);
      Placemark currentPlace = placemarks[0];
      String? cityName = currentPlace.locality;
      String? address = currentPlace.street;
      String? subcity = currentPlace.postalCode;
      print('Latitude: $latitude');
      print('Longitude: $longitude');
      print('City: $cityName');
      print('Address: $address');
      print('Subcity: $subcity');
    } catch (e) {
      print('Error: $e');
    }
  }

  setUpDate() {
    DateTime now = DateTime.now();
    endDate = DateFormat('yyyy-MM-dd').format(now);
    startDate = DateFormat('yyyy-MM-dd').format(now.subtract(const Duration(days: 30)));
  }

  DateTime? selectedDate;

  String endDate = '';
  String startDate = '';

  /// The method for [DateRangePickerSelectionChanged] callback, which will be
  /// called whenever a selection changed on the date picker widget.
  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        startDate = DateFormat('yyyy-MM-dd').format(args.value.startDate);
        endDate = DateFormat('yyyy-MM-dd').format(args.value.endDate ?? args.value.startDate);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        title: const Text('Attendance', style: TextStyle(color: AppColors.white)),
        backgroundColor: AppColors.cenmetrixBlue,
        leading: IconButton(
          icon: Image.asset(
            'assets/images/ic_back_white.png',
            color: AppColors.white, // Set the desired color here
            height: 25,
          ),
          onPressed: () {
            // Handle the back button press
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<AttendanceResponseModel>(
          future: attendanceFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<DataRow> dataRows = [];

              for (var data in snapshot.data!.data) {
                var dateFormatter = DateFormat('yyyy-MM-dd');
                var timeFormatter = DateFormat('hh:mm a');
                var date = data.date;
                var checkInTime = data.checkInTime;
                var checkOutTime = data.checkOutTime ?? '';

                var dateCell = DataCell(Text(date.isNotEmpty ? dateFormatter.format(DateTime.parse(date)) : ''));
                var checkInCell = DataCell(Text(checkInTime.isNotEmpty ? timeFormatter.format(DateTime.parse(checkInTime)) : ''));
                var checkOutCell = DataCell(Text(checkOutTime.isNotEmpty ? timeFormatter.format(DateTime.parse(checkOutTime)) : ''));

                print('----- ${data.checkOutTime}');

                var dataRow = DataRow(cells: [dateCell, checkInCell, checkOutCell]);
                dataRows.add(dataRow);
              }

              DataTable dataTable = DataTable(
                columns: const [
                  DataColumn(label: Text('Date')),
                  DataColumn(label: Text('Check-In')),
                  DataColumn(label: Text('Check-Out')),
                ],
                rows: dataRows.reversed.toList(),
              );

              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Spacer(),
                      Column(
                        children: [
                          const SizedBox(height: 20),
                          const Text(
                            '',
                            style: TextStyle(fontSize: 18),
                          ),
                          Visibility(
                            // ignore: unrelated_type_equality_checks
                            visible: _attendanceRequestModel?.checkInTime == true,
                            //      visible: _attendanceRequestModel!.checkInTime.isNotEmpty,
                            child: Text(
                              _attendanceRequestModel != null ? DateFormat.Hm().format(_attendanceRequestModel!.checkInTime ?? DateTime.now()) : '',
                            ),
                          ),
                          Visibility(
                            visible: !current_in,
                            child: DashboardButtonWidget(
                              iconPath: 'assets/icons/ic_blank_in.png',
                              iconColor: AppColors.colorGreen,
                              label: 'In',
                              color: const Color.fromARGB(255, 235, 235, 235),
                              textColor: AppColors.textColor2,
                              onPressed: () async {
                                await setCheckIn(); // Make sure to call setCheckIn as an asynchronous function
                                await APIService.currentInAndOut(model);
                                getSavedData();
                                print("$model");
                                setState(() {
                                  current_in = !current_in;
                                });
                              },
                            ),
                          ),
                          Visibility(
                            visible: current_in,
                            child: const DashboardButtonWidget(
                              iconPath: 'assets/icons/ic_fill_in.png',
                              iconColor: AppColors.colorGreen,
                              label: 'In',
                              color: Color.fromARGB(255, 255, 255, 255),
                              textColor: AppColors.textColor2,
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            '',
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Image.asset(
                        'assets/images/vertical_bg_line.png',
                        height: 150,
                      ),
                      const Spacer(),
                      Column(
                        children: [
                          const SizedBox(height: 20),
                          const Text(
                            '',
                            style: TextStyle(fontSize: 18),
                          ),
                          DashboardButtonWidget(
                            iconPath: 'assets/icons/ic_blank_out.png',
                            iconColor: AppColors.colorGreen,
                            label: 'Out',
                            color: const Color.fromARGB(255, 235, 235, 235),
                            textColor: AppColors.textColor2,
                            onPressed: () async {
                              await setCheckOut(); // Make sure to call setCheckIn as an asynchronous function
                              await APIService.currentInAndOut(model);
                              print("$model");
                              getSavedData();
                              setState(() {
                                current_in = !current_in;
                              });
                            },
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            '',
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                      const Spacer(),
                    ],
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width, // Set the desired width
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const CurrentDateTimeWidget(),
                        const SizedBox(height: 2),
                        Container(
                          color: AppColors.cenmetrixBlue,
                          child: const Center(
                            child: Text(
                              'Attendance History',
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.white),
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          color: AppColors.colorWhite,
                          child: Center(
                            child: Text.rich(
                              TextSpan(
                                text: 'Date Range from: ',
                                style: const TextStyle(color: Colors.black),
                                children: [
                                  TextSpan(
                                    text: startDate,
                                    style: const TextStyle(color: AppColors.cenmetrixOrange, fontWeight: FontWeight.bold),
                                  ),
                                  const TextSpan(
                                    text: ' to ',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  TextSpan(
                                    text: endDate,
                                    style: const TextStyle(color: AppColors.cenmetrixOrange, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: !showDatePicker,
                          child: Center(
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                    if (states.contains(MaterialState.pressed)) {
                                      return Colors.blue;
                                    }
                                    return AppColors.cenmetrixBlue;
                                  },
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  showDatePicker = !showDatePicker;
                                });
                              },
                              child: const Text("Select Date Range"),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: showDatePicker,
                          child: Column(
                            children: [
                              ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                                      if (states.contains(MaterialState.pressed)) {
                                        return Colors.blue;
                                      }
                                      return AppColors.colorRed;
                                    },
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    attendanceFuture = APIService.getAttendanceDetails(userid, startDate, endDate);
                                    showDatePicker = !showDatePicker;
                                  });
                                },
                                child: const Text("Apply"),
                              ),
                              SfDateRangePicker(
                                onSelectionChanged: _onSelectionChanged,
                                selectionMode: DateRangePickerSelectionMode.range,
                                maxDate: DateTime.now(),
                                backgroundColor: Colors.white,
                                initialSelectedRange: PickerDateRange(
                                  DateTime.now().subtract(const Duration(days: 30)),
                                  DateTime.now().add(const Duration(days: 0)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  dataTable,
                ],
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }

  bool showDatePicker = false;
}
