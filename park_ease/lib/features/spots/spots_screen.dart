import 'package:flutter/material.dart';
import '../../models/spot.dart';
import '../../services/api_services.dart';
import '../qr/qr_generator_screen.dart';

class SpotsScreen extends StatefulWidget {
  const SpotsScreen({Key? key}) : super(key: key);

  @override
  State<SpotsScreen> createState() => _SpotsScreenState();
}

class _SpotsScreenState extends State<SpotsScreen> {
  List<Spot> spots = [];
  List<Spot> filteredSpots = [];
  TextEditingController searchController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadSpots();
    searchController.addListener(_searchSpots);
  }

  Future<void> loadSpots() async {
    setState(() => isLoading = true);
    spots = await ApiService.fetchAllSpots();
    filteredSpots = spots;
    setState(() => isLoading = false);
  }

  void _searchSpots() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredSpots = spots.where((spot) =>
          spot.name.toLowerCase().contains(query) ||
          spot.id.toLowerCase().contains(query)).toList();
    });
  }

  void generateQR(Spot spot) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => QRGeneratorScreen(spot: spot, allSpots: spots),
      ),
    );
    loadSpots();
  }

  void assignSpot(Spot spot) async {
    await ApiService.assignSpot(spot.id);
    loadSpots();
  }

  void freeSpot(Spot spot) async {
    await ApiService.freeSpot(spot.id);
    loadSpots();
  }

  @override
  void dispose() {
    searchController.removeListener(_searchSpots);
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parking Spots'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search spots...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: loadSpots,
              child: ListView.builder(
                itemCount: filteredSpots.length,
                itemBuilder: (context, index) {
                  final spot = filteredSpots[index];
                  return Card(
                    color: spot.occupied ? Colors.red[100] : Colors.green[100],
                    child: ListTile(
                      title: Text('${spot.name} (${spot.id})'),
                      subtitle: Text(spot.occupied ? 'Occupied' : 'Available'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.qr_code),
                            onPressed: () => generateQR(spot),
                          ),
                          ElevatedButton(
                            onPressed: spot.occupied ? null : () => assignSpot(spot),
                            child: const Text('Assign'),
                          ),
                          const SizedBox(width: 6),
                          ElevatedButton(
                            onPressed: spot.occupied ? () => freeSpot(spot) : null,
                            child: const Text('Unassign'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
