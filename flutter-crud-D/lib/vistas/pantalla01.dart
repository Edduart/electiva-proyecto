import 'package:flutter/material.dart';
import './pantalla02.dart';
import 'drawer.dart';

class Pantalla01 extends StatefulWidget {
  const Pantalla01({super.key});

  @override
  State<Pantalla01> createState() => _Pantalla01State();
}

class _Pantalla01State extends State<Pantalla01> {
  @override
  void initState() {
    // Valor inicial
    super.initState();
    controllerIP.text = '127.0.0.1';
  }

  final TextEditingController controllerIP = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MenuLateral(),
      backgroundColor: Theme.of(context).primaryColorLight,
      appBar: AppBar(
        title: const Text(
          'Configuracion de API',
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
          //mainAxisAlignment: MainAxisAlignment.center,
          padding: const EdgeInsets.all(10),
          children: <Widget>[
            const Text(
              'IP del Servidor',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white, // Cambia el color a azul
              ), // Tamaño de la fuente
            ),
            Row(
              children: [
                const Text('IP:'),
                const SizedBox(width: 5),
                Expanded(
                  child: TextField(
                    controller: controllerIP,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(20),
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                if (controllerIP.text != "") {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Pantalla02(
                          ipAdress: controllerIP.text,
                        ),
                      ));
                }
              },
              child: const Text('Aceptar'),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/', (route) => false);
                },
                child: const Text('Salir'))
          ],
        ),
      ),
    );
  }
}
