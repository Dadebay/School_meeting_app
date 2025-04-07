import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:okul_com_tm/feature/profil/components/page_buttons.dart';
import 'package:okul_com_tm/feature/profil/components/sliver_app_bar.dart';
import 'package:okul_com_tm/product/widgets/index.dart';

@RoutePage()
class UserProfilView extends ConsumerWidget {
  const UserProfilView({
    super.key,
    required this.isTeacher,
    required this.isLoggedIn,
  });
  final bool isTeacher;
  final bool isLoggedIn;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          ProfilSliverAppBar(
            innerBoxIsScrolled: innerBoxIsScrolled,
            isTeacher: isTeacher,
            isLoggedIn: isLoggedIn,
          ),
        ];
      },
      body: PageButtons(isTeacher: isTeacher, isLoggedIN: isLoggedIn),
    );
  }
}
