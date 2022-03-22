class EmployeeModel {
  bool? isConfirmed;
  bool? status;
  String? sId;
  String? name;
  String? email;
  String? password;
  String? cnic;
  String? role;
  String? phone;
  String? designation;
  String? confirmOTP;
  String? user;
  String? createdAt;
  String? updatedAt;

  EmployeeModel(
      {this.isConfirmed,
      this.status,
      this.sId,
      this.name,
      this.email,
      this.password,
      this.cnic,
      this.role,
      this.phone,
      this.designation,
      this.confirmOTP,
      this.user,
      this.createdAt,
      this.updatedAt});

  EmployeeModel.fromJson(Map<String, dynamic> json) {
    isConfirmed = json['isConfirmed'];
    status = json['status'];
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    cnic = json['cnic'];
    role = json['role'];
    phone = json['phone'];
    designation = json['designation'];
    confirmOTP = json['confirmOTP'];
    user = json['user'];
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
    data['cnic'] = this.cnic;
    data['role'] = this.role;
    data['phone'] = this.phone;
    data['designation'] = this.designation;
    data['confirmOTP'] = this.confirmOTP;
    data['user'] = this.user;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
