import 'package:flutter/foundation.dart';
import '../core/helpers/http_helper.dart';
import '../core/helpers/shared_prefs_helper.dart';
import '../models/session_model.dart';

class ShareCodeViewModel extends ChangeNotifier {
  final HttpHelper _httpHelper = HttpHelper();
  final SharedPrefsHelper _prefsHelper = SharedPrefsHelper();

  SessionModel? _session;
  bool _isLoading = false;
  String? _error;

  SessionModel? get session => _session;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> generateCode() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final deviceId = await _prefsHelper.getDeviceId();
      if (deviceId == null) {
        throw Exception('Device ID not found');
      }

      final response = await _httpHelper.startSession(deviceId);
      _session =
          SessionModel.fromJson({...response['data'], 'device_id': deviceId});
      await _prefsHelper.saveSessionId(_session!.sessionId!);
    } catch (e) {
      _error = 'Failed to generate code';
      if (kDebugMode) {
        print('Error generating code: $e');
      }
    }

    _isLoading = false;
    notifyListeners();
  }
}
