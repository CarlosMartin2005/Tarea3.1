import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BandasPage extends StatefulWidget {
  final String? imagenUrl;

  const BandasPage({Key? key, this.imagenUrl}) : super(key: key);

  @override
  State<BandasPage> createState() => _BandasPageState();
}

class _BandasPageState extends State<BandasPage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final bandas = firestore.collection('bandas').snapshots();
    final String imagenUrl = widget.imagenUrl ?? 'https://www.crushpixel.com/big-static15/preview4/indie-rock-music-band-black-2130446.jpg';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
          'Bandas de Rock',
          style: TextStyle(color: Colors.white),),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: bandas,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final listaBandas = snapshot.data!.docs;

            return ListView.builder(
              itemCount: listaBandas.length,
              itemBuilder: (context, index) {
                final banda = listaBandas[index];
                final votos = banda['voto'].toString();

                      return Column(
                        children: [
                          Card(
                            margin: const EdgeInsets.all(8.0),
                            elevation: 4.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15), 
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                              tileColor: Colors.blueGrey[50],
                              leading: CircleAvatar(
                                    backgroundColor: Colors.deepPurple,
                                    backgroundImage: NetworkImage(banda['url']),
                                  ),
                              title: Text(
                                    banda['nombre'],
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(banda['album']),
                                  Text(banda['lanzamiento'].toString()), 
                                ],
                              ),
                              trailing: Text('VOTOS: $votos'),
                              onTap: () async {
                                // Definimos la referencia al documento
                                DocumentReference docRef = FirebaseFirestore.instance.collection('bandas').doc(banda.id);

                                // Obtenemos la referencia al documento
                                FirebaseFirestore.instance.runTransaction((transaction) async {
                                  DocumentSnapshot snapshot = await transaction.get(docRef);

                                  if (!snapshot.exists) {
                                    throw Exception("El documento no existe!");
                                  }
                                  else {
                                    // Incrementa el número de votos
                                    int nuevoVoto = snapshot.get('voto') + 1;
                                    transaction.update(docRef, {'voto': nuevoVoto});
                                  }
                                }
                                );
                              }
                            ),
                          ),
                          const Divider(),
                        ],
                        );
              }
            );
          } 
          else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/crear_banda');
        },
        tooltip: 'Nueva banda',
        child: const Icon(Icons.add),
      ),
    );
  }
}