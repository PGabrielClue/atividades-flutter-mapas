import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
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
  final MapController _controlador = MapController();
  Set<Marker> _marcadores = {};
  bool _mapaPronto = false;
  LatLng? _pontoAtual;
  double _direcao = 0;
  String _mensagem = 'Obtendo sua localização...';

  final LatLng _ifpi = const LatLng(-5.088544046019581, -42.81123803149089);

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

  // Marcadores dos campi do IFPI (da atividade 23).
  void _carregarMarcadores() {
    _marcadores = {
      Marker(
        key: const ValueKey('ifpi_central'),
        point: _ifpi,
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
  }

  // Pega a localização do dispositivo, como na atividade anterior.
  Future<void> _localizacaoAtual() async {
    try {
      final servicoAtivo = await Geolocator.isLocationServiceEnabled();
      if (!servicoAtivo) {
        if (!mounted) return;
        setState(() => _mensagem = 'Ative a localização do dispositivo.');
        return;
      }

      LocationPermission permissao = await Geolocator.checkPermission();
      if (permissao == LocationPermission.denied) {
        permissao = await Geolocator.requestPermission();
      }

      if (permissao == LocationPermission.denied ||
          permissao == LocationPermission.deniedForever) {
        if (!mounted) return;
        setState(() => _mensagem = 'Permissão de localização negada.');
        return;
      }

      final posicao = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      if (!mounted) return;

      setState(() {
        _pontoAtual = LatLng(posicao.latitude, posicao.longitude);
        // O GPS informa o rumo do MOVIMENTO, não para onde o celular aponta.
        // Parado ou sem rumo disponível, a seta fica apontada para cima.
        _direcao = posicao.speed > 1 && posicao.heading.isFinite
            ? posicao.heading
            : 0;
        _mensagem =
            'Latitude: ${posicao.latitude.toStringAsFixed(5)} | '
            'Longitude: ${posicao.longitude.toStringAsFixed(5)}';
      });

      if (_mapaPronto) {
        _controlador.move(_pontoAtual!, 16);
      }
    } catch (erro) {
      if (!mounted) return;
      setState(() => _mensagem = 'Não foi possível obter a localização: $erro');
    }
  }

  // Ícone simples para enfeitar o mapa, sem imagens ou pacotes extras.
  Widget _iconeDecorativo(IconData icone, Color cor, String descricao) {
    return GestureDetector(
      onTap: () => _mostrarNome('$descricao (simulação)'),
      child: Container(
        decoration: BoxDecoration(
          color: cor,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: const [
            BoxShadow(color: Colors.black26, blurRadius: 4),
          ],
        ),
        child: Icon(icone, color: Colors.white, size: 28),
      ),
    );
  }

  Widget _placaVelocidade() {
    return GestureDetector(
      onTap: () => _mostrarNome('Placa de velocidade (simulação)'),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.red, width: 5),
        ),
        child: const Text(
          '40',
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _setaAzul() {
    return Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0x4442A5F5),
      ),
      child: Transform.rotate(
        angle: _direcao * math.pi / 180,
        child: const Icon(
          Icons.navigation,
          color: Color(0xFF00A9DC),
          size: 45,
          shadows: [
            Shadow(color: Colors.white, blurRadius: 5),
            Shadow(color: Colors.black54, blurRadius: 2),
          ],
        ),
      ),
    );
  }

  // Estes pontos são APENAS ilustrativos e aparecem perto do usuário.
  List<Marker> _criarIconesDecorativos(LatLng centro) {
    return [
      Marker(
        point: LatLng(centro.latitude + 0.0012, centro.longitude - 0.0010),
        width: 46,
        height: 46,
        child: _iconeDecorativo(Icons.traffic, Colors.black87, 'Semáforo'),
      ),
      Marker(
        point: LatLng(centro.latitude - 0.0008, centro.longitude + 0.0015),
        width: 46,
        height: 46,
        child: _iconeDecorativo(Icons.traffic, Colors.black87, 'Semáforo'),
      ),
      Marker(
        point: LatLng(centro.latitude + 0.0008, centro.longitude + 0.0012),
        width: 46,
        height: 46,
        child: _iconeDecorativo(Icons.directions_car, Colors.black87, 'Carro 1'),
      ),
      Marker(
        point: LatLng(centro.latitude - 0.0011, centro.longitude - 0.0008),
        width: 46,
        height: 46,
        child: _iconeDecorativo(Icons.directions_car, Colors.orange, 'Carro 2'),
      ),
      Marker(
        point: LatLng(centro.latitude + 0.0019, centro.longitude + 0.0002),
        width: 48,
        height: 48,
        child: _iconeDecorativo(Icons.school, Colors.indigo, 'Colégio'),
      ),
      Marker(
        point: LatLng(centro.latitude - 0.0018, centro.longitude + 0.0005),
        width: 47,
        height: 47,
        child: _placaVelocidade(),
      ),
      Marker(
        point: LatLng(centro.latitude + 0.0001, centro.longitude - 0.0017),
        width: 46,
        height: 46,
        child: _iconeDecorativo(
          Icons.warning_amber_rounded,
          Colors.amber.shade800,
          'Placa de atenção',
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    // Se o GPS não estiver disponível, o exemplo aparece perto do IFPI.
    final centroDecoracao = _pontoAtual ?? _ifpi;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Atividade Extra - Ícones no Mapa'),
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
                initialCenter: _ifpi,
                initialZoom: 16,
                onMapReady: () {
                  _mapaPronto = true;
                  if (_pontoAtual != null) {
                    _controlador.move(_pontoAtual!, 16);
                  }
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'br.estudos.mapa_ifpi',
                ),
                MarkerLayer(
                  markers: [
                    ..._marcadores,
                    ..._criarIconesDecorativos(centroDecoracao),
                    if (_pontoAtual != null)
                      Marker(
                        key: const ValueKey('localizacao_atual'),
                        point: _pontoAtual!,
                        width: 75,
                        height: 75,
                        child: _setaAzul(),
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
            child: Column(
              children: [
                Text(_mensagem, textAlign: TextAlign.center),
                const SizedBox(height: 4),
                const Text(
                  'Carros, placas, semáforos e colégio são ilustrativos.',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
