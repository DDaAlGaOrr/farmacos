import 'package:farmacos_el_bueno/main.dart';
import 'package:farmacos_el_bueno/views/detailScreen.dart';
import 'package:flutter/material.dart';

class searchFarmacos extends SearchDelegate<Farmaco> {
  final List<Farmaco> farmacos;
  List<Farmaco> _filter = [];

  searchFarmacos(this.farmacos);

  @override
  List<Widget>? buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(
          onPressed: () {
            query = "";
          },
          icon: const Icon(Icons.close))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    IconButton(
        onPressed: () {
          close(
              context,
              Farmaco(
                  id: 0,
                  farmaco: '',
                  mecanismo: '',
                  url: '',
                  efecto: '',
                  // recomendaciones: '',
                  id_grupo: 0,
                  estatus: 0));
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return Center();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    _filter = farmacos.where((farmaco) {
      return farmaco.farmaco.toLowerCase().contains(query.trim().toLowerCase());
    }).toList();
    return ListView.builder(
      itemCount: _filter.length,
      itemBuilder: (ctx, index) => ListTile(
        // title: Text(snapshot.data[index].title),
        title: Text(_filter[index].farmaco),
        onTap: () {
          Navigator.push(
              ctx,
              MaterialPageRoute(
                  builder: (ctx) => detailScreen(farmaco: _filter[index])));
        },
      ),
    );
  }
}
