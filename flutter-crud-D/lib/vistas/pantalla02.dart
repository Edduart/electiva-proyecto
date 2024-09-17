import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'drawer.dart';
import 'dart:io';

class Product {
  final String? numero;
  final String codigo;
  final String nombre;
  final String descripcion;
  final double cantidad;
  final double stockmax;
  final double srockmin; // error
  final double precio;
  final String codcat;

  Product({
    this.numero,
    required this.codigo,
    required this.nombre,
    required this.descripcion,
    required this.cantidad,
    required this.stockmax,
    required this.srockmin,
    required this.precio,
    required this.codcat,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      numero: json['numero'],
      codigo: json['codigo'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      cantidad: json['cantidad'].toDouble(),
      stockmax: json['stockmax'].toDouble(),
      srockmin: json['srockmin'].toDouble(),
      precio: json['precio'].toDouble(),
      codcat: json['codcat'],
    );
  }
}

class Pantalla02 extends StatefulWidget {
  final String? ipAdress;

  const Pantalla02({super.key, required this.ipAdress});
  @override
  State<Pantalla02> createState() => _Pantalla02State();
}

class _Pantalla02State extends State<Pantalla02> {
  TextEditingController controllerIp = TextEditingController();
  Future<List<Product>>? _productList;
  String? apiIp;
  var _connectionStatus = "";
  @override
  void initState() {
    // Valor inicial
    super.initState();
    controllerIp.text = '';
    apiIp = widget.ipAdress;
    _productList = fetchData();
  }

  Future<List<Product>> fetchData() async {
    if (apiIp == null) {
      throw Exception('IP address is invalid');
    }
    try {
      final response = await http.get(Uri.parse('http://$apiIp:3000/'));
      if (response.statusCode == 200) {
        setState(() {
          _connectionStatus = "conexión OK";
          controllerIp.text = _connectionStatus;
        });
        final data = jsonDecode(response.body) as List<dynamic>;
        return data.map((item) => Product.fromJson(item)).toList();
      } else {
        throw Exception(
            'Error al obtener la informacion (Status Code: ${response.statusCode})');
      }
    } on SocketException catch (e) {
      setState(() {
        _connectionStatus = "conexión rechazada";
        controllerIp.text = _connectionStatus;
      });
      return Future.error(Exception('Conexion rechazada: ${e.address}'));
    } catch (e) {
      setState(() {
        _connectionStatus = "Error desconocido";
        controllerIp.text = _connectionStatus;
      });
      return Future.error(Exception('Error: $e'));
    }
  }

  Future<int> deleteProduct(String productId) async {
    if (apiIp == null) {
      throw Exception('IP address is invalid');
    }
    final url = Uri.parse('http://$apiIp:3000/$productId');
    final response = await http.delete(url);
    if (response.statusCode == 200) {
      return Future.value(1);
    } else {
      throw Exception('Error al elimniar el producto: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MenuLateral(),
      backgroundColor: Theme.of(context).primaryColorLight,
      appBar: AppBar(
        title: const Text(
          'Lista',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/fondo2.jpg"),
            fit: BoxFit.fill,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(10),
          children: <Widget>[
            Row(children: [
              const Text(
                'API:',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromARGB(255, 243, 244, 245),
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: TextField(
                  controller: controllerIp,
                  readOnly: true,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(20),
                    //border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
              ),
            ]),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Productos:',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromARGB(255, 243, 244, 245),
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            FutureBuilder<List<Product>>(
              future: _productList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  return Container(
                      decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      height: 550,
                      //color: const Color.fromARGB(255, 255, 255, 255),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final product = snapshot.data![index];
                          return ListTile(
                            title: Text(
                              '* ${product.numero ?? "Numero no proporcionado"}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Divider(),
                                Text(
                                  '- Codigo: ${product.codigo}',
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Divider(),
                                Text(
                                  '- Nombre: ${product.nombre}',
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Divider(),
                                Text(
                                  '- Descripcion: ${product.descripcion}',
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Divider(),
                                Text(
                                  '- Cantidad: ${product.cantidad}',
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Divider(),
                                Text(
                                  '- Stock máximo: ${product.stockmax}',
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Divider(),
                                Text(
                                  '- Stock mínimo: ${product.srockmin}',
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Divider(),
                                Text(
                                  '- Precio: ${product.precio}',
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Divider(),
                                Text(
                                  '- Código de categoría: ${product.codcat}',
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Divider(),
                                const Divider(
                                  height: 35,
                                  color: Color.fromARGB(255, 182, 182, 182),
                                  thickness: 10,
                                ),
                                const Divider(
                                  height: 10,
                                  color: Color.fromARGB(255, 182, 182, 182),
                                  thickness: 10,
                                )
                              ],
                            ),
                            trailing: Container(
                                decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 182, 182, 182),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50))),
                                //color: Color.fromARGB(255, 145, 145, 145),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Color.fromARGB(255, 209, 44, 44),
                                  ),
                                  onPressed: () async {
                                    final shouldDelete = await showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Eliminar'),
                                        content: const Text(
                                            'Estas seguro de eliminar el producto?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(
                                                context, false), // Cancel
                                            child: const Text('Cancelar'),
                                          ),
                                          TextButton(
                                            onPressed: () => Navigator.pop(
                                                context, true), // Delete
                                            child: const Text('Eliminar'),
                                          ),
                                        ],
                                      ),
                                    );
                                    if (shouldDelete ?? false) {
                                      try {
                                        final result =
                                            await deleteProduct(product.codigo);
                                        if (result == 1) {
                                          setState(() {
                                            snapshot.data!.remove(product);
                                          });
                                        }
                                      } catch (e) {
                                        throw Exception(
                                            'Error al eliminar el producto: $e');
                                      }
                                    }
                                  },
                                )),
                            textColor: const Color.fromARGB(255, 0, 0, 0),
                            contentPadding: const EdgeInsets.all(10),
                          );
                        },
                      ));
                }
              },
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Regresar')),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/', (route) => false);
                },
                child: const Text('Inicio')),
          ],
        ),
      ),
    );
  }
}
