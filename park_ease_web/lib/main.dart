import 'package:flutter/material.dart';
import 'spot_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final spotId = Uri.base.queryParameters['id'];
  runApp(ParkEaseWebApp(spotId: spotId));
}

class ParkEaseWebApp extends StatelessWidget {
  final String? spotId;
  const ParkEaseWebApp({super.key, required this.spotId});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ParkEase Web',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: const Color(0xFFF4F7FA),
        fontFamily: 'Roboto',
        snackBarTheme: SnackBarThemeData(
          backgroundColor: Colors.green.shade100,
          actionTextColor: Colors.green[900],
          contentTextStyle: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      home: (spotId == null || spotId!.isEmpty)
          ? const Scaffold(
              body: Center(
                child: Text(
                  'No spot ID provided.\nScan a valid QR!',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : SpotScreen(spotId: spotId!),
    );
  }
}
