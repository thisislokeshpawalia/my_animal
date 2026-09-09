import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import 'app/app.dart';
import 'core/service/invoice/invoice_service.dart';
import 'core/service/notification/local_notification_service.dart';
import 'firebase_options.dart';


void main() async {

  WidgetsFlutterBinding.ensureInitialized();


  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseAnalytics.instance;
  
  await LocalNotificationService.initialize();

  runApp(
    const ProviderScope(
      child: MyAnimalApp(),
    ),
  );
}