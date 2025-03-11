import 'package:flutter/material.dart';
import 'package:sim_data_new/sim_data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sim Data Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const SimDataScreen(),
    );
  }
}

class SimDataScreen extends StatefulWidget {
  const SimDataScreen({Key? key}) : super(key: key);

  @override
  State<SimDataScreen> createState() => _SimDataScreenState();
}

class _SimDataScreenState extends State<SimDataScreen> {
  Future<SimData>? _simDataFuture;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadSimData();
  }

  Future<void> _loadSimData() async {
    setState(() {
      _errorMessage = null;
      _simDataFuture = SimDataPlugin.getSimData();
    });

    try {
      await _simDataFuture;
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sim Data Demo'),
      ),
      body: FutureBuilder<SimData>(
        future: _simDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (_errorMessage != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Erreur: $_errorMessage',
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadSimData,
                      child: const Text('Réessayer'),
                    ),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasData) {
            final simData = snapshot.data!;

            if (simData.cards.isEmpty) {
              return const Center(
                child: Text(
                  'Aucune carte SIM détectée ou permissions refusées',
                  textAlign: TextAlign.center,
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: simData.cards.length,
              itemBuilder: (context, index) {
                final card = simData.cards[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'SIM ${index + 1}: ${card.displayName}',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const Divider(),
                        _buildInfoRow('Opérateur', card.carrierName),
                        _buildInfoRow('subscriptionId', card.subscriptionId.toString()),
                        _buildInfoRow('Numéro', card.phoneNumber),
                        _buildInfoRow('Pays', card.countryCode),
                        _buildInfoRow('MCC+MNC', '${card.mcc}-${card.mnc}'),
                        _buildInfoRow('Slot', '${card.slotIndex}'),
                        _buildInfoRow('Roaming données', card.isDataRoaming ? 'Oui' : 'Non'),
                        _buildInfoRow('Roaming réseau', card.isNetworkRoaming ? 'Oui' : 'Non'),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          return const Center(child: Text('Aucune donnée'));
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}