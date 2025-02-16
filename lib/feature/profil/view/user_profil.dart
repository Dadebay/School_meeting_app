import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:okul_com_tm/feature/profil/components/page_buttons.dart';
import 'package:okul_com_tm/feature/profil/components/sliver_app_bar.dart';

@RoutePage()
class UserProfilView extends StatelessWidget {
  const UserProfilView({super.key});

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          ProfilSliverAppBar(innerBoxIsScrolled: innerBoxIsScrolled),
        ];
      },
      body: PageButtons(),
    );
  }
}
