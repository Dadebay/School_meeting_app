import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:okul_com_tm/product/widgets/index.dart';

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
          Image.asset(IconConstants.noLessons, width: 250, height: 250),
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

class CustomSnackbar {
  static void showCustomSnackbar(BuildContext context, String title, String subtitle, Color color) {
    final messenger = ScaffoldMessenger.of(context);

    // Önce var olan SnackBar'ı kaldır
    messenger.hideCurrentSnackBar();

    // Yeni SnackBar'ı göster
    messenger.showSnackBar(
      SnackBar(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title.isNotEmpty)
              Text(
                title.tr(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            if (subtitle.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  subtitle.tr(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Daha yuvarlak kenarlar için
        ),
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(10), // Varsayılan padding yerine sabit bir boşluk
      ),
    );
  }
}
