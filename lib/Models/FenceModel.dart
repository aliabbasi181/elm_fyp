class FenceModel {
  List<Points>? points;
  String? sId;
  String? name;
  String? user;
  String? createdAt;
  String? updatedAt;
  int? iV;

  FenceModel(
      {this.points,
      this.sId,
      this.name,
      this.user,
      this.createdAt,
      this.updatedAt,
      this.iV});

  FenceModel.fromJson(Map<String, dynamic> json) {
    if (json['points'] != null) {
      points = <Points>[];
      json['points'].forEach((v) {
        points!.add(Points.fromJson(v));
      });
    }
    sId = json['_id'];
    name = json['name'];
    user = json['user'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.points != null) {
      data['points'] = this.points!.map((v) => v.toJson()).toList();
    }
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['user'] = this.user;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class Points {
  String? lat;
  String? lng;

  Points({this.lat, this.lng});

  Points.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    return data;
  }
}
