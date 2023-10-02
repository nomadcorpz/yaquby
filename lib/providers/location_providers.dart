import 'package:flutter/foundation.dart';
import '../models/login_response_model.dart';

class LocationProvider with ChangeNotifier {
  Userlocations? _selectedLocation;
  Userlocations? get selectedLocation => _selectedLocation;
  void setSelectedLocation(Userlocations location) {
    _selectedLocation = location;
    notifyListeners();
  }
}
