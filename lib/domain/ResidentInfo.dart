class ResidentInfo {
  final int resident_id;
  final int facility_id;
  final String facility_name;
  final String resident_name;
  final String userRole;
  final int approved;

  const ResidentInfo({
    required this.resident_id,
    required this.facility_id,
    required this.facility_name,
    required this.resident_name,
    required this.userRole,
    required this.approved
  });
  //Json형식의 데이터를 받아서 객체에 저장
  factory ResidentInfo.fromJson(Map<String, dynamic> json) {
    return ResidentInfo(
        resident_id: json['resident_id'],
        facility_id: json['facility_id'],
        facility_name: json['facility_name'],
        resident_name: json['resident_name'],
        userRole: json['userRole'],
        approved: json['is_approved']
    );
  }
}
