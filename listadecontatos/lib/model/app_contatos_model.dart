class AppContatosModel {
  List<AppContatoModel> results = [];

  AppContatosModel(this.results);

  AppContatosModel.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <AppContatoModel>[];
      json['results'].forEach((v) {
        results.add(AppContatoModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['results'] = results.map((v) => v.toJson()).toList();
    return data;
  }
}

class AppContatoModel {
  String? objectId;
  String? nome;
  String? email;
  int? telefone;
  String? createdAt;
  String? updatedAt;
  Photo? image;

  AppContatoModel(
      {this.objectId,
      this.nome,
      this.email,
      this.telefone,
      this.createdAt,
      this.updatedAt,
      this.image});

  AppContatoModel.fromJson(Map<String, dynamic> json) {
    objectId = json['objectId'];
    nome = json['nome'];
    email = json['email'];
    telefone = json['telefone'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    image = json['image'] != null ? Photo.fromJson(json['image']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['objectId'] = objectId;
    data['nome'] = nome;
    data['email'] = email;
    data['telefone'] = telefone;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (image != null) {
      data['image'] = image!.imageToJson();
    }
    return data;
  }
}

class Photo {
  String? sType;
  String? name;
  String? url;

  Photo({this.sType, this.name, this.url});

  Photo.fromJson(Map<String, dynamic> json) {
    sType = json['__type'];
    name = json['name'];
    url = json['url'];
  }

  Map<String, dynamic> imageToJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['__type'] = sType;
    data['name'] = name;
    data['url'] = url;
    return data;
  }
}
