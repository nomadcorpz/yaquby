import 'package:flutter/material.dart';

import '../models/login_response_model.dart';

class LoginResponseProvider with ChangeNotifier{
  LoginResponseModel? _loginDetails;
  LoginResponseModel? get selectedLocation => _loginDetails;
  void setLoginDataProvider(LoginResponseModel loginResponseModelDetail) {
    _loginDetails = loginResponseModelDetail;
    notifyListeners();
  }
}
