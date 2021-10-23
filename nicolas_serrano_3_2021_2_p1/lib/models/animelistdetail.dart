class AnimeListDetails {
  bool success = false;
  String img = "";
  int totalFacts = 0;
  List<Data> data = new List.empty();

  AnimeListDetails({required this.success, required this.img, required this.totalFacts, required this.data});

  AnimeListDetails.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    img = json['img'];
    totalFacts = json['total_facts'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['img'] = this.img;
    data['total_facts'] = this.totalFacts;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int factId = 0;
  String fact = "";

  Data({required this.factId, required this.fact});

  Data.fromJson(Map<String, dynamic> json) {
    factId = json['fact_id'];
    fact = json['fact'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fact_id'] = this.factId;
    data['fact'] = this.fact;
    return data;
  }
}