class NewsModel {
  final String title;
  final String description;
  final String date;
  final String image;

  NewsModel({required this.title, required this.description, required this.date, required this.image});

  static List<NewsModel> generateNews() {
    return [
      NewsModel(
          title: "Pioneering School in STEM Education: Tech High School", description: "Tech High School has opened a new STEM lab for students. This lab offers hands-on education in science, technology, engineering, and mathematics.", date: "20 Feb 2025", image: "assets/images/pattern_1.png"),
      NewsModel(
          title: "Art Festival Kicks Off: Lincoln High School",
          description: "Lincoln High School is hosting its annual art festival. Students will showcase their talents in various art forms including painting, sculpture, music, and drama.",
          date: "20 Feb 2025",
          image: "assets/images/pattern_2.png"),
      NewsModel(
          title: "Sports Achievements: Oakridge High School", description: "Oakridge High School's basketball team has won the state championship. The team is the pride of the school with their outstanding performance and sportsmanship.", date: "20 Feb 2025", image: "assets/images/pattern_3.png"),
      NewsModel(
          title: "School Garden Project: Green Valley Elementary",
          description: "Green Valley Elementary students have started a school garden project to raise environmental awareness. Students will grow vegetables and flowers, getting closer to nature.",
          date: "20 Feb 2025",
          image: "assets/images/pattern_1.png"),
      NewsModel(title: "Coding Marathon: Central Middle School", description: "Central Middle School hosted a coding marathon for students. Students competed to showcase their software development skills and win prizes.", date: "20 Feb 2025", image: "assets/images/pattern_2.png"),
      NewsModel(title: "Theatre Performance: Riverdale High School", description: "Riverdale High School's drama club staged a classic play 'Hamlet'. The students' performance was highly praised.", date: "20 Feb 2025", image: "assets/images/pattern_2.png"),
      NewsModel(title: "Science Fair: Northside High School", description: "Northside High School held its annual science fair. Students showcased various science projects and inventions, demonstrating their creativity.", date: "20 Feb 2025", image: "assets/images/pattern_3.png"),
      NewsModel(title: "Music Competition: Harmony Elementary", description: "Students at Harmony Elementary showcased their talents in a music competition. Winners earned the right to participate in the regional music festival.", date: "20 Feb 2025", image: "assets/images/pattern_1.png"),
      NewsModel(
          title: "Social Responsibility Project: Eastwood High School",
          description: "Eastwood High School students organized a fundraising campaign for a local animal shelter. The donations collected will be used to meet the shelter's needs.",
          date: "20 Feb 2025",
          image: "assets/images/pattern_2.png"),
      NewsModel(
          title: "Language Club Event: Westside Middle School",
          description: "Westside Middle School's language club organized an event to introduce different cultures. Students presented foods, clothes, and traditions from various countries.",
          date: "20 Feb 2025",
          image: "assets/images/pattern_3.png")
    ];
  }
}
