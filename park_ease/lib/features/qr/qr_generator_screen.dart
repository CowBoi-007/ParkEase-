import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../models/spot.dart';
import '../../services/api_services.dart';

class QRGeneratorScreen extends StatefulWidget {
  final Spot spot;
  final List<Spot> allSpots;

  const QRGeneratorScreen({Key? key, required this.spot, required this.allSpots}) : super(key: key);

  @override
  State<QRGeneratorScreen> createState() => _QRGeneratorScreenState();
}

class _QRGeneratorScreenState extends State<QRGeneratorScreen> {
  late int currentIndex;
  String assignMessage = '';

  @override
  void initState() {
    super.initState();
    currentIndex = widget.allSpots.indexWhere((s) => s.id == widget.spot.id);
    if (currentIndex < 0) currentIndex = 0; // fallback to first spot
  }

  Future<void> handleAssign() async {
    final spot = widget.allSpots[currentIndex];
    bool ok = await ApiService.assignSpot(spot.id);
    if (!mounted) return;
    setState(() {
      assignMessage = ok ? 'Assigned!' : 'Failed to assign';
    });
  }

  void handleNext() {
    setState(() {
      currentIndex = (currentIndex + 1) % widget.allSpots.length;
      assignMessage = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    // Replace with your frontend ngrok URL as needed
    const String baseUrl = 'https://psilotic-notal-amira.ngrok-free.dev';
    final spot = widget.allSpots[currentIndex];
    final String qrData = '$baseUrl/?id=${spot.id}';

    return Scaffold(
      appBar: AppBar(title: Text('QR for ${spot.name}')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            QrImageView(
              data: qrData,
              version: QrVersions.auto,
              size: 230,
            ),
            const SizedBox(height: 12),
            Text(qrData, style: const TextStyle(fontSize: 13, color: Colors.grey)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: handleAssign,
                  child: const Text('Assign'),
                ),
                const SizedBox(width: 24),
                ElevatedButton(
                  onPressed: handleNext,
                  child: const Text('Next Spot'),
                ),
              ],
            ),
            if (assignMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  assignMessage,
                  style: TextStyle(
                    color: assignMessage == 'Assigned!' ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
