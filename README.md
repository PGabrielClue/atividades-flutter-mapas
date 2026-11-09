# Atividades de Programação para Dispositivos Móveis

Repositório com as atividades 21, 22, 23 e uma atividade extra da disciplina de Programação para Dispositivos Móveis do IFPI.

As atividades foram desenvolvidas utilizando Flutter e Dart. Para exibir os mapas, utilizei a biblioteca `flutter_map` com OpenStreetMap.

## Atividades

**Atividade 21 — Mapa**

Criação de um aplicativo que exibe um mapa de Teresina, com a localização inicial no IFPI.

**Atividade 22 — Marcadores**

Adição de marcadores no mapa para identificar os campi IFPI Teresina Central e IFPI Zona Sul.

**Atividade 23 — Geolocalização**

Implementação da localização atual do dispositivo utilizando a biblioteca `geolocator`. O aplicativo mostra a posição no mapa e as coordenadas de latitude e longitude.

**Atividade Extra — Ícones no mapa**

Adição de ícones personalizados no mapa, como carros, semáforos, placas de trânsito e escola. Também foi adicionada uma seta azul para representar a localização do usuário.

## Bibliotecas utilizadas

- `flutter_map` — Exibição do mapa.
- `latlong2` — Coordenadas de latitude e longitude.
- `geolocator` — Localização do dispositivo.

## Como executar

Com o Flutter instalado, execute:

```bash
flutter pub get
```

Para abrir cada atividade no Chrome:

```bash
flutter run -d chrome -t lib/main.dart
flutter run -d chrome -t lib/atividade22.dart
flutter run -d chrome -t lib/atividade23.dart
flutter run -d chrome -t lib/atividade_extra.dart
```

Execute um comando por vez.

## Observação

Foi utilizado OpenStreetMap como alternativa ao Google Maps. Os ícones de carros e sinalizações da atividade extra são apenas exemplos para demonstrar o uso de marcadores no mapa.
