import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Mapa extends StatelessWidget 
{
  final List<String> coord;

  const Mapa({super.key, required this.coord});

  @override
  Widget build(BuildContext context) 
  {
    if (coord[0] != "Datos no disponibles")
    {
      //instancia de un objeto de tipo LatLng de la librebrería de google_maps_flutter
      final LatLng posicion = _parsearCoordALatLng("${coord[0]},${coord[1]}");

      //coordenadas de prueba de las oficionas de Google
      //const LatLng posicion = LatLng(37.4219983, -122.084);

      // inicializo la posicion inicial de la camara al punto en el que estamos y le pongo un zoom de 15
      // CameraPosition initialCameraPosition = CameraPosition (
      //   target: posicion,
      //   zoom: 15
      // );

      // return GoogleMap(
      //  initialCameraPosition: initialCameraPosition
      // );
      return Text(posicion.toString());
    }

    return const Text("Cargando datos");
  }
}

// pasa las coordenadas de string a decimal e instancia un objeto LatLng
LatLng _parsearCoordALatLng(String coordenadas) {
  coordenadas = coordenadas.replaceAll("\"", "");
  // dividir las coordenadas en latitud y longitud
  List<String> partes = coordenadas.split(',');

  // obtener la latitud
  String latitud = partes[0];
  // pasa las coordenadas de String en formato grados, minutos y segundos a formato decimal
  double latitudDecimal = _convertirCoordenadasDeStringADouble(latitud);

  // obtener la longitud
  String longitud = partes[1];
  // pasa las coordenadas de String en formato grados, minutos y segundos a formato decimal
  double longitudDecimal = _convertirCoordenadasDeStringADouble(longitud);

  // Crear un objeto LatLng con las coordenadas en formato decimal
  LatLng ubicacion = LatLng(latitudDecimal, longitudDecimal);
  return ubicacion;
}

// divide las partes de las coordenadas en formato grados, minutos y segundos a formato decimal
double _convertirCoordenadasDeStringADouble(String coord) {
  // separa las diferentes partes de las coordenada pasada
  List<String> partes = coord.split('º');
  int grados = int.parse(partes[0]);

  partes = partes[1].split("'");
  double minutos = double.parse(partes[0]);
  
  // convierte la coordenada a decimal
  double decimal = grados + (minutos / 60);

  // asegurarse de que la latitud y longitud tengan el signo correcto
  String direccion = partes[1].trim();

  if (direccion == "S" || direccion == "W") {
    decimal = -decimal;
  }

  return decimal;
}