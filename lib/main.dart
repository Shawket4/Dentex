// ignore_for_file: unused_local_variable, non_constant_identifier_names, constant_identifier_names, unused_import
import 'package:dentex/components/bottom_nav_bar.dart';
import 'package:dentex/dio_helper.dart';
import 'package:dentex/models/user.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:dentex/screens/home_screen.dart';
import 'package:dentex/screens/login_screen.dart';
import 'package:dio/dio.dart';
import 'package:material_color_generator/material_color_generator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}

const String ServerIP = "http://144.126.234.206:5505";
// const String ServerIP = "http://localhost:5505";

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {});
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MainWidget());
}

final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
late String jwt;
User userInfo = User();
Future<String> get _getJwt async {
  final SharedPreferences prefs = await _prefs;
  // await prefs.remove("jwt");
  jwt = (prefs.getString('jwt') ?? "");
  dio.options.headers["Authorization"] = "Bearer $jwt";
  try {
    var checkValidity = await dio.get("$ServerIP/api/protected/user");
  } catch (e) {
    Logout;
    jwt = "";
    return jwt;
  }
  return jwt;
}

Future<bool> SetJwt(String jwt) async {
  final SharedPreferences prefs = await _prefs;
  final bool status = await (prefs.setString('jwt', jwt));
  return status;
}

Dio dio = Dio();

Future<bool> get Logout async {
  await FirebaseMessaging.instance.getToken().then((token) async {
    await postData("$ServerIP/api/protected/UnlinkDeviceToken", {
      "token": token,
    });
  });

  final SharedPreferences prefs = await _prefs;
  return await prefs.remove("jwt");
}

class MainWidget extends StatefulWidget {
  const MainWidget({Key? key}) : super(key: key);
  @override
  State<MainWidget> createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Dentex - Clinic Management",
      theme: ThemeData(
        fontFamily: "Inter",
        primaryColor: const Color(0xFF0b132b),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xFF0b132b),
          secondary: const Color(0xFF011627),
        ),
        primarySwatch: generateMaterialColor(
          color: const Color(0xFF0b132b),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
          future: _getJwt,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Scaffold(
                body: Center(
                  child: Lottie.asset(
                    "assets/lottie/Loading.json",
                    height: 200,
                    width: 200,
                  ),
                ),
              );
            } else {
              if (jwt != "") {
                return const HomeScreen();
              } else {
                return const LoginPage();
              }
            }
          }),
    );
  }
}
