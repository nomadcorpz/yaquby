import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';
import '../../config.dart';
import '../../models/login_request_model.dart';
import '../../servives/api_services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isAPIcallProcess = false;
  bool hidePassword = true;

  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  String? username;
  String? password;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: AppColors.white,
      body: ProgressHUD(
        key: UniqueKey(),
        inAsyncCall: isAPIcallProcess,
        child: Form(
          key: globalFormKey,
          child: _loginUI(context),
        ),
      ),
    ));
  }

//  'assets/images/yaquby_logo.png',
  Widget _loginUI(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/dashboard_background.png'), // Replace with the path to your background image
          fit: BoxFit.fill,
        ),
      ),
      height: MediaQuery.of(context).size.height, // Set a specific height or use a percentage of the available height

      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Flexible(
              child: Image.asset(
                'assets/images/yaquby_logo.png',
                width: 200.0,
                height: 150.0,
              ),
            ),
            const Spacer(),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: FormHelper.inputFieldWidget(
                  context,
                  "username",
                  "username / email",
                  (onValidateVal) {
                    if (onValidateVal.isEmpty) {
                      return "Username can\'t be empty";
                    }
                  },
                  (onSavedVal) {
                    username = onSavedVal;
                  },
                // initialValue: "amila@cenmetrix.lk",
                  initialValue:  "yassar@yaquby.com",
                  hintColor: Colors.grey,
                  borderFocusColor: AppColors.cenmetrixOrange,
                  prefixIconColor: AppColors.cenmetrixOrange,
                  borderColor: AppColors.cenmetrixBlue,
                  borderRadius: 10,
                  paddingLeft: 10,
                  paddingRight: 10,
                  suffixIcon: Icon(Icons.person),
                ) // Text('FormHelper'),
                ),
            const SizedBox(
              height: 20,
            ),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: FormHelper.inputFieldWidget(
                  context,
                  "password",
                  "Password",
                  (onValidateVal) {
                    if (onValidateVal.isEmpty) {
                      return "Password can\'t be empty";
                    }
                  },
                  (onSavedVal) {
                    password = onSavedVal;
                  },
                //  initialValue: "Cenmetrix@123",
                  initialValue: "Yaquby#1",
                  obscureText: hidePassword,
                  hintColor: Colors.grey,
                  borderFocusColor: AppColors.cenmetrixOrange,
                  prefixIconColor: AppColors.cenmetrixOrange,
                  borderColor: AppColors.cenmetrixBlue,
                  borderRadius: 10,
                  paddingLeft: 10,
                  paddingRight: 10,
                  suffixIcon: IconButton(
                    icon: Icon(
                      hidePassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        hidePassword = !hidePassword; // Toggle password visibility
                      });
                    },
                  ),
                ) // Text('FormHelper'),
                ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: FormHelper.submitButton("Login", () {
                if (validateAndSave()) {
                  setState(() {
                    isAPIcallProcess = true;
                  });

                  LoginRequestModel model = LoginRequestModel(
                    username: username!,
                    password: password!,
                  );

                  APIService.login(model).then((response) {
                    setState(() {
                      isAPIcallProcess = false;
                    });
                    if (response) {
                      print("response");

                      print(response);

                      Navigator.pushNamedAndRemoveUntil(context, '/choose_location', (route) => false);
                    } else {
                      FormHelper.showSimpleAlertDialog(
                        context,
                        Config.appName,
                        "Invalid Username/Password !",
                        "OK",
                        () {
                          Navigator.pop(context);
                        },
                      );
                    }
                  });
                }
              }, btnColor: AppColors.cenmetrixOrange, borderColor: AppColors.cenmetrixOrange),
            ),
            const Spacer(),
            Image.asset(
              'assets/images/logo_cenmetrix.png',
              width: MediaQuery.of(context).size.width,
            ),
          ],
        ),
      ),
    );
  }

  bool validateAndSave() {
    final form = globalFormKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }
}
