import 'package:flutter/material.dart';
import 'package:pagina_web_proyecto_lince/Provider/info_provider.dart';
import 'package:pagina_web_proyecto_lince/widgets/mapa.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/tabla.dart';

class InformationScreen extends StatefulWidget {
  const InformationScreen({super.key});

  @override
  State<InformationScreen> createState() => _InformationScreenState();
}

class _InformationScreenState extends State<InformationScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final infoProvider = Provider.of<InfoProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Center(
          child: SizedBox(
            height: 100,
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Image(image: AssetImage("assets/lince.jpg"), width: 50),
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text("Proyecto Lince - Telemetría", style: TextStyle(fontSize: 50)),
                  ),
                ],
              ),
            )),
        ),
      ),
      body: Padding (
        padding: EdgeInsets.only(top: size.width * 0.04, left: size.height * 0.2, right: size.height * 0.2),
        child: SizedBox(
          width: size.width * 0.8,
          height: size.height,
          child: Center(
            child: FutureBuilder(
              future: infoProvider.getInfo(),
              initialData: const ["Datos no disponibles","Datos no disponibles"],
              builder: (context, snapshot) {
                if(snapshot.data![0] == "\"latitud\"" || snapshot.data![0] == "\"No disponible\"") {
                  snapshot.data![0] = "Datos no disponibles";
                  snapshot.data![1] = "Datos no disponibles";
                }
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Tabla(coord: snapshot.data!),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 50),
                        child: Mapa(coord: snapshot.data!),
                      ),

                      Column(
                        children: [
                          Row(
                            // mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Text("Realizado por: "),
                              
                              GestureDetector(
                                onTap: () => _launchURL("https://www.linkedin.com/in/jesus-garcia-puerto-57526825b/"),
                                child: Text("Jesús García Puerto", style: TextStyle(color: Colors.blue[900]))
                              ),
                            ],
                          ),

                          Row(
                            // mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Text("Dirigido por: "),
                              GestureDetector(
                                onTap: () => _launchURL("https://www.linkedin.com/in/franciscobenitezchico/"),
                                child: Text("Francisco Manuel Benitez Chico", style: TextStyle(color: Colors.blue[900]))
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  // Detecta si hay algun cambio en la informacion obtenida del infoprovider, en caso de que lo haya actualiza la pagina
  @override
  void initState() 
  {
    super.initState();
    final infoProvider = Provider.of<InfoProvider>(context, listen: false);
    infoProvider.addListener(() 
    {
      setState(() {});
    });
  }

  // obtiene le un string, lo paso a url, comprueba si se puede lanzar la url y en caso de que se pueda lo abre
  void _launchURL(String urlString) async 
  {
    final url = Uri.parse(urlString);

    if (await canLaunchUrl(url)) 
    {
      await launchUrl(url);
    }
    else 
    {
      throw 'No se pudo abrir el enlace $url';
    }
  }
}
