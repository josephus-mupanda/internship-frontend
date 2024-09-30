
class Group {
  final int? id;
  final String name,description;
  final String? createdBy;
  final bool? isChecked;
  final DateTime? createdAt;
  Group({
    this.id,
    this.createdBy,
    required this.name,
    required this.description,
    this.isChecked,
    this.createdAt
  });

  factory Group.fromJson(Map<String, dynamic> json){
    return Group(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      createdBy: json['createdBy'],
      isChecked: json['isChecked'],
      // createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return{
      'id':id,
      'name':name,
      'description':description,
      'createdBy': createdBy,
      'isChecked': isChecked,
      // 'createdAt': createdAt?.toIso8601String(),
    };
  }
}