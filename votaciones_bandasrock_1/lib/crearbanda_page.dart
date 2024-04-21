import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CrearBanda extends StatefulWidget {
  CrearBanda({Key? key}) : super(key: key);

  @override
  CrearBandaState createState() => CrearBandaState();
}

class CrearBandaState extends State<CrearBanda>{
  
  final nombreController = TextEditingController();
  final albumController = TextEditingController();
  final lanzamientoController = TextEditingController();
  final votoController = TextEditingController();

  final instance = FirebaseFirestore.instance;

  final formKey = GlobalKey<FormState>();
  
  Future<String> subirFoto(String path) async {
    // Referencia a la instancia de Firebase Storage
    final storageRef = FirebaseStorage.instance.ref();

    final imagen = File(path); // el archivo que voy a subir

    final timestamp = DateTime.now().millisecondsSinceEpoch;

    //la referencia donde voy a guardar
    final referenciaFotoPerfil =
        storageRef.child("bandas/imagenes/banda_foto_$timestamp.jpg");

    final uploadTask = await referenciaFotoPerfil.putFile(imagen);

    final url = await uploadTask.ref.getDownloadURL();

    return url;
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as String?;

    if (args != null) {
      instance.collection('usuarios').doc(args).get().then((value) {
        nombreController.text = value['nombre'];
        albumController.text = value['album'];
        lanzamientoController.text = value['año de lanzamiento'].toString();
        votoController.text = value['año de lanzamiento'].toString();
      });
    }
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
              Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                    controller: nombreController,
                    validator: (value){
                      if (value!.isEmpty) return 'El nombre de la banda es obligatorio';

                      return null;
                    },
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Nombre',
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: albumController,
                    validator: (value){
                      if (value!.isEmpty) return 'El album de la banda es obligatorio';

                      return null;
                    },
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Álbum',
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: lanzamientoController,
                    validator: (value){
                      if (value!.isEmpty) return 'El año de lanzamiento de la banda es obligatorio';

                      return null;
                    },
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Año de lanzamiento',
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: votoController,
                    validator: (value){
                      if (value!.isEmpty) return 'El(los) voto(s) de la banda es(son) obligatorio(s)';

                      return null;
                    },
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Voto(s)',
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        print('Nombre: ${nombreController.text}');
                        print('Álbum: ${albumController.text}');
                        print('Año de lanzamiento: ${lanzamientoController.text}');
                        print('Voto(s): ${votoController.text}');

                        final ImagePicker picker = ImagePicker();

                      final XFile? image =
                          await picker.pickImage(source: ImageSource.gallery);

                      if (image == null) return;

                      final url = await subirFoto(image.path);

                      print(url);

                        final data = {
                          'nombre': nombreController.text,
                          'album': albumController.text,
                          'lanzamiento': int.parse(lanzamientoController.text),
                          'voto': int.parse(votoController.text),
                          'url' : url,
                        };

                        try {
                          final instance = FirebaseFirestore.instance;
                          final respuesta = await instance.collection('bandas').add(data);
                          print('Banda agregado con ID: ${respuesta.id}');
                        } catch (e) {
                          print('Error al agregar usuario: $e');
                        }
                        
                      }
                      Navigator.pop(context);
                    },
                    child: const Text('Agregar Banda'),
                  ),
                  ],
                ),
              )
            ],
          ),
        ),
        ),
    );
  }
}