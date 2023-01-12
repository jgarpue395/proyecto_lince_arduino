import 'package:flutter/material.dart';
import 'package:pagina_web_proyecto_lince/Provider/info_provider.dart';
import 'package:pagina_web_proyecto_lince/screens/information_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const AppState());
}

class AppState extends StatelessWidget
{
  const AppState({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => InfoProvider(), lazy: false,)
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: InformationScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}