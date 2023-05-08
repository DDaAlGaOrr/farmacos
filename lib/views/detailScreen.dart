import 'package:flutter/material.dart';
import '../main.dart';

class Item {
  Item({
    required this.headerText,
    required this.expandedText,
    this.isExpanded = false,
  });
  String headerText;
  String expandedText;
  bool isExpanded;
}

class detailScreen extends StatefulWidget {
  final Farmaco farmaco;

  detailScreen({required this.farmaco}) : super();
  @override
  State<detailScreen> createState() => _detailScreenState();
}

class _detailScreenState extends State<detailScreen> {
  final List<Item> _data = [];
  @override
  void initState() {
    _data.add(
        Item(headerText: 'Mecanismo', expandedText: widget.farmaco.mecanismo));
    _data.add(Item(headerText: 'Efecto', expandedText: widget.farmaco.efecto));
    // _data.add(Item(
    //     headerText: 'Recomendaciones',
    //     expandedText: widget.farmaco.recomendaciones));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(canvasColor: Color(0xFFC8DDC8)),
      title: 'titulo',
      home: (Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.green,
            title: Text(widget.farmaco.farmaco),
            leading: IconButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (ctx) => MyApp()));
              },
              icon: const Icon(Icons.arrow_back),
            ),
          ),
          body: Column(
            children: [
              Container(
                child: Card(
                  child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Image.network(widget.farmaco.url)),
                ),
              ),
              Container(
                // height: double.infinity,
                // height: 150,
                width: MediaQuery.of(context).size.width - 10,
                child: Card(
                  // color: Colors.green[800],
                  color: Color.fromARGB(255, 108, 155, 94),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Text(
                            'Grupo',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            widget.farmaco.farmaco,
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ],
                      )),
                ),
              ),
              Container(
                padding: EdgeInsets.all(5.0),
                child: ExpansionPanelList(
                  expansionCallback: (int index, bool isExpanded) {
                    setState(() {
                      _data[index].isExpanded = !isExpanded;
                    });
                  },
                  children: _data.map<ExpansionPanel>((Item item) {
                    return ExpansionPanel(
                        backgroundColor: Color.fromARGB(255, 69, 122, 56),
                        headerBuilder: (BuildContext context, bool isExpanded) {
                          return ListTile(
                            title: Text(item.headerText),
                            textColor: Colors.white,
                          );
                        },
                        body: ListTile(
                          title: Text(item.expandedText),
                          textColor: Colors.white,
                        ),
                        isExpanded: item.isExpanded);
                  }).toList(),
                ),
              )
            ],
          ))),
    );
  }
}
