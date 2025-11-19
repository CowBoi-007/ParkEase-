import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'features/dashboard/dashboard_screen.dart';

Future<void> seedFakeSpots() async {
  final box = Hive.box('parkingBox');
  if (box.isEmpty) {
    for (int i = 1; i <= 50; i++) {
      final spotId = 'S$i';
      final spot = {
        'id': spotId,
        'name': 'Spot $i',
        'occupied': i % 3 == 0,
      };
      await box.put(spotId, spot);
    }
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('parkingBox');
  await seedFakeSpots();
  runApp(const ParkEaseAdminApp());
}

class ParkEaseAdminApp extends StatelessWidget {
  const ParkEaseAdminApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // DO NOT use `const` here for MaterialApp if any child widget (like DashboardScreen) is not a const constructor!
    return MaterialApp(
      title: 'ParkEase',
      debugShowCheckedModeBanner: false,
      home: DashboardScreen(), // <--- No const before DashboardScreen
    );
  }
}
