
class Group {
  final int? id;
  final String name,description;
  final String? createdBy;
  final bool? isChecked;
  Group({
    this.id,
    this.createdBy,
    required this.name,
    required this.description,
    this.isChecked,
  });

  factory Group.fromJson(Map<String, dynamic> json){
    return Group(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      createdBy: json['createdBy'],
      isChecked: json['isChecked'],
    );
  }

  Map<String, dynamic> toJson() {
    return{
      'id':id,
      'name':name,
      'description':description,
      'createdBy': createdBy,
      'isChecked': isChecked,
    };
  }
}


// final List<Group> groups = List.generate(
//   groupData.length,
//       (index) {
//     final data = groupData[index];
//     return Group(
//       name: data['name'],
//       description: data['description'],
//       createdBy: data['createdBy'],
//       isChecked: data['isChecked'],
//     );
//   },
// );
//
//
// final List<Map<String, dynamic>> groupData = [
//   {
//     'name': 'Book Club',
//     'description': 'A group for book lovers to discuss and share their favorite books.',
//     'createdBy': 'Alice',
//     'isChecked': true,
//   },
//   {
//     'name': 'Cooking Enthusiasts',
//     'description': 'A group to share recipes and cooking tips.',
//     'createdBy': 'Bob',
//     'isChecked': false,
//   },
//   {
//     'name': 'Tech Innovators',
//     'description': 'A group for people interested in the latest technology and gadgets.',
//     'createdBy': 'Charlie',
//     'isChecked': true,
//   },
//   {
//     'name': 'Travel Buddies',
//     'description': 'A group for people who love to travel and explore new places.',
//     'createdBy': 'David',
//     'isChecked': false,
//   },
//   {
//     'name': 'Fitness Fanatics',
//     'description': 'A group for those who are passionate about fitness and healthy living.',
//     'createdBy': 'Eve',
//     'isChecked': true,
//   },
// ];
//
