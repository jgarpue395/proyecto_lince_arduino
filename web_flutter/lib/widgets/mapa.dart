import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter_web/google_maps_flutter_web.dart' show LatLng;

class Mapa extends StatefulWidget 
{
  const Mapa({super.key});

  @override
  State<Mapa> createState() => _MapaState();
}

class _MapaState extends State<Mapa> 
{
  @override
  Widget build(BuildContext context) 
  {
    return const Text("Mapa");
  }
}