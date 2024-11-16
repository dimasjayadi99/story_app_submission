class DetailStoryModel {
  final bool error;
  final String message;
  final Story story;

  DetailStoryModel(
      {required this.error, required this.message, required this.story});

  factory DetailStoryModel.fromJson(Map<String, dynamic> map) {
    return DetailStoryModel(
      error: map['error'],
      message: map['message'],
      story: Story.fromJson(map['story']),
    );
  }
}

class Story {
  final String id;
  final String name;
  final String description;
  final String photoUrl;
  final String createdAt;
  final double? lat;
  final double? lon;

  Story(
      {required this.id,
      required this.name,
      required this.description,
      required this.photoUrl,
      required this.createdAt,
      required this.lat,
      required this.lon});

  factory Story.fromJson(Map<String, dynamic> map) {
    return Story(
        id: map['id'],
        name: map['name'],
        description: map['description'],
        photoUrl: map['photoUrl'],
        createdAt: map['createdAt'],
        lat: map['lat'],
        lon: map['lon']);
  }
}
