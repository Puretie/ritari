import 'package:Ritari/addscreen.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:tinycolor/tinycolor.dart';

class Storage extends HiveObject {
  static Box b;
  static Future<void> init() async => b = await Hive.openBox('myNotes');
}

void main() {
  Storage.init().then((value) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  MaterialColor myColor(Color c) {
    return MaterialColor(c.value, {
      50: c,
      100: c,
      200: c,
      300: c,
      400: c,
      500: c,
      600: c,
      700: c,
      800: c,
      900: c,
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dutter Flemo',
      theme: ThemeData(
        primarySwatch: myColor(Colors.teal.shade800),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String title = "Some Text";
  static const int CARD_WIDTH = 300;
  static const int CARD_HEIGHT = 200;
  @override
  Widget build(BuildContext context) {
    int count = MediaQuery.of(context).size.width ~/ CARD_WIDTH;
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Stack(
        children: [
          GridView.builder(
              itemCount: Storage.b.keys.length,
              cacheExtent: 100,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: CARD_WIDTH / CARD_HEIGHT,
                crossAxisCount: count,
              ),
              itemBuilder: (context, pos) {
                int time = int.tryParse(Storage.b.keys.toList()[pos]) ?? 0;
                String value = Storage.b.get(time.toString()) ?? "null text";
                String shortValue = value.replaceAll("\n", " ");
                shortValue = shortValue.length > 256
                    ? (shortValue.substring(0, 255) + "...")
                    : shortValue;
                shortValue = shortValue.trim();
                return SizedBox(
                  child: Padding(
                    padding: EdgeInsets.all(4),
                    child: Material(
                      child: ClipRRect(
                        child: Container(
                          child: Padding(
                            padding: EdgeInsets.all(7),
                            child: Material(
                              color: Colors.transparent,
                              child: ListTile(
                                  title: Text("$time"),
                                  subtitle: Text(shortValue),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => NewScreen(
                                                  k: time.toString(),
                                                  value: value,
                                                ))).then((value) {
                                      setState(() {
                                        if (value == null) {
                                          return;
                                        }
                                        List<String> l = value;
                                        Storage.b.put(
                                            l[0].isEmpty
                                                ? DateTime.now()
                                                    .millisecondsSinceEpoch
                                                    .toString()
                                                : l[0],
                                            l[1] ?? "null");
                                      });
                                    });
                                  },
                                  onLongPress: () {
                                    setState(() {
                                      Storage.b.delete(time.toString());
                                    });
                                  }),
                            ),
                          ),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                            colors: <Color>[
                              TinyColor(Colors.teal)
                                  .spin(-13)
                                  .brighten(5)
                                  .color,
                              TinyColor(Colors.teal).spin(-7).brighten(2).color,
                              TinyColor(Colors.teal).spin(0).color,
                              TinyColor(Colors.teal).spin(7).darken(2).color,
                              TinyColor(Colors.teal).spin(13).darken(5).color
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )),
                        ),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      color: Colors.transparent,
                      elevation: 10,
                    ),
                  ),
                );
              }),
          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              backgroundColor: Colors.red,
              onPressed: () {
                Navigator.push(context,
                        MaterialPageRoute(builder: (context) => NewScreen()))
                    .then((value) {
                  if (value == null) {
                    return;
                  }
                  setState(() {
                    List<String> l = value;
                    Storage.b.put(
                        l[0].isEmpty
                            ? DateTime.now().millisecondsSinceEpoch.toString()
                            : l[0],
                        l[1] ?? "null");
                  });
                });
              },
              child: Icon(Icons.add),
            ),
          )
        ],
      ),
    );
  }
}
