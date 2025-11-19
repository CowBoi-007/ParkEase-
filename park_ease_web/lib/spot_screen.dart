import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;

class SpotScreen extends StatefulWidget {
  final String spotId;
  const SpotScreen({super.key, required this.spotId});

  @override
  State<SpotScreen> createState() => _SpotScreenState();
}

class _SpotScreenState extends State<SpotScreen> {
  static const String backendBase = 'https://effervescible-enthusiastically-armandina.ngrok-free.dev';
  bool isLoading = false;
  bool hasError = false;
  bool isAccepted = false;
  String statusMsg = "You are requesting assignment for:";

  Future<void> acceptSpot() async {
    setState(() {
      isLoading = true;
      hasError = false;
      statusMsg = "";
    });
    try {
      final res = await http.post(
        Uri.parse('$backendBase/api/spots/${widget.spotId}/assign'),
      );
      if (res.statusCode == 200) {
        setState(() {
          isAccepted = true;
          statusMsg = "Spot Accepted! Show this to the guard.";
        });
      } else {
        setState(() {
          hasError = true;
          statusMsg =
              "Request failed. Please try again. (${res.statusCode})";
        });
      }
    } catch (e) {
      setState(() {
        hasError = true;
        statusMsg = "Network error! Try again later.";
      });
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[900],
      body: Center(
        child: Container(
          width: 360,
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 15, spreadRadius: 1)],
            border: Border.all(color: Colors.green.shade800, width: 1.8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isLoading)
                Lottie.asset(
                  'assets/animations/loading.json',
                  width: 120,
                ),
              if (!isLoading && isAccepted)
                Lottie.asset(
                  'assets/animations/success.json',
                  width: 120,
                  repeat: false,
                ),
              if (!isLoading && hasError)
                Lottie.asset(
                  'assets/animations/error.json',
                  width: 120,
                  repeat: false,
                ),
              const SizedBox(height: 8),
              Text(
                statusMsg,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: hasError ? Colors.red : Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              if (!isAccepted && !isLoading)
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: Column(
                    children: [
                      Icon(Icons.directions_car_filled, color: Colors.green[800], size: 36),
                      const SizedBox(height: 6),
                      Text(
                        widget.spotId,
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[800]),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        icon: Icon(Icons.done),
                        label: Text('Accept Spot'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[800],
                          foregroundColor: Colors.white,
                          minimumSize: const Size(140, 42),
                        ),
                        onPressed: acceptSpot,
                      ),
                    ],
                  ),
                ),
              if (isAccepted)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    "Show this screen at entry.",
                    style: TextStyle(color: Colors.green[900], fontWeight: FontWeight.w500),
                  ),
                ),
              if (!isLoading && hasError)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: OutlinedButton.icon(
                    icon: Icon(Icons.refresh),
                    label: Text('Try Again'),
                    onPressed: acceptSpot,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
