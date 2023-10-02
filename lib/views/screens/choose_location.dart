import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../../models/login_response_model.dart';
import '../../providers/location_providers.dart';
import '../../servives/shared_services.dart';
import '../../servives/token_manager.dart';

class ChooseLocation extends StatefulWidget {
  const ChooseLocation({Key? key}) : super(key: key);

  @override
  _ChooseLocationState createState() => _ChooseLocationState();
}

class _ChooseLocationState extends State<ChooseLocation> {
  LoginResponseModel? _loginResponse;
  late List<Userlocations> userlocations = [];
  late Userlocations userlocation = Userlocations(locationId: 0, description: '');

  @override
  void initState() {
    super.initState();
    getSavedData();
  }

  Future<void> getSavedData() async {
    _loginResponse = await SharedService.loginDetails();
    userlocations = _loginResponse!.data.userlocations;

    if (userlocations.length == 1) {
      await SharedService.setSelectedLocationToCasheData(userlocations[0]);
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, '/home');
    }

    setState(() {
      userlocation = userlocations[0];
      SharedService.setSelectedLocationToCasheData(userlocation);
      Provider.of<LocationProvider>(context, listen: false).setSelectedLocation(userlocation);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0, // Remove app bar shadow
        actions: [
          IconButton(
            onPressed: () {
              SharedService.logout(context);
            },
            icon: SvgPicture.asset(
              'assets/icons/ic_log_out.svg',
              // Replace with the path to your SVG icon
              color: Colors.redAccent,
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background Map-Like Container
          Container(
            color: Colors.transparent, // Background color resembling a map
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Choose Your Location',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  DropdownButton<Userlocations>(
                    value: userlocation,
                    onChanged: (newValue) {
                      setState(() {
                        userlocation = newValue!;
                        SharedService.setSelectedLocationToCasheData(newValue);
                      });
                      Provider.of<LocationProvider>(context, listen: false).setSelectedLocation(newValue!);
                    },
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black,
                    ),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    selectedItemBuilder: (BuildContext context) {
                      return userlocations.map<Widget>((Userlocations location) {
                        return Center(
                          child: Text(
                            location.description,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }).toList();
                    },
                    items: userlocations.map(
                      (location) {
                        return DropdownMenuItem<Userlocations>(
                          value: location,
                          child: Text(location.description),
                        );
                      },
                    ).toList(),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to the dashboard screen with the selected item data
                      if (userlocations.isEmpty) {
                        Fluttertoast.showToast(
                          msg: "No user location, Please add user location, login again",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                        SharedService.logout(context);
                      } else {
                        Navigator.pushReplacementNamed(context, '/home');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue, // Change the button color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 16,
                      ),
                    ),
                    child: const Text(
                      'Next',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
