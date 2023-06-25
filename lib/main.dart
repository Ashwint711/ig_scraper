import 'package:flutter/material.dart';
import 'package:ig_scraper/screens/dashboard.dart';
import 'package:flutter/services.dart';

final ColorScheme instagramColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 96, 59, 181),
);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((fn) {
    runApp(const InstagramMetadataApp());
  });
}

class InstagramMetadataApp extends StatelessWidget {
  const InstagramMetadataApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Instagram Metadata App',
      theme: ThemeData().copyWith(colorScheme: instagramColorScheme),
      home: const GetAccessToken(),
    );
  }
}
