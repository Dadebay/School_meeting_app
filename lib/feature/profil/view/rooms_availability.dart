import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:kartal/kartal.dart';
import 'package:okul_com_tm/feature/profil/model/room_model.dart';
import 'package:okul_com_tm/product/constants/color_constants.dart';

@RoutePage()
class RoomsAvailabilityView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final rooms = RoomModel.generateRooms();

    final availableRooms = rooms.where((room) => !room.isOccupied).toList();
    final occupiedRooms = rooms.where((room) => room.isOccupied).toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: ColorConstants.primaryBlueColor,
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(
                IconlyLight.arrow_left_circle,
                color: ColorConstants.whiteColor,
              )),
          title: Text(
            'Rooms Availability',
            style: context.general.textTheme.headlineMedium!.copyWith(color: ColorConstants.whiteColor, fontWeight: FontWeight.bold),
          ),
          bottom: TabBar(
            unselectedLabelColor: ColorConstants.greyColorwithOpacity,
            labelColor: ColorConstants.whiteColor,
            indicatorColor: ColorConstants.whiteColor,
            indicatorSize: TabBarIndicatorSize.label,
            unselectedLabelStyle: context.general.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
            labelStyle: context.general.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            tabs: [
              Tab(text: 'Available'),
              Tab(text: 'Occupied'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            RoomListView(rooms: availableRooms),
            RoomListView(rooms: occupiedRooms),
          ],
        ),
      ),
    );
  }
}

class RoomListView extends StatelessWidget {
  final List<RoomModel> rooms;

  const RoomListView({required this.rooms, super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: rooms.length,
      padding: context.padding.onlyTopNormal,
      itemBuilder: (context, index) {
        final room = rooms[index];
        return RoomCard(roomModel: room);
      },
    );
  }
}

class RoomCard extends StatelessWidget {
  const RoomCard({required this.roomModel, super.key});
  final RoomModel roomModel;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: context.padding.low,
      elevation: 1,
      color: ColorConstants.whiteColor,
      shape: RoundedRectangleBorder(borderRadius: context.border.normalBorderRadius, side: BorderSide(color: ColorConstants.primaryBlueColor)),
      child: Padding(
        padding: context.padding.normal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  roomModel.roomName,
                  style: context.general.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                roomModel.isOccupied == true
                    ? SizedBox.shrink()
                    : Text(
                        'Available',
                        style: context.general.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
              ],
            ),
            if (roomModel.isOccupied)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: context.padding.verticalLow,
                    child: Text(
                      'Currently Occupied',
                      style: context.general.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  Text(
                    'Meeting: ${roomModel.currentMeeting}',
                    style: context.general.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, color: ColorConstants.greyColor),
                  ),
                  Padding(
                    padding: context.padding.verticalLow,
                    child: Text(
                      'Subject: ${roomModel.subject}',
                      style: context.general.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, color: ColorConstants.greyColor),
                    ),
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }
}
