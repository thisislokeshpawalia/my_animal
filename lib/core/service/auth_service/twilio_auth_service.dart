import 'dart:convert';

import 'package:dio/dio.dart';

class TwilioAuthService {

  final Dio _dio = Dio();

  // ⚠️ TESTING ONLY
  // NEVER expose these credentials in production.
  static const String accountSid = 'YOUR_TWILIO_ACCOUNT_SID';
  static const String authToken = 'YOUR_TWILIO_AUTH_TOKEN';
  static const String verifyServiceSid = 'YOUR_TWILIO_VERIFY_SERVICE_SID';

  String get _basicAuth {
    return base64Encode(
      utf8.encode('$accountSid:$authToken'),
    );
  }

  Future<void> sendOtp({
    required String phoneNumber,
  }) async {
    try {
      final response = await _dio.post(
        'https://verify.twilio.com/v2/Services/'
            '$verifyServiceSid/Verifications',
        data: {
          'To': phoneNumber,
          'Channel': 'sms',
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            'Authorization': 'Basic $_basicAuth',
          },
        ),
      );

      if (response.statusCode == 200 ||
          response.statusCode == 201) {
        return;
      }

      throw Exception('Failed to send OTP');
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ??
            'Failed to send OTP',
      );
    }
  }

  Future<bool> verifyOtp({
    required String phoneNumber,
    required String otp,
  }) async {
    try {
      final response = await _dio.post(
        'https://verify.twilio.com/v2/Services/'
            '$verifyServiceSid/VerificationCheck',
        data: {
          'To': phoneNumber,
          'Code': otp,
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            'Authorization': 'Basic $_basicAuth',
          },
        ),
      );

      return response.data['status'] == 'approved';
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ??
            'OTP verification failed',
      );
    }
  }
}