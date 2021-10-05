class Entity {
  String name;
  String? description;
  String? pub_id;
  String? github_id;

  Entity({
    required this.name,
    this.description,
    this.pub_id,
    this.github_id,
  });

  factory Entity.fromJson(Map<String, dynamic> json) {
    return Entity(
      name: json['name'],
      description: json['description'],
      pub_id: json['pub_id'],
      github_id: json['github_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'pub_id': pub_id,
      'github_id': github_id,
    }..removeWhere((key, value) => value == null);
  }
}
