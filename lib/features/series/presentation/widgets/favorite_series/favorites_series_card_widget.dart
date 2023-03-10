import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:tv_series/features/core/utils/custom_colors.dart';
import 'package:tv_series/features/core/utils/text_styles.dart';
import 'package:tv_series/features/core/utils/utils.dart';
import 'package:tv_series/features/series/domain/entities/series.dart';
import 'package:tv_series/features/series/presentation/widgets/widgets.dart';

Widget favoritesSeriesCard(
    List<Series> series, BuildContext context, int index) {
  double imageHeight = 180;
  double imageWidth = 130;
  double addedDimensionsX = 28;
  double addedDimensionsY = 38;
  bool showDivider = _shouldShow(index);
  return Stack(
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              customShaderMask(
                  bottomFade: 0.9,
                  child: Container(
                    height: imageHeight + addedDimensionsY,
                    width: imageWidth + addedDimensionsX,
                    decoration: setDecoration(series[index].posterPath),
                    child: ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: CustomColors.black.withOpacity(0.4)),
                        ),
                      ),
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.only(top: 14.0, bottom: 14.0),
                child: Container(
                  height: imageHeight,
                  width: imageWidth,
                  decoration: setDecoration(series[index].posterPath),
                ),
              ),
            ],
          ),
          const SizedBox(
            width: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 18),
                  child: SizedBox(
                    width: 170,
                    child: Text(
                      series[index].name,
                      maxLines: 2,
                      style: CustomTextStyles.gilroyLightTitle
                          .copyWith(fontSize: 18),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                RatingBar.builder(
                  initialRating: series[index].voteAverage / 2,
                  minRating: 1,
                  direction: Axis.horizontal,
                  itemCount: 5,
                  ignoreGestures: true,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                  unratedColor: CustomColors.darkGray,
                  itemSize: 11,
                  allowHalfRating: true,
                  itemBuilder: (context, _) => const Icon(
                    Icons.star_outlined,
                    color: CustomColors.lightGray,
                  ),
                  onRatingUpdate: (double value) {},
                ),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Text(
                    'IMDb: ${series[index].voteAverage}',
                    style: CustomTextStyles.gilroyLight
                        .copyWith(color: CustomColors.darkGray, fontSize: 12),
                  ),
                ),
                SizedBox(
                  width: 180,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildWatchButton(
                          context: context,
                          fontSize: 14,
                          width: 100,
                          showId: series[index].id),
                      AddToFavorites(
                          context: context, series: series[index], isDark: true)
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      if (showDivider)
        Positioned(
          left: MediaQuery.of(context).size.width * 0.04,
          bottom: 0,
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.92,
              height: 2,
              color: CustomColors.darkGraySemiTransparent,
            ),
          ),
        )
    ],
  );
}

bool _shouldShow(int index) {
  if (Utils.favoriteSeries.length == 1 ||
      index == Utils.favoriteSeries.length - 1) return false;
  return true;
}

BoxDecoration setDecoration(String? imgPath) {
  if (imgPath == null) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(8.0),
      color: CustomColors.black,
    );
  } else {
    return BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        image:
            DecorationImage(image: NetworkImage(imgPath), fit: BoxFit.cover));
  }
}
