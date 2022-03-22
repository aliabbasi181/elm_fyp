class OrganizationModel {
  bool? isConfirmed;
  bool? status;
  String? sId;
  String? name;
  String? email;
  String? password;
  String? address;
  String? role;
  String? phone;
  String? confirmOTP;
  String? createdAt;
  String? updatedAt;

  OrganizationModel(
      {this.isConfirmed,
      this.status,
      this.sId,
      this.name,
      this.email,
      this.password,
      this.address,
      this.role,
      this.phone,
      this.confirmOTP,
      this.createdAt,
      this.updatedAt});

  OrganizationModel.fromJson(Map<String, dynamic> json) {
    isConfirmed = json['isConfirmed'];
    status = json['status'];
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    address = json['address'];
    role = json['role'];
    phone = json['phone'];
    confirmOTP = json['confirmOTP'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isConfirmed'] = this.isConfirmed;
    data['status'] = this.status;
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['password'] = this.password;
    data['address'] = this.address;
    data['role'] = this.role;
    data['phone'] = this.phone;
    data['confirmOTP'] = this.confirmOTP;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
