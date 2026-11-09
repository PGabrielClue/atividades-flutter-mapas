import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

void main() {
  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TelaMapa(),
    );
  }
}

class TelaMapa extends StatefulWidget {
  const TelaMapa({super.key});

  @override
  State<TelaMapa> createState() => _TelaMapaState();
}

class _TelaMapaState extends State<TelaMapa> {
  Set<Marker> _marcadores = {};

  @override
  void initState() {
    super.initState();
    _carregarMarcadores();
  }

  void _mostrarNome(String nome) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(nome)),
    );
  }

  void _carregarMarcadores() {
    final Set<Marker> marcadoresLocal = {
      Marker(
        key: const ValueKey('ifpi_central'),
        point: const LatLng(-5.088544046019581, -42.81123803149089),
        width: 50,
        height: 50,
        alignment: Alignment.bottomCenter,
        child: GestureDetector(
          onTap: () => _mostrarNome('IFPI - Teresina Central'),
          child: const Icon(Icons.location_on, size: 45, color: Colors.red),
        ),
      ),
      Marker(
        key: const ValueKey('ifpi_sul'),
        point: const LatLng(-5.101723, -42.813114),
        width: 50,
        height: 50,
        alignment: Alignment.bottomCenter,
        child: GestureDetector(
          onTap: () => _mostrarNome('IFPI - Zona Sul'),
          child: const Icon(Icons.location_on, size: 45, color: Colors.red),
        ),
      ),
    };

    setState(() {
      _marcadores = marcadoresLocal;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Atividade 22 - Marcadores'),
        backgroundColor: Colors.green,
      ),
      body: FlutterMap(
        options: const MapOptions(
          initialCenter: LatLng(-5.095, -42.812),
          initialZoom: 13,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'br.estudos.mapa_ifpi',
          ),
          MarkerLayer(markers: _marcadores.toList()),
          const SimpleAttributionWidget(
            source: Text('OpenStreetMap contributors'),
          ),
        ],
      ),
    );
  }
}
