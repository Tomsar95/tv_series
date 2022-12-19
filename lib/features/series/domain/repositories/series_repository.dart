import 'package:dartz/dartz.dart';
import 'package:tv_series/features/core/error/failures.dart';
import 'package:tv_series/features/series/domain/entities/series.dart';

abstract class SeriesRepository {
  Future<Either<Failure,List<Series>>> getPopularSeries();
  Future<Either<Failure,List<Series>>> getRecommendedSeries();
  Future<Either<Failure,List<Series>>> getAiringSeries();
  Future<Either<Failure,Series>> getSeriesDetails(int seriesId);
}