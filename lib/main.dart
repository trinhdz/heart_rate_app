import 'package:heart_rate_app/firebase/heart_rate_provider.dart';
import 'package:heart_rate_app/screens/background.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:heart_rate_app/widgets/heart_predict_provider.dart';
import 'package:heart_rate_app/widgets/notification_service.dart';
import 'package:heart_rate_app/widgets/userinfo_provider.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PersonProvider()),
        ChangeNotifierProxyProvider<PersonProvider, HeartRateProvider>(
          create: (context) => HeartRateProvider(
            personProvider: Provider.of<PersonProvider>(context, listen: false),
          ),
          update: (context, personProvider, heartProvider) =>
              HeartRateProvider(personProvider: personProvider),
        ),
        ChangeNotifierProvider(create: (_) => HeartPredictProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const Background(),
      ),
    );
  }
}
