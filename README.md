# Atividades 21, 22 e 23 — OpenStreetMap com Flutter

Disciplina: **Programação para Dispositivos Móveis — IFPI**.

Este projeto adapta as três atividades sobre mapas para **`flutter_map` + OpenStreetMap**, **sem Google Cloud e sem chave de API**. A alternativa mantém as funcionalidades, mas **não utiliza a API Google Maps solicitada originalmente pelo professor**.

## O que cada arquivo faz

- **Atividade 21** (`lib/main.dart`): exibe o mapa centralizado no IFPI Teresina Central.
- **Atividade 22** (`lib/atividade22.dart`): mantém o mapa e mostra dois marcadores (IFPI Teresina Central e IFPI Zona Sul). Toque nos ícones para ler o nome do local.
- **Atividade 23** (`lib/atividade23.dart`): mantém o mapa e os marcadores, pede permissão de localização, mostra a posição atual com um ponto azul e exibe latitude e longitude. Tem botão para atualizar a posição.

## Preparar no Zed (Windows)

Abra esta pasta no Zed, abra o terminal e rode:

```powershell
flutter --version
flutter create . --platforms=android --org br.estudos
flutter pub add flutter_map latlong2 geolocator
```

Se você já tinha criado o projeto antes, **não precisa recriá-lo**. Basta substituir os três arquivos da pasta `lib/`, executar:

```powershell
flutter pub remove google_maps_flutter
flutter pub add flutter_map latlong2 geolocator
flutter pub get
```

O comando `flutter create` acima gera um projeto Android com o identificador `br.estudos.mapa_ifpi`, que também foi informado no `userAgentPackageName` usado pelo `flutter_map` para identificar o app nas solicitações ao servidor público do OpenStreetMap. Se seu aplicativo tiver outro identificador, ajuste `userAgentPackageName` nos três arquivos para corresponder ao identificador do aplicativo.

## Permissões Android

No arquivo `android/app/src/main/AndroidManifest.xml`, adicione estas linhas **diretamente dentro de `<manifest>` e antes de `<application>`**:

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
```

Para Android, o `geolocator` exige **compileSdk 35 ou superior**. Num projeto Flutter atual, confira `android/app/build.gradle.kts` e atualize o `compileSdk` se estiver abaixo de 35.

**Importante ao migrar de Google Maps:** se já colocou configurações do Google em `AndroidManifest.xml`, remova a tag `<meta-data android:name="com.google.android.geo.API_KEY" .../>`. Se modificou `build.gradle.kts` para ler `maps.properties` e configurar `MAPS_API_KEY`, remova essas alterações também. Não é necessário nenhum arquivo de chave.

Para os detalhes, consulte [CONFIGURAR_ANDROID.md](guias/CONFIGURAR_ANDROID.md).

## Executar

Use um celular Android conectado ou um emulador com rede funcionando:

```powershell
flutter devices
flutter run -t lib/main.dart
```

Para a segunda atividade, pare a execução com `q` e rode:

```powershell
flutter run -t lib/atividade22.dart
```

Para a terceira:

```powershell
flutter run -t lib/atividade23.dart
```

Se a localização não aparecer, ative o GPS e permita acesso à localização. No emulador, configure uma localização de teste.

## Conceitos vistos nas atividades

- `FlutterMap` e `MapOptions`: mapa e posição inicial.
- `TileLayer`: imagens do mapa do OpenStreetMap.
- `MarkerLayer` e `Marker`: pontos no mapa.
- `initState()` e `setState()`: carregar os dados e atualizar a tela.
- `geolocator`: obter a localização atual com permissão do usuário.
- `MapController`: centralizar o mapa na localização atual.

## Uso do OpenStreetMap

O servidor público `tile.openstreetmap.org` é gratuito para visualização interativa moderada, mas **não é um serviço de mapas ilimitado**. É necessário manter a atribuição visível, identificar o aplicativo e respeitar as regras de uso. Não use download em massa de mapas. Este projeto usa o servidor para atividades práticas.

## Links

- https://pub.dev/packages/flutter_map
- https://pub.dev/packages/geolocator
- https://operations.osmfoundation.org/policies/tiles/
