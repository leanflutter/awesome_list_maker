import 'category.dart';
import 'entity.dart';
import 'tag.dart';

class AwesomeList {
  final String name;
  final String description;
  final List<Category> categories;
  final List<Tag> tags;
  final List<Entity> entities;

  AwesomeList({
    required this.name,
    required this.description,
    required this.categories,
    required this.tags,
    required this.entities,
  });

  factory AwesomeList.fromJson(Map<String, dynamic> json) {
    List<Category> categories = (json['categories'] as List)
        .map((item) => Category.fromJson(Map<String, dynamic>.from(item)))
        .toList();
    List<Tag> tags = (json['tags'] as List)
        .map((item) => Tag.fromJson(Map<String, dynamic>.from(item)))
        .toList();
    List<Entity> entities = (json['entities'] as List)
        .map((item) => Entity.fromJson(Map<String, dynamic>.from(item)))
        .toList();

    return AwesomeList(
      name: json['name'],
      description: json['description'],
      categories: categories,
      tags: tags,
      entities: entities,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'categories': categories.map((e) => e.toJson()).toList(),
      'tags': tags.map((e) => e.toJson()).toList(),
      'entities': entities.map((e) => e.toJson()).toList(),
    }..removeWhere((key, value) => value == null);
  }
}
