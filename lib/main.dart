import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mmh/src/app_widget.dart';
import 'src/services/firebase_options.dart';

const kWebRecaptchaSiteKey = 'f702b7a3-681e-45cc-8f52-5d218a340586';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.appAttest,
    webProvider: ReCaptchaV3Provider(kWebRecaptchaSiteKey),
  );
  runApp(const MyApp());
}
