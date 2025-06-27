import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Actividad 1: Contador',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
      ),
      home: const MyHomePage(title: 'Actividad 1'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  int _paginaActual = -1;
  
  List<Widget> get _paginas => [
    const PaginaLista(),
    const PaginaCard(),
    const PaginaGrid(),
  ];

  void _incrementCounter() {
  if (_counter >= 20) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('¡Ya alcanzaste el límite de 20 clics!'),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.redAccent,
      ),
    );
    return;
  }

  setState(() {
    _counter++;
  });
}

void _decrementCounter() {
  if (_counter <= 0) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('¡No puedes bajar de 0 clics!'),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.redAccent,
      ),
    );
    return;
  }

  setState(() {
    _counter--;
  });
}

void _buttonReset() {
  setState(() {
    _counter = 0;
  });

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('¡Contador reiniciado!'),
      duration: Duration(seconds: 2),
      backgroundColor: Colors.orangeAccent,
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    Widget bodyContent;
    if (_paginaActual == -1) {
      bodyContent = PaginaHome(
        counter: _counter,
        incrementCounter: _incrementCounter,
        decrementCounter: _decrementCounter,
        buttonReset: _buttonReset,
      );
    } else {
      bodyContent = _paginas[_paginaActual];
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.orangeAccent,
              ),
              child: Text(
                'Menú de Navegación',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Inicio'),
              onTap: () {
                setState(() {
                  _paginaActual = -1; 
                });
                Navigator.pop(context); 
              },
            ),
            ListTile(
              leading: const Icon(Icons.list),
              title: const Text('Lista'),
              onTap: () {
                setState(() {
                  _paginaActual = 0;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.add_card),
              title: const Text('Cartas'),
              onTap: () {
                setState(() {
                  _paginaActual = 1;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.grid_view),
              title: const Text('Grid de Imagenes'),
              onTap: () {
                setState(() {
                  _paginaActual = 2;
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: bodyContent,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _paginaActual == -1 ? 0 : _paginaActual,
        onTap: (int index) {
          setState(() {
            _paginaActual = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.list),
            label: 'Listas',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.add_card),
            label: 'Cartas',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.grid_view),
            label: 'Grid',
          ),
        ], 
      ),
    );
  }
}

class PaginaHome extends StatelessWidget {
  final int counter;
  final VoidCallback incrementCounter;
  final VoidCallback decrementCounter;
  final VoidCallback buttonReset;

  const PaginaHome(
    {
      super.key,
      required this.counter,
      required this.incrementCounter,
      required this.decrementCounter, 
      required this.buttonReset,
    }
  );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('Diego Torres Pérez', style: TextStyle(fontSize: 30)),
              const Text('Has pulsado el botón tantas veces:', style: TextStyle(fontSize: 20)),
              Text(
                '$counter',
                style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FloatingActionButton(
                  onPressed: buttonReset,
                  tooltip: 'Reiniciar',
                  backgroundColor: Colors.orangeAccent,
                  child: const Icon(Icons.refresh),
                ),
                const SizedBox(height: 10),
                FloatingActionButton(
                  onPressed: decrementCounter,
                  tooltip: 'Restar',
                  backgroundColor: Colors.orangeAccent,
                  child: const Icon(Icons.remove),
                ),
                const SizedBox(height: 10),
                FloatingActionButton(
                  onPressed: incrementCounter,
                  tooltip: 'Sumar',
                  backgroundColor: Colors.orangeAccent,
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}


class PaginaLista extends StatefulWidget {
  const PaginaLista({super.key});

  @override
  State<PaginaLista> createState() => _PaginaListaState();
}

class _PaginaListaState extends State<PaginaLista> {
  List<dynamic> elementos = [];

  @override
  void initState() {
    super.initState();
    cargarDatos();
  }

  Future<void> cargarDatos() async {
    final String jsonString = await rootBundle.loadString('assets/datos_lista.json');
    final List<dynamic> jsonData = json.decode(jsonString);
    setState(() {
      elementos = jsonData;
    });
  }

  IconData obtenerIcono(String nombreIcono) {
    switch (nombreIcono) {
      case 'mail':
        return Icons.mail;
      case 'details':
        return Icons.details;
      case 'location_on':
        return Icons.location_on;
      case 'account_circle':
        return Icons.account_circle;
      case 'settings':
        return Icons.settings;
      case 'info':
        return Icons.info;
      case 'help_outline':
        return Icons.help_outline;
      default:
        return Icons.help;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: elementos.isEmpty
          ? const CircularProgressIndicator()
          : ListView.builder(
              shrinkWrap: true,
              itemCount: elementos.length,
              itemBuilder: (context, index) {
                final item = elementos[index];
                return ListTile(
                  leading: Icon(obtenerIcono(item['icon'])),
                  title: Text(item['title']),
                );
              },
            ),
    );
  }
}


class PaginaCard extends StatelessWidget {
  const PaginaCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 600, 
        height: 200,
        child: Card(
          margin: const EdgeInsets.all(8),
          color: const Color.fromARGB(255, 255, 200, 127),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const ListTile(
                leading: Icon(Icons.map_sharp, size: 50),
                title: Text('Amsterdam', style: TextStyle(fontSize: 24)),
                subtitle: Text('Países Bajos'),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Amsterdam es la capital de los Países Bajos, conocida por sus canales, museos y arquitectura histórica. Es una ciudad vibrante y multicultural que atrae a millones de turistas cada año.',
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PaginaGrid extends StatelessWidget {
  const PaginaGrid({super.key});

  final List<String> imagesList = const [
    'https://cdn.pixabay.com/photo/2021/12/12/18/04/mountains-6865752_1280.jpg',
    'https://cdn.pixabay.com/photo/2021/12/12/17/40/mountains-6865680_1280.jpg',
    'https://cdn.pixabay.com/photo/2021/01/23/16/32/mountainous-5942962_1280.jpg',
    'https://cdn.pixabay.com/photo/2023/04/03/18/35/nature-7897648_1280.jpg',
    'https://cdn.pixabay.com/photo/2019/12/08/16/00/nature-4681448_1280.jpg',
    'https://cdn.pixabay.com/photo/2016/09/08/13/58/desert-1654439_1280.jpg',
    'https://cdn.pixabay.com/photo/2023/03/29/15/21/riverbank-7885727_1280.jpg',
    'https://cdn.pixabay.com/photo/2023/02/08/17/55/mountains-7777164_1280.jpg',
    'https://cdn.pixabay.com/photo/2023/02/08/17/55/mountains-7777164_1280.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 480,
        child: GridView.builder(
          shrinkWrap: true,
          itemCount: imagesList.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
          ),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => _DetalleImagenPage(
                      imageUrl: imagesList[index],
                      description: 'Imagen #${index + 1}',
                    ),
                  ),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imagesList[index],
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Pantalla de detalle dentro del mismo archivo
class _DetalleImagenPage extends StatelessWidget {
  final String imageUrl;
  final String description;

  const _DetalleImagenPage({
    required this.imageUrl,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de Imagen'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: InteractiveViewer(
                child: Image.network(imageUrl),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              description,
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}

  