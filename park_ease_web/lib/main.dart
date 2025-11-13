import 'package:flutter/material.dart';
import 'spot_screen.dart';

// Entry point for ParkEase web app
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Grab spot id from the query: .../?id=S1 (case-sensitive)
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
      theme: ThemeData(primarySwatch: Colors.indigo),
      // Home: Show error if id is missing, otherwise load ticket screen
      home: (spotId == null || spotId!.isEmpty)
          ? const Scaffold(
              body: Center(
                child: Text(
                  'No spot ID provided. Scan a valid QR!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            )
          : SpotScreen(spotId: spotId!),
    );
  }
}
