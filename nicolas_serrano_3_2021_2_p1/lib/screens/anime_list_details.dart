import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:nicolas_serrano_3_2021_2_p1/components/loader_component.dart';
import 'package:nicolas_serrano_3_2021_2_p1/helpers/api_helper.dart';
import 'package:nicolas_serrano_3_2021_2_p1/models/response.dart';
import 'package:nicolas_serrano_3_2021_2_p1/models/animelistdetail.dart';

class AnimeListDetail extends StatefulWidget {
  final String animeName;

  const AnimeListDetail({required this.animeName});

  @override
  _AnimeListDetailState createState() => _AnimeListDetailState();
}

class _AnimeListDetailState extends State<AnimeListDetail> {
  late AnimeListDetails _animedetails;
  bool _showLoader = false;
  String _animeName = '';

  void initState() {
    super.initState();
    _animeName = widget.animeName;
    _getAnimeDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_animeName),
      ),
      body: Container(
          child: _showLoader
              ? LoaderComponent(
                  text: 'Por favor espere...',
                )
              : Stack(children: <Widget>[
                  _showPhoto(),
                  _getAnimeInfo(),
                ])),
    );
  }

  Future<Null> _getAnimeDetail() async {
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

    Response response = await ApiHelper.getAnimeDetails(_animeName);

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
      _animedetails = response.result;
    });
  }

  Widget _showPhoto() {
    return Stack(children: <Widget>[
      Container(
        // margin: EdgeInsets.only(top: 15,),
        child: _animedetails.img.isEmpty
            ? Image(
                image: AssetImage('assets/anime404.jpg'),
                width: 160,
                height: 160,
              )
            : ClipRRect(
                //borderRadius: BorderRadius.circular(80),
                child: FadeInImage(
                  placeholder: AssetImage('assets/anime404.jpg'),
                  image: NetworkImage(_animedetails.img),
                  width: 700,
                  height: 200,
                  // fit: BoxFit.cover,
                ),
              ),
      ),
    ]);
  }

  Widget _getAnimeInfo() {
    return RefreshIndicator(
      onRefresh: _getAnimeDetail,
      child: ListView(
        children: _animedetails.data.map((e) {
          return Card(
            child: InkWell(
              child: Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(5),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  e.fact,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }  

}
