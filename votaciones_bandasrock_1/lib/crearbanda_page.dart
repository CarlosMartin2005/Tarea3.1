import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CrearBanda extends StatelessWidget {
  CrearBanda({super.key});

  final nombreController = TextEditingController();
  final albumController = TextEditingController();
  final lanzamientoController = TextEditingController();
  final votoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Crear Banda',
          style: TextStyle(color: Colors.black),
          ),
        backgroundColor: Colors.lightBlue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextField(
                controller: nombreController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nombre',
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: albumController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Álbum',
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: lanzamientoController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Lanzamiento',
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: votoController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Voto',
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  // Add user to Firebase
                  //obtener los valores de los textfields
                  final data = {
                    'nombre': nombreController.text,
                    'album': albumController.text,
                    'lanzamiento': int.parse(lanzamientoController.text),
                    'voto': int.parse(votoController.text)
                  };

                  try {
                    final instance = FirebaseFirestore.instance;
                    final respuesta = await instance.collection('bandas').add(data);
                    print('Banda agregado con ID: ${respuesta.id}');
                    Navigator.pushNamed(context, '/bandas');
                  } catch (e) {
                    print('Error al agregar usuario: $e');
                  }

                  //mostrar un icono de carga

                  //agregar con un ID automatico
                  //final respuesta =
                  //    await instance.collection('usuarios').add(data);

                  // final respuesta = instance
                  //             .collection('usuarios/123/asignatutas_asignadas')
                  //             .add(data);
                },
                child: const Text('Agregar Banda'),
              ),
            ],
          ),
        ),
        ),
    );
  }
}