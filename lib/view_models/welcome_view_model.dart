import 'package:flutter/foundation.dart';
import '../core/services/device_info_service.dart';
import '../core/helpers/shared_prefs_helper.dart';

class WelcomeViewModel extends ChangeNotifier {
  final SharedPrefsHelper _prefsHelper = SharedPrefsHelper();
  String? _deviceId;
  bool _isLoading = false;

  String? get deviceId => _deviceId;
  bool get isLoading => _isLoading;

  Future<void> initializeDeviceId() async {
    _isLoading = true;
    notifyListeners();

    try {
      _deviceId = await _prefsHelper.getDeviceId();

      if (_deviceId == null) {
        _deviceId = await DeviceInfoService.getDeviceId();
        await _prefsHelper.saveDeviceId(_deviceId!);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing device ID: $e');
      }
    }

    _isLoading = false;
    notifyListeners();
  }
}
