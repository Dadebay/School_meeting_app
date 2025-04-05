import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:okul_com_tm/product/init/language/locale_keys.g.dart';
import 'package:okul_com_tm/product/widgets/index.dart';

class CustomWidgets {
  static Center loader() {
    return Center(child: Lottie.asset(IconConstants.loader, width: 150, height: 150, animate: true));
  }

  static bool compareTime(String timeString) {
    DateTime givenTime = DateTime.parse(timeString); // String'i DateTime'a çevir
    DateTime now = DateTime.now(); // Şu anki zamanı al
    if (givenTime.isBefore(now)) {
      return true;
    } else if (givenTime.isAfter(now)) {
      return false;
    } else {
      return false;
    }
  }

  static Center errorFetchData(BuildContext context) {
    return Center(
        child: Padding(
      padding: context.padding.normal,
      child: Column(
        children: [
          Image.asset(IconConstants.noLessons, width: 250, height: 250),
          Padding(
            padding: context.padding.verticalNormal,
            child: Text(
              LocaleKeys.lessons_not_found,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.general.textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
            ).tr(),
          ),
          Text(
            LocaleKeys.lessons_not_found_subtitle,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: context.general.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w500, fontSize: 20, color: ColorConstants.greyColor),
          ).tr(),
        ],
      ),
    ));
  }

  static Center emptyData(BuildContext context) {
    return Center(
        child: Padding(
      padding: context.padding.normal,
      child: Column(
        children: [
          Image.asset(IconConstants.noLessons, width: 250, height: 250),
          Padding(
            padding: context.padding.verticalNormal,
            child: Text(
              LocaleKeys.general_emptyData,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.general.textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
            ).tr(),
          ),
          Text(
            LocaleKeys.general_emptyDataSubtitle,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: context.general.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w500, fontSize: 20, color: ColorConstants.greyColor),
          ).tr(),
        ],
      ),
    ));
  }

  static Widget pageLocked(BuildContext context) {
    return Container(
      color: ColorConstants.whiteColor.withOpacity(.6),
      padding: context.padding.normal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(IconlyLight.lock, size: 250, color: ColorConstants.blackColor),
          Padding(
            padding: context.padding.verticalNormal,
            child: Text(
              "Page locked",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.general.textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold, color: ColorConstants.blackColor),
            ).tr(),
          ),
          Text(
            "If you want to open this page please LOGIN the app",
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: context.general.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w500, fontSize: 20, color: ColorConstants.blackColor),
          ).tr(),
        ],
      ),
    );
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
              LocaleKeys.lessons_not_found,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.general.textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
            ).tr(),
          ),
          Text(
            LocaleKeys.lessons_not_found_subtitle,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: context.general.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w500, fontSize: 20, color: ColorConstants.greyColor),
          ).tr(),
        ],
      ),
    ));
  }

  static Widget imageWidget(String? url, bool fit) {
    if (url == null || url.isEmpty) {
      return imagePlaceHolder();
    }
    final imageUrl = ApiConstants.imageURL + url;
    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: fit ? null : BoxFit.cover,
          ),
        ),
      ),
      placeholder: (context, url) => loader(),
      errorWidget: (context, url, error) {
        return imagePlaceHolder();
      },
    );
  }

  static ClipRRect imagePlaceHolder() => ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.asset(IconConstants.noImage, fit: BoxFit.cover));
}

class CustomSnackbar {
  static void showCustomSnackbar(BuildContext context, String title, String subtitle, Color color) {
    final messenger = ScaffoldMessenger.of(context);

    messenger.hideCurrentSnackBar();

    messenger.showSnackBar(
      SnackBar(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title.tr(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
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
