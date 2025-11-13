import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SpotScreen extends StatefulWidget {
  final String spotId;
  const SpotScreen({super.key, required this.spotId});
  @override
  State<SpotScreen> createState() => _SpotScreenState();
}

class _SpotScreenState extends State<SpotScreen> {
  String assignMsg = "Loading...";

  static const String backendBase = 'https://effervescible-enthusiastically-armandina.ngrok-free.dev';

  @override
  void initState() {
    super.initState();
    _assignSpot();
  }

  Future<void> _assignSpot() async {
    try {
      final res = await http.post(
        Uri.parse('$backendBase/api/spots/${widget.spotId}/assign'),
      );
      setState(() {
        assignMsg = "Spot Assigned - ${widget.spotId}";
      });
    } catch (e) {
      setState(() {
        assignMsg = "Error! Could not assign.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[900],
      body: Center(
        child: Container(
          width: 340,
          padding: const EdgeInsets.symmetric(vertical: 38, horizontal: 18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 12, spreadRadius: 1)],
            border: Border.all(color: Colors.green.shade800, width: 1.8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.directions_car_filled,
                  color: Colors.green[800], size: 48),
              const SizedBox(height: 18),
              Text(
                assignMsg,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 18),
              Text(
                'Show this screen at entry/exit',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.green.shade800,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
