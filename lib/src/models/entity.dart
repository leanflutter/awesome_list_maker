class Entity {
  String name;
  String? homepage;
  String? description;
  String? pub_id;
  String? github_id;
  String? livepreview_url;
  String? category;

  Entity({
    required this.name,
    this.homepage,
    this.description,
    this.pub_id,
    this.github_id,
    this.livepreview_url,
    this.category,
  });

  factory Entity.fromJson(Map<String, dynamic> json) {
    return Entity(
      name: json['name'] ?? json['pub_id'],
      homepage: json['homepage'],
      description: json['description'],
      pub_id: json['pub_id'],
      github_id: json['github_id'],
      livepreview_url: json['livepreview_url'],
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'homepage': homepage,
      'description': description,
      'pub_id': pub_id,
      'github_id': github_id,
      'livepreview_url': livepreview_url,
      'category': category,
    }..removeWhere((key, value) => value == null);
  }
}
