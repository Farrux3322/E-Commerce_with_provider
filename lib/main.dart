import 'package:e_commerce/constanst/theme.dart';
import 'package:e_commerce/firebase_helper/firebase_auth_helper/firebase_auth_helper.dart';
import 'package:e_commerce/screens/auth_ui/welcome/welcome.dart';
import 'package:e_commerce/services/fcm.dart';
import 'package:e_commerce/services/local_notification_service.dart';
import 'package:e_commerce/services/news_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'provider/app_provider.dart';
import 'screens/custom_bottom_bar/custom_bottom_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initFirebase();
  await LocalNotificationService.instance.setupFlutterNotifications();
  // Stripe.publishableKey =
  // "pk_test_51MWx8OAVMyklfe3CsjEzA1CiiY0XBTlHYbZ8jQlGtVFIwQi4aNeGv8J1HUw4rgSavMTLzTwgn0XRlwoTVRFXyu2h00mRUeWmAf123";
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseConfig.platformOptions,
  // );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'E-Commerce',
        theme: themeData,
        home: NewsScreen()
        // StreamBuilder(
        //   stream: FirebaseAuthHelper.instance.getAuthChange,
        //   builder: (context, snapshot) {
        //     if (snapshot.hasData) {
        //       return const CustomBottomBar();
        //     }
        //     return const Welcome();
        //   },
        // ),
      ),
    );
  }
}
