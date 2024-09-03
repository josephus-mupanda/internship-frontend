class Member{
  final int userId;
  final int groupId;
  final String? roleType;
  final bool? isActive;

    Member({
      this.roleType,
      this.isActive,
      required this.userId,
      required this.groupId
    });

    factory Member.fromJson(Map<String,dynamic> json){
      return Member(
          userId: json['userId'],
          groupId: json['groupId'],
        roleType: json['roleType'],
        isActive: json['isActive']
      );
    }

    Map<String,dynamic> toJson(){
      return{
        'userId':userId,
        'groupId':groupId,
        'roleType':roleType,
        'isActive':isActive
      };
    }
}