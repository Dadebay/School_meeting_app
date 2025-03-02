import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:lottie/lottie.dart';
import 'package:okul_com_tm/product/constants/api_constants.dart';
import 'package:okul_com_tm/product/constants/index.dart';

class CustomWidgets {
  static Center loader() {
    return Center(child: Lottie.asset(IconConstants.loader, width: 150, height: 150, animate: true));
  }

  static Center errorFetchData() {
    return Center(child: Text("Error fetching data"));
  }

  static Center emptyData() {
    return Center(child: Text("No data available"));
  }

  static Center emptyLessons(BuildContext context) {
    return Center(
        child: Padding(
      padding: context.padding.normal,
      child: Column(
        children: [
          Lottie.asset(IconConstants.loader, width: 250, height: 250, animate: true),
          Padding(
            padding: context.padding.verticalNormal,
            child: Text(
              "Lessons not found",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.general.textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Text(
            "Please try again later, In this date we dont have any lessons",
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: context.general.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w500, fontSize: 20, color: ColorConstants.greyColor),
          ),
        ],
      ),
    ));
  }

  static Widget imageWidget(String url) {
    return CachedNetworkImage(
      imageUrl: ApiConstants.imageURL + url,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
        ),
      ),
      placeholder: (context, url) => loader(),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}
