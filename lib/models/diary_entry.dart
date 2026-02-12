class DiaryEntry {
  final String id;
  final String userId;
  final String title;
  final String content;
  final String mood;
  final DateTime createdAt;

  DiaryEntry({
    required this.id,
    required this.userId,
    required this.title,
    required this.content,
    required this.mood,
    required this.createdAt,
  });

  factory DiaryEntry.fromJson(Map<String, dynamic> json) {
    return DiaryEntry(
      id: json['id'],
      userId: json['user_id'],
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      mood: json['mood'] ?? 'calm',
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'title': title,
      'content': content,
      'mood': mood,
    };
  }
}
