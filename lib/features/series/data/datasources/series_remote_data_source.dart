import 'dart:convert';

import 'package:tv_series/features/core/error/exceptions.dart';
import 'package:tv_series/features/core/utils/utils.dart';
import 'package:tv_series/features/series/data/models/episode_model.dart';
import 'package:tv_series/features/series/data/models/series_model.dart';
import 'package:tv_series/features/series/domain/entities/episode.dart';
import 'package:tv_series/features/series/domain/entities/series.dart';
import 'package:http/http.dart' as http;

abstract class SeriesRemoteDataSource {

  Future<List<Series>> getPopularSeries();

  Future<List<Series>> getRecommendedSeries();

  Future<List<Series>> getAiringSeries();

  Future<Series> getSeriesDetails(int seriesId);

  Future<List<Episode>> getEpisodes(int seriesId, int seasonNumber);

  Future<Episode> getEpisode(int seriesId, int seasonNumber, int episodeNumber);

}

class SeriesRemoteDataSourceImpl implements SeriesRemoteDataSource {
  final http.Client client;

  SeriesRemoteDataSourceImpl({required this.client});

  @override
  Future<List<Series>> getPopularSeries() {
    return _getSeriesFromUrl('${Utils.root}/tv/popular?api_key=${Utils.apiKey}&language=en-US&page=1}');
  }

  @override
  Future<List<Series>> getRecommendedSeries() {
    return _getSeriesFromUrl('${Utils.root}/tv/top_rated?api_key=${Utils.apiKey}&language=en-US&page=1}');
  }

  @override
  Future<List<Series>> getAiringSeries() {
    return _getSeriesFromUrl('${Utils.root}/tv/airing_today?api_key=${Utils.apiKey}&language=en-US&page=1}');
  }

  @override
  Future<Series> getSeriesDetails(int seriesId) {
    return _getSeriesDetailsFromUrl('${Utils.root}/tv/$seriesId?api_key=${Utils.apiKey}&language=en-US&page=1}');
  }

  @override
  Future<List<Episode>> getEpisodes(int seriesId, int seasonNumber) {
    return _getEpisodesFromUrl('${Utils.root}/tv/$seriesId/season/$seasonNumber?api_key=${Utils.apiKey}&language=en-US&page=1}');
  }

  @override
  Future<Episode> getEpisode(int seriesId, int seasonNumber, int episodeNumber) {
    return _getEpisodeFromUrl('${Utils.root}/tv/$seriesId/season/$seasonNumber/episode/$episodeNumber?api_key=${Utils.apiKey}&language=en-US&page=1}');
  }

  Future<List<EpisodeModel>> _getEpisodesFromUrl(String url) async{
    final response = await client.get(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );
    if(response.statusCode == 200){
      final Map<String, dynamic> jsonMap =
      json.decode(response.body);
      Iterable i = jsonMap['episodes'];
      return i.map((episode) => EpisodeModel.fromJson(episode)).toList().reversed.toList();
    } else {
      throw ServerException('Bad Status Code');
    }
  }

  Future<EpisodeModel> _getEpisodeFromUrl(String url) async{
    final response = await client.get(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );
    if(response.statusCode == 200){
      final json = jsonDecode(response.body);
      return EpisodeModel.fromJson(json);
    } else {
      throw ServerException('Bad Status Code');
    }
  }

  Future<List<SeriesModel>> _getSeriesFromUrl(String url) async{
    final response = await client.get(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );
    if(response.statusCode == 200){
      final Map<String, dynamic> jsonMap =
      json.decode(response.body);
      Iterable i = jsonMap['results'];
      return i.map((series) => SeriesModel.fromJson(series)).toList();
    } else {
      throw ServerException('Bad Status Code');
    }
  }

  Future<SeriesModel> _getSeriesDetailsFromUrl(String url) async{
    final response = await client.get(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );
    if(response.statusCode == 200){
      final json = jsonDecode(response.body);
      return SeriesModel.fromJson(json);
    } else {
      throw ServerException('Bad Status Code');
    }
  }
}