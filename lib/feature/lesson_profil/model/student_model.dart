class StudentModel {
  StudentModel({
    required this.name,
    required this.surname,
    required this.logo,
    required this.className,
    required this.phoneNumber,
    required this.gmail,
    this.schoolName,
  });

  final String name;
  final String surname;
  final String logo;
  final String className;
  final String phoneNumber;
  final String gmail;
  final String? schoolName;

  static List<StudentModel> generateStudents() {
    return [
      StudentModel(
          name: 'Alice', // English name
          surname: 'Smith', // English surname
          logo: 'assets/icons/user1.png',
          className: '9-A',
          phoneNumber: '+15551234567', // US-style phone number format
          gmail: 'alice.smith@example.com',
          schoolName: "Ataturk High School" //Keeping school names, but they could be translated too.
          ),
      StudentModel(name: 'John', surname: 'Doe', logo: 'assets/icons/user2.png', className: '10-B', phoneNumber: '+15559876543', gmail: 'john.doe@example.com', schoolName: "Ataturk High School"),
      StudentModel(name: 'Emily', surname: 'Brown', logo: 'assets/icons/user3.png', className: '11-C', phoneNumber: '+15551112233', gmail: 'emily.brown@example.com', schoolName: "Science High School"),
      StudentModel(name: 'David', surname: 'Lee', logo: 'assets/icons/user4.png', className: '9-A', phoneNumber: '+15554445566', gmail: 'david.lee@example.com', schoolName: "Anatolian High School"),
      StudentModel(name: 'Sophia', surname: 'Wilson', logo: 'assets/icons/user5.png', className: '10-C', phoneNumber: '+15557778899', gmail: 'sophia.wilson@example.com', schoolName: "Ataturk High School"),
      StudentModel(name: 'Michael', surname: 'Davis', logo: 'assets/icons/user6.png', className: '11-B', phoneNumber: '+15553334455', gmail: 'michael.davis@example.com', schoolName: "Science High School"),
      StudentModel(name: 'Olivia', surname: 'Garcia', logo: 'assets/icons/user7.png', className: '9-B', phoneNumber: '+15556667788', gmail: 'olivia.garcia@example.com', schoolName: "Anatolian High School"),
      StudentModel(name: 'Daniel', surname: 'Rodriguez', logo: 'assets/icons/user8.png', className: '10-A', phoneNumber: '+15559990011', gmail: 'daniel.rodriguez@example.com', schoolName: "Ataturk High School"),
      StudentModel(name: 'Ava', surname: 'Martinez', logo: 'assets/icons/user9.png', className: '11-A', phoneNumber: '+15552223344', gmail: 'ava.martinez@example.com', schoolName: "Science High School"),
      StudentModel(name: 'Ethan', surname: 'Hernandez', logo: 'assets/icons/user10.png', className: '9-C', phoneNumber: '+15558889900', gmail: 'ethan.hernandez@example.com', schoolName: "Anatolian High School"),
    ];
  }
}
