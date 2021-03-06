import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:nicolas_serrano_3_2021_2_p1/components/loader_component.dart';
import 'package:nicolas_serrano_3_2021_2_p1/helpers/api_helper.dart';
import 'package:nicolas_serrano_3_2021_2_p1/models/animelist.dart';
import 'package:nicolas_serrano_3_2021_2_p1/models/response.dart';

import 'anime_list_details.dart';

class AnimeListScreen extends StatefulWidget {
  const AnimeListScreen({Key? key}) : super(key: key);

  @override
  _AnimeListScreenState createState() => _AnimeListScreenState();
}

class _AnimeListScreenState extends State<AnimeListScreen> {
  List<AnimeList> _animes = [];
  bool _showLoader = false;
  String _search = '';
  bool _isFiltered = false;

  @override
  void initState() {
    super.initState();
    _getAnimes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Animes'),
        actions: <Widget>[
          _isFiltered
              ? IconButton(
                  onPressed: _removeFilter, icon: Icon(Icons.filter_none))
              : IconButton(onPressed: _showFilter, icon: Icon(Icons.filter_alt))
        ],
      ),
      body: Center(
        child: _showLoader
            ? LoaderComponent(
                text: 'Por favor espere...',
              )
            : _getContent(),
      ),
    );
  }

  Future<Null> _getAnimes() async {
    setState(() {
      _showLoader = true;
    });

    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _showLoader = false;
      });
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: 'Verifica que estes conectado a internet.',
          actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    Response response = await ApiHelper.getAnimes();

    setState(() {
      _showLoader = false;
    });

    if (!response.isSuccess) {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: response.message,
          actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    setState(() {
      _animes = response.result;
    });
  }

  void _showFilter() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: Text('Filtrar Anime.'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('Escriba las primeras letras del anime.'),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Criterio de busqueda...',
                    labelText: 'Buscar',
                    suffixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) {
                    _search = value;
                  },
                )
              ],
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Cancelar')),
              TextButton(onPressed: () => _filter(), child: Text('Filtrar'))
            ],
          );
        });
  }

  void _removeFilter() {
    setState(() {
      _isFiltered = false;
      _getAnimes();
    });
  }

  void _filter() {
    if (_search.isEmpty) {
      return;
    }
    List<AnimeList> filteredList = [];
    for (var anime in _animes) {
      if (anime.anime_name.toLowerCase().contains(_search.toLowerCase())) {
        filteredList.add(anime);
      }
    }

    setState(() {
      _animes = filteredList;
      _isFiltered = true;
    });

    Navigator.of(context).pop();
  }

  Widget _getContent() {
    return _animes.length == 0 ? _noContent() : _getListView();
  }

  Widget _noContent() {
    return Center(
        child: Container(
      margin: EdgeInsets.all(20),
      child: Text(
        _isFiltered
            ? 'No hay animes con se criterio de busqueda.'
            : 'No hay animes registrados.',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ));
  }

  Widget _getListView() {  
    return RefreshIndicator(
        onRefresh: _getAnimes,
        child: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 1.0,                    
          children: _animes.map((e) {
          return Center(         
            child: InkWell(                                          
              onTap: () => _goDetailAnime(e),              
              child: Container(                
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(5),
                child: Stack(
                  alignment: Alignment.bottomCenter,                     
                  children: [
                    Center(
                      child: Row(                                        
                        children:<Widget> [                                              
                          e.anime_img.isEmpty
                              ? Image(
                                  image: AssetImage('assets/anime404.jpg'),
                                  width: 160,
                                  height: 160,
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: FadeInImage(                                                                                          
                                    placeholder: AssetImage('assets/anime404.jpg'),
                                    image: NetworkImage(e.anime_img),
                                    width: 165,
                                    height: 200,
                                    fit: BoxFit.cover,                              
                                  ),
                                ),   
                        ],  
                      ),
                    ),
                    Container(
                      width: 300,                      
                      child: Card(
                        color: Colors.black54,                      
                        child: Container(
                          child: Text(                        
                            e.anime_name,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,                                    
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }).toList(),
        ),
    );
  }


  void _goDetailAnime(AnimeList animeList) async {
    String? result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AnimeListDetail(
                  animeName: animeList.anime_name,
                )));

    if (result == 'yes') {
      _getAnimes();
    }
  }
}
