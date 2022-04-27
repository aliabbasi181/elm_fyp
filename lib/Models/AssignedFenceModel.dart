class AssignedFenceModel {
  String? sId;
  String? employee;
  String? region;
  String? dateFrom;
  String? dateTo;
  String? startTime;
  String? endTime;
  String? user;
  String? createdAt;
  String? updatedAt;
  int? iV;

  AssignedFenceModel(
      {this.sId,
      this.employee,
      this.region,
      this.dateFrom,
      this.dateTo,
      this.startTime,
      this.endTime,
      this.user,
      this.createdAt,
      this.updatedAt,
      this.iV});

  AssignedFenceModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    employee = json['employee'];
    region = json['region'];
    dateFrom = json['dateFrom'];
    dateTo = json['dateTo'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    user = json['user'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['employee'] = this.employee;
    data['region'] = this.region;
    data['dateFrom'] = this.dateFrom;
    data['dateTo'] = this.dateTo;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['user'] = this.user;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
