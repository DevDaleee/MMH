import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mmh/providers/user_provider.dart';
import 'package:mmh/routes.dart';
import 'package:mmh/screens/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mmh/screens/root.dart';
import 'package:provider/provider.dart';
import 'services/firebase_options.dart';

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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: UserProvider()),
      ],
      child: MaterialApp(
        title: 'Minecraft Mistery Hunt',
        theme: ThemeData(
          fontFamily: 'Jua',
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
          scaffoldBackgroundColor: const Color(0xFF324E3F),
          useMaterial3: true,
        ),
        routes: routes,
        home: const RoteadorTela(),
      ),
    );
  }
}

class GoogleFonts {}

class RoteadorTela extends StatelessWidget {
  const RoteadorTela({Key? key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.userChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const Root();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
