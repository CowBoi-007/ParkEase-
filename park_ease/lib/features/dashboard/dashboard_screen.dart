import 'package:flutter/material.dart';
import '../../models/spot.dart';
import '../../services/api_services.dart';
import '../qr/qr_generator_screen.dart';
import '../spots/spots_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int totalSpots = 0;
  int occupiedSpots = 0;
  int availableSpots = 0;
  bool isLoading = true;
  List<Spot> latestSpots = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() => isLoading = true);
    try {
      final spots = await ApiService.fetchAllSpots();
      if (!mounted) return;
      setState(() {
        latestSpots = spots;
        totalSpots = spots.length;
        occupiedSpots = spots.where((e) => e.occupied).length;
        availableSpots = totalSpots - occupiedSpots;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error loading data!')),
      );
    }
  }

  void showNextAvailableSpotQR() async {
    final spots = await ApiService.fetchAllSpots();
    Spot? nextSpot;
    for (final spot in spots) {
      if (!spot.occupied) {
        nextSpot = spot;
        break;
      }
    }
    if (nextSpot != null) {
      if (!mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(
          // Pass both spot and full list!
          builder: (_) => QRGeneratorScreen(spot: nextSpot!, allSpots: spots),
        ),
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No free spots available!')),
      );
    }
  }

  Future<void> openSpotsScreen() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const SpotsScreen()),
    );
    if (result == true && mounted) loadData();
  }

  Widget buildStatCard({
    required String title,
    required int value,
    required Color color,
    required IconData icon,
  }) {
    return Card(
      elevation: 8,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 290,
        padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 34),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              value.toString(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 46,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.local_parking, color: Colors.indigo.shade700, size: 32),
            const SizedBox(width: 10),
            const Text('ParkEase Dashboard', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.indigo.shade700,
        elevation: 2,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Parking Lot Overview",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 26,
                          letterSpacing: 0.5,
                          color: Colors.indigo,
                        ),
                      ),
                      const SizedBox(height: 26),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        alignment: WrapAlignment.center,
                        children: [
                          buildStatCard(
                            title: "Total Spots",
                            value: totalSpots,
                            color: Colors.blue.shade700,
                            icon: Icons.dashboard,
                          ),
                          buildStatCard(
                            title: "Occupied Spots",
                            value: occupiedSpots,
                            color: Colors.red.shade700,
                            icon: Icons.event_busy,
                          ),
                          buildStatCard(
                            title: "Available Spots",
                            value: availableSpots,
                            color: Colors.green.shade700,
                            icon: Icons.event_available,
                          ),
                        ],
                      ),
                      const SizedBox(height: 36),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.qr_code_scanner, size: 22),
                        label: const Text(
                          'Assign Next Vehicle & Show QR',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(300, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 3,
                        ),
                        onPressed: showNextAvailableSpotQR,
                      ),
                      const SizedBox(height: 14),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.list_alt, size: 20),
                        label: const Text(
                          'View All Spots',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade300,
                          foregroundColor: Colors.black87,
                          minimumSize: const Size(300, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                        onPressed: openSpotsScreen,
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
