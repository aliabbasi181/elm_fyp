class UserLocationModel {
  String? lat;
  String? lng;
  String? time;
  bool? inFence;

  UserLocationModel({this.lat, this.lng, this.time, this.inFence});

  UserLocationModel.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
    time = json['time'];
    inFence = json['inFence'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['time'] = this.time;
    data['inFence'] = this.inFence;
    return data;
  }
}

class EmployeeLocationModel {
  List<Locations>? locations;
  String? sId;
  String? employee;
  String? fence;
  String? assignFenceId;
  String? date;

  EmployeeLocationModel(
      {this.locations,
      this.sId,
      this.employee,
      this.fence,
      this.assignFenceId,
      this.date});

  EmployeeLocationModel.fromJson(Map<String, dynamic> json) {
    if (json['locations'] != null) {
      locations = <Locations>[];
      json['locations'].forEach((v) {
        locations!.add(new Locations.fromJson(v));
      });
    }
    sId = json['_id'];
    employee = json['employee'];
    fence = json['fence'];
    assignFenceId = json['assignFenceId'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.locations != null) {
      data['locations'] = this.locations!.map((v) => v.toJson()).toList();
    }
    data['_id'] = this.sId;
    data['employee'] = this.employee;
    data['fence'] = this.fence;
    data['assignFenceId'] = this.assignFenceId;
    data['date'] = this.date;
    return data;
  }
}

class Locations {
  String? lat;
  String? lng;
  String? time;
  bool? inFence;

  Locations({this.lat, this.lng, this.time, this.inFence});

  Locations.fromJson(Map<String, dynamic> json) {
    lat = json['lat'].toString();
    lng = json['lng'].toString();
    time = json['time'].toString();
    inFence = json['inFence'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['time'] = this.time;
    data['inFence'] = this.inFence;
    return data;
  }
}
