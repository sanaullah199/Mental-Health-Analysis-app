class UserModel {
  final String uuid;
  final String name;
  final String email;
  final String profileImage;

  UserModel({
    required this.uuid,
    required this.name,
    required this.email,
    required this.profileImage,
  });

  // Factory constructor to create UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uuid: json['uuid'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      profileImage: json['profileImage'] ?? '',
    );
  }

  // Convert UserModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'name': name,
      'email': email,
      'profileImage': profileImage,
    };
  }
}
