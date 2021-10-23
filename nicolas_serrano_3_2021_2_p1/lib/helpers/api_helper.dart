import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:nicolas_serrano_3_2021_2_p1/helpers/constans.dart';
import 'package:nicolas_serrano_3_2021_2_p1/models/animelist.dart';
import 'package:nicolas_serrano_3_2021_2_p1/models/animelistdetail.dart';
import 'package:nicolas_serrano_3_2021_2_p1/models/response.dart';

class ApiHelper {
  static Future<Response> getAnimes() async {   
    var url = Uri.parse('${Constans.apiUrlAnime}');
    var response = await http.get(
      url,
      headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',
      },
    );

    var body = response.body;
    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    List<AnimeList> list = [];    
    var decodedJson = jsonDecode(body);
    var jsonResult = decodedJson['data'];
    if (jsonResult != null) {
      for (var item in jsonResult) {
        list.add(AnimeList.fromJson(item));
      }
    }

    return Response(isSuccess: true, result: list);
  }

  static Future<Response> getAnimeDetails(String anime_name) async {    
    var url = Uri.parse('${Constans.apiUrlAnime}/$anime_name');
    var response = await http.get(
      url,
      headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',
      },
    );

    var body = response.body;
    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    var decodedJson = jsonDecode(body);
    return Response(isSuccess: true, result: AnimeListDetails.fromJson(decodedJson));
  }
 
}