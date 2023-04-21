import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart' show LatLng;
import 'package:pagina_web_proyecto_lince/Provider/info_provider.dart';
import 'package:provider/provider.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';


class Mapa extends StatelessWidget 
{
  final List<String> coord;

  const Mapa({super.key, required this.coord});

  @override
  Widget build(BuildContext context) 
  {
    final size = MediaQuery.of(context).size;
    final infoProvider = Provider.of<InfoProvider>(context, listen: false);

    if (coord[0] != "Datos no disponibles" && coord[0] != "\"latitud\"" && coord[0] != "\"\"" && coord[1] != "\"\"")
    {
      //instancia de un objeto de tipo LatLng de la librebrería de google_maps_flutter
      final  posicionCoche = _parsearCoordALatLng("${coord[0]},${coord[1]}");

      // SizedBox para que el mapa no se desborde
      return SizedBox(
        width: size.width * 0.8,
        height: size.height * 0.6,
        // Objeto del mapa de la librería flutter_map
        child: FlutterMap(
          // Configuro la posicion inicial y el zoom
          options: MapOptions(
            center: posicionCoche,
            minZoom: 15,
            zoom: 18,
            maxZoom: 18.49,
          ),
          nonRotatedChildren: [
            AttributionWidget.defaultWidget(
              source: 'Lince Geolocation',
              onSourceTapped: null,
            ),
          ],
          children: [
            // Cargo la imagen del mapa, usando la url indicada, con subdominios para aumentar la velocidad de carga, y utilizo un paquete para controlar el trafico de la aplicacion 
            FutureBuilder(
              future: infoProvider.getURLTemplate(),
              builder: (context, snapshot) {
                return TileLayer(
                  urlTemplate: snapshot.data ?? "https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}",
                  subdomains: const ['mt0', 'mt1', 'mt2', 'mt3'],
                  userAgentPackageName: 'es.jgp.proyecto_integrado_telemetria_lince',
                ); 
              }
            ),

            // Lista de Markers
            MarkerLayer(
              markers: [
                // Configuro un Marker en la posición del coche con la imagen customizada
                Marker(
                  point: posicionCoche,
                  width: 80,
                  height: 80,
                  builder: (context) => Image.asset('assets/marker_lince.png')
                ),
              ],
            ),
          ],
        )
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: size.width * 0.1),
      child: const CircularProgressIndicator(),
    );
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

