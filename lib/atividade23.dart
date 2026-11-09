import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

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
  final MapController _controlador = MapController();
  Set<Marker> _marcadores = {};
  bool _mostrarLocalizacao = false;
  bool _mapaPronto = false;
  String _mensagem = 'Obtendo a localização do dispositivo...';
  LatLng? _pontoAtual;

  @override
  void initState() {
    super.initState();
    _carregarMarcadores();
    _localizacaoAtual();
  }

  @override
  void dispose() {
    _controlador.dispose();
    super.dispose();
  }

  void _mostrarNome(String nome) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(nome)),
    );
  }

  void _carregarMarcadores() {
    setState(() {
      _marcadores = {
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
    });
  }

  Future<void> _localizacaoAtual() async {
    try {
      bool servicoAtivo = await Geolocator.isLocationServiceEnabled();
      if (!servicoAtivo) {
        if (!mounted) return;
        setState(() {
          _mensagem = 'Ative a localização (GPS) do dispositivo.';
        });
        return;
      }

      LocationPermission permissao = await Geolocator.checkPermission();
      if (permissao == LocationPermission.denied) {
        permissao = await Geolocator.requestPermission();
      }

      if (permissao == LocationPermission.denied ||
          permissao == LocationPermission.deniedForever) {
        if (!mounted) return;
        setState(() {
          _mensagem = 'Permissão de localização negada.';
        });
        return;
      }

      final Position posicao = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      if (!mounted) return;

      setState(() {
        _pontoAtual = LatLng(posicao.latitude, posicao.longitude);
        _mostrarLocalizacao = true;
        _mensagem =
            'Latitude: ${posicao.latitude.toStringAsFixed(5)} | '
            'Longitude: ${posicao.longitude.toStringAsFixed(5)}';
      });

      if (_mapaPronto) {
        _controlador.move(_pontoAtual!, 16);
      }
    } catch (erro) {
      if (!mounted) return;
      setState(() {
        _mensagem = 'Não foi possível obter a localização: $erro';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Atividade 23 - Geolocalização'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            onPressed: _localizacaoAtual,
            icon: const Icon(Icons.my_location),
            tooltip: 'Atualizar localização',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: FlutterMap(
              mapController: _controlador,
              options: MapOptions(
                initialCenter: const LatLng(-5.095, -42.812),
                initialZoom: 13,
                onMapReady: () {
                  _mapaPronto = true;
                  if (_pontoAtual != null) {
                    _controlador.move(_pontoAtual!, 16);
                  }
                },
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'br.estudos.mapa_ifpi',
                ),
                MarkerLayer(
                  markers: [
                    ..._marcadores,
                    if (_mostrarLocalizacao && _pontoAtual != null)
                      Marker(
                        key: const ValueKey('localizacao_atual'),
                        point: _pontoAtual!,
                        width: 25,
                        height: 25,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                          ),
                        ),
                      ),
                  ],
                ),
                const SimpleAttributionWidget(
                  source: Text('OpenStreetMap contributors'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              _mensagem,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
