import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:okul_com_tm/feature/home/components/index.dart';
import 'package:okul_com_tm/feature/lesson_profil/service/lessons_service.dart';
import 'package:okul_com_tm/product/sizes/widget_sizes.dart';
import 'package:okul_com_tm/product/widgets/index.dart';

@RoutePage()
class HomeView extends ConsumerStatefulWidget {
  const HomeView({required this.isTeacher});
  final bool isTeacher;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  @override
  void initState() {
    super.initState();
    ref.read(lessonProvider.notifier).fetchLessonsForDate(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    final lessonState = ref.watch(lessonProvider);
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          _sliverAppBar(context),
        ];
      },
      body: lessonState.lessons.isEmpty
          ? CustomWidgets.emptyLessons(context)
          : ListView.builder(
              itemCount: lessonState.lessons.length,
              shrinkWrap: true,
              padding: EdgeInsets.only(bottom: 120),
              itemExtent: MediaQuery.of(context).size.height / 2,
              itemBuilder: (context, index) {
                final lesson = lessonState.lessons[index];
                return LessonCard(
                  lessonModel: lesson,
                  isTeacher: widget.isTeacher,
                );
              },
            ),
    );
  }

  SliverAppBar _sliverAppBar(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      automaticallyImplyLeading: false,
      collapsedHeight: WidgetSizes.collapsedSliverAppBar.value,
      expandedHeight: WidgetSizes.sliverAppBarHeight.value,
      toolbarHeight: WidgetSizes.collapsedSliverAppBar.value,
      elevation: 5,
      scrolledUnderElevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: context.border.highBorderRadius,
      ),
      backgroundColor: ColorConstants.whiteColor,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          borderRadius: context.border.highBorderRadius,
          gradient: const LinearGradient(
            colors: [
              ColorConstants.blueColorwithOpacity,
              ColorConstants.whiteColor,
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: const FlexibleSpaceBar(
          titlePadding: EdgeInsets.zero,
          title: SizedBox.shrink(),
          background: UserNameAndImage(),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(WidgetSizes.calendarSliderWidth.value),
        child: const CalendarSlider(),
      ),
    );
  }
}
