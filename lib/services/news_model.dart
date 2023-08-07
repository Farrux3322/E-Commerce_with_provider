
class NewsModel {
  String title;
  String description;
  String image;


  NewsModel({
    required this.title,required this.description,required this.image
  });

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
     title: json["title"],
     description: json["description"],
     image: json["image"],
    );
  }
}
