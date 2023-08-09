
class NewsModel {
  int? id;
  String title;
  String description;
  String image;


  NewsModel({
    this.id,required this.title,required this.description,required this.image
  });

  NewsModel copyWith({
    String? title,
    String? description,
    String? image,
    int? id,
  }) {
    return NewsModel(
      title: title ?? this.title,
      description: description ?? this.description,
      image: image ?? this.image,
      id: id ?? this.id,
    );
  }


  // Convert the Product object to a Map
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'image': image,
    };
  }

  // Convert a Map object to a Product
  static NewsModel fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json["id"] ,
     title: json["title"],
     description: json["description"],
     image: json["image"],
    );
  }
}
