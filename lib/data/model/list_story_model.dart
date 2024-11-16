class ListStoryModel {
  final bool error;
  final String message;
  final List<ListStory> listStory;

  ListStoryModel(
      {required this.error, required this.message, required this.listStory});

  factory ListStoryModel.fromJson(Map<String, dynamic> map) {
    return ListStoryModel(
        error: map['error'],
        message: map['message'],
        listStory: (map['listStory'] as List)
            .map((item) => ListStory.fromJson(item))
            .toList());
  }
}

class ListStory {
  final String id;
  final String name;
  final String description;
  final String photoUrl;
  final String createdAt;
  final double? lat;
  final double? lon;

  ListStory(
      {required this.id,
      required this.name,
      required this.description,
      required this.photoUrl,
      required this.createdAt,
      required this.lat,
      required this.lon});

  factory ListStory.fromJson(Map<String, dynamic> map) {
    return ListStory(
        id: map['id'],
        name: map['name'],
        description: map['description'],
        photoUrl: map['photoUrl'],
        createdAt: map['createdAt'],
        lat: map['lat']?.toDouble(),
        lon: map['lon']?.toDouble());
  }
}
