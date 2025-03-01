import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:okul_com_tm/product/constants/index.dart';

class CustomWidgets {
  static Center loader() {
    return Center(child: Lottie.asset(IconConstants.loader));
  }

  static Center errorFetchData() {
    return Center(child: Text("Error fetching data"));
  }

  static Center emptyData() {
    return Center(child: Text("No data available"));
  }

  static Widget imageWidget(String url) {
    return CachedNetworkImage(
      imageUrl: url,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: imageProvider, fit: BoxFit.cover, colorFilter: ColorFilter.mode(Colors.red, BlendMode.colorBurn)),
        ),
      ),
      placeholder: (context, url) => loader(),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}
