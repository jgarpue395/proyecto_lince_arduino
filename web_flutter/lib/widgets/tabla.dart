import 'package:flutter/material.dart';

class Tabla extends StatelessWidget {
  final List<String> coord;

  const Tabla({super.key, required this.coord});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Table(
        defaultColumnWidth: const FixedColumnWidth(270),
        border: const TableBorder(verticalInside: BorderSide(width: 1), horizontalInside: BorderSide(width: 1)),
        children: [
          TableRow(
            children: [
              const TableCell(child: Text("Latitud", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25))),
              TableCell(child: Text(coord[0], style: const TextStyle(fontSize: 25)))
            ]
          ),

          TableRow(
            children: [
              const TableCell(child: Text("Longitud", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25))),
              TableCell(child: Text(coord[1], style: const TextStyle(fontSize: 25)))
            ]
          ),
        ],
      )
    );
  }
}