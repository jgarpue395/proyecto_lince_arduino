import 'package:flutter/material.dart';
import 'package:pagina_web_proyecto_lince/Provider/info_provider.dart';
import 'package:pagina_web_proyecto_lince/widgets/mapa.dart';
import 'package:provider/provider.dart';
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
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: size.width * 0.1, horizontal: size.height * 0.2),
        child: SizedBox(
          width: size.width * 0.8,
          height: size.height * 0.8,
          child: Center(
            child: FutureBuilder(
              future: infoProvider.getInfo(),
              initialData: const ["Datos no disponibles","Datos no disponibles"],
              builder: (context, snapshot) {
                return Expanded(
                  child: ListView(
                    children: [Column(
                      children: [
                        Tabla(coord: snapshot.data!),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Mapa(coord: snapshot.data!),
                        )
                      ],
                    )],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    final infoProvider = Provider.of<InfoProvider>(context, listen: false);
    infoProvider.addListener(() {
      setState(() {});
    });
  }
}
