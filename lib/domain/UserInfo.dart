class UserInfo {
  final String facilityName;
  final String userName;
  final String protectorName;
  final String userRole;
  final String user_id;

  const UserInfo({
    required this.facilityName,
    required this.userName,
    required this.protectorName,
    required this.userRole,
    required this.user_id,

  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
        facilityName: json['facility_name'],
        userName: json['user_name'],
        protectorName: json['user_protector_name'],
        userRole: json['userRole'],
        user_id: json['user_id']
    );
  }
}
