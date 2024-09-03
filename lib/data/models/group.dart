
class Group {

  final String name;
  final String description;

  Group({

    required this.name,
    required this.description,
  });

  factory Group.fromJson(Map<String, dynamic> json){
    return Group(
      name: json['name'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return{
      'name':name,
      'description':description
    };
  }
}
