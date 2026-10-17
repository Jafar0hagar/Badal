class SystemAlert {
  final String id;
  final String title;
  final String text;
  final String time;
  final bool unread;
  final int createdAt;

  SystemAlert({
    required this.id,
    required this.title,
    required this.text,
    required this.time,
    required this.unread,
    required this.createdAt,
  });

  factory SystemAlert.fromFirestore(Map<String, dynamic> json, String docId) {
    return SystemAlert(
      id: docId,
      title: json['title'] ?? '',
      text: json['text'] ?? '',
      time: json['time'] ?? 'الآن',
      unread: json['unread'] ?? true,
      createdAt: json['createdAt'] ?? DateTime.now().millisecondsSinceEpoch,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'title': title,
      'text': text,
      'time': time,
      'unread': unread,
      'createdAt': createdAt,
    };
  }
}
