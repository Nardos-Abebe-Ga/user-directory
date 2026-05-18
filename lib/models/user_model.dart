class UserModel {

  final int? id;
  final String name;
  final String email;
  final String phone;
  final String company;

  UserModel({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.company,
  });

  factory UserModel.fromJson(
      Map<String, dynamic> json) {

    return UserModel(
      id: json['id'],
      name: '${json['firstName']} ${json['lastName']}',
      email: json['email'],
      phone: json['phone'],
      company: json['company']['title'],
    );
  }

  Map<String, dynamic> toJson() {

    return {
      'name': name,
      'email': email,
      'phone': phone,
      'company': {
        'title': company,
      },
    };
  }
}