import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:yaquby/servives/global_variables.dart';
import 'package:yaquby/views/screens/attendanceScreen.dart';
import 'package:yaquby/views/screens/choose_location.dart';
import 'package:yaquby/views/screens/home_screen.dart';
import 'package:yaquby/views/screens/sales_list_history_screen.dart';
import 'package:yaquby/views/screens/sales_screen.dart';
import 'providers/location_providers.dart';
import 'providers/login_detail_provider.dart';
import 'servives/shared_services.dart';
import 'servives/token_manager.dart';
import 'views/screens/login_screen.dart';

Widget _defaultHome = const LoginScreen();
DataManagerProvider dataManagerProvider = DataManagerProvider();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool _isLoggedIn = await SharedService.isLoggedIn();
  bool _isLocationSelected = await SharedService.isLocationSelected();

  print("Logged in - $_isLoggedIn");
  print("Location Selected - $_isLocationSelected");
  if (_isLoggedIn && _isLocationSelected) {
    _defaultHome = const HomeScreen();
  } else if (_isLoggedIn) {
    _defaultHome = const ChooseLocation();
  } else {
    _defaultHome = const LoginScreen(); // Add your login screen here
  }
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  //create: (_) => LocationProvider(),
  @override
  Widget build(BuildContext context) {
    TokenManager().setContext(context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LocationProvider>(
          create: (_) => LocationProvider(),
        ),
        ChangeNotifierProvider<LoginResponseProvider>(
          create: (_) => LoginResponseProvider(),
        ),
        ChangeNotifierProvider<DataManagerProvider>(
          create: (_) => dataManagerProvider,
        ),
      ],
      child: MaterialApp(
        title: 'Yaquby',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color(0xFF3BC1AC),
        ),
        routes: {
          '/': (context) => _defaultHome,
          // '/': (context) => const HomeScreen(), // for testing only
          '/home': (context) => const HomeScreen(),
          '/login': (context) => const LoginScreen(),
          '/choose_location': (context) => const ChooseLocation(),
          '/attendance': (context) => const AttendanceScreen(),
          '/sales': (context) => const SalesScreen(),
          '/sales_history_list': (context) => SalesListHistoryScreen(),
        },
      ),
    );
  }
}
