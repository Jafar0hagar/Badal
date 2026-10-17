class BroadcastAlert {
  final String id;
  final String title;
  final String text;
  final String time;
  final bool unread;
  final int createdAt;

  BroadcastAlert({
    required this.id,
    required this.title,
    required this.text,
    required this.time,
    required this.unread,
    required this.createdAt,
  });

  factory BroadcastAlert.fromJson(Map<String, dynamic> json, String docId) {
    return BroadcastAlert(
      id: docId,
      title: json['title'] as String? ?? 'تنبيه عاجل',
      text: json['text'] as String? ?? '',
      time: json['time'] as String? ?? 'الآن',
      unread: json['unread'] as bool? ?? true,
      createdAt: json['createdAt'] is int
          ? json['createdAt'] as int
          : DateTime.now().millisecondsSinceEpoch,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'text': text,
      'time': time,
      'unread': unread,
      'createdAt': createdAt,
    };
  }
}
