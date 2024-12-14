import 'package:flutter/foundation.dart';
import '../core/helpers/http_helper.dart';
import '../core/helpers/shared_prefs_helper.dart';
import '../models/session_model.dart';

class EnterCodeViewModel extends ChangeNotifier {
  final HttpHelper _httpHelper = HttpHelper();
  final SharedPrefsHelper _prefsHelper = SharedPrefsHelper();

  bool _isLoading = false;
  String? _error;
  SessionModel? _session;

  bool get isLoading => _isLoading;
  String? get error => _error;
  SessionModel? get session => _session;

  Future<bool> joinSession(String code) async {
    if (code.length != 4) {
      _error = 'Please enter a 4-digit code';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final deviceId = await _prefsHelper.getDeviceId();
      if (deviceId == null) {
        throw Exception('Device ID not found');
      }

      final response = await _httpHelper.joinSession(deviceId, code);
      _session =
          SessionModel.fromJson({...response['data'], 'device_id': deviceId});
      await _prefsHelper.saveSessionId(_session!.sessionId!);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Invalid code or connection error';
      if (kDebugMode) {
        print('Error joining session: $e');
      }
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
