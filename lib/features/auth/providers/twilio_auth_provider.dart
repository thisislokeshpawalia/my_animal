import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import '../../../core/service/auth_service/twilio_auth_service.dart';

final dioProvider = Provider<Dio>((ref) {
  return Dio();
});

final twilioAuthServiceProvider =
Provider<TwilioAuthService>((ref) {
  final dio = ref.watch(dioProvider);

  return TwilioAuthService();
});

