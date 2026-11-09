# Configurar Android para Flutter Map + OpenStreetMap

**Não precisa de chave, Google Cloud, `maps.properties` ou Maps SDK for Android.**

1. Abra no Zed a pasta do projeto.
2. Se ainda não existir a pasta `android/`, execute `flutter create . --platforms=android --org br.estudos`.
3. Execute `flutter pub add flutter_map latlong2 geolocator`.
4. Abra `android/app/src/main/AndroidManifest.xml`.
5. Adicione dentro de `<manifest>`, fora da tag `<application>`:

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
```

6. Confira se `android/app/build.gradle.kts` tem `compileSdk` 35 ou superior, conforme a versão de `geolocator` instalada. Se ele já usar `flutter.compileSdkVersion` e o Flutter atual atender ao requisito, não precisa mudar.
7. Se o projeto havia sido configurado para Google Maps, remova a `<meta-data android:name="com.google.android.geo.API_KEY" ... />` do `AndroidManifest.xml` e os acréscimos feitos só para `MAPS_API_KEY` no Gradle. Mantenha o restante.
8. Rode `flutter run -t lib/main.dart` e teste. Depois rode `flutter run -t lib/atividade22.dart` e `flutter run -t lib/atividade23.dart`.

**Observação:** os mapas precisam de internet. A localização é solicitada apenas durante o uso do aplicativo. O servidor público do OpenStreetMap exige identificação do aplicativo e atribuição, já presentes nos códigos. Se o package ID não for `br.estudos.mapa_ifpi`, altere o valor `userAgentPackageName` em cada arquivo Dart.
