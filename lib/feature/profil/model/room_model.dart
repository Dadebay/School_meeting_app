class RoomModel {
  final String roomName;
  final bool isOccupied;
  final String currentMeeting;
  final String subject;

  RoomModel({
    required this.roomName,
    required this.isOccupied,
    required this.currentMeeting,
    required this.subject,
  });

  static List<RoomModel> generateRooms() {
    return [
      RoomModel(roomName: 'Classroom 101', isOccupied: true, currentMeeting: 'Meeting A', subject: 'Mathematics'),
      RoomModel(roomName: 'Classroom 102', isOccupied: false, currentMeeting: '', subject: ''),
      RoomModel(roomName: 'Classroom 103', isOccupied: true, currentMeeting: 'Meeting B', subject: 'Science'),
      RoomModel(roomName: 'Classroom 104', isOccupied: false, currentMeeting: '', subject: ''),
      RoomModel(roomName: 'Classroom 105', isOccupied: true, currentMeeting: 'Meeting C', subject: 'History'),
      RoomModel(roomName: 'Classroom 106', isOccupied: false, currentMeeting: '', subject: ''),
      RoomModel(roomName: 'Classroom 107', isOccupied: true, currentMeeting: 'Meeting D', subject: 'English'),
      RoomModel(roomName: 'Classroom 108', isOccupied: false, currentMeeting: '', subject: ''),
      RoomModel(roomName: 'Classroom 109', isOccupied: true, currentMeeting: 'Meeting E', subject: 'Geography'),
      RoomModel(roomName: 'Classroom 110', isOccupied: false, currentMeeting: '', subject: ''),
    ];
  }
}
