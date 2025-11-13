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
  int currentIndex = 0;
  String assignMessage = '';

  @override
  void initState() {
    super.initState();
    currentIndex = widget.allSpots.indexWhere((s) => s.id == widget.spot.id);
  }

  void handleAssign() async {
    final spot = widget.allSpots[currentIndex];
    bool ok = await ApiService.assignSpot(spot.id);
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
    // <-- Replace with your ngrok frontend URL here
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
            Text(qrData),
            const SizedBox(height: 12),
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
            if (assignMessage.isNotEmpty) Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(assignMessage),
            ),
          ],
        ),
      ),
    );
  }
}
