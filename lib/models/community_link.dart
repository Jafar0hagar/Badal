class CommunityLink {
  final String id;
  final String title;
  final String description;
  final String platform; // 'whatsapp_group', 'whatsapp_channel', 'telegram', 'facebook', 'phone'
  final String url;
  final String badgeText;
  final bool isFeatured;

  CommunityLink({
    required this.id,
    required this.title,
    required this.description,
    required this.platform,
    required this.url,
    required this.badgeText,
    this.isFeatured = false,
  });

  factory CommunityLink.fromJson(Map<String, dynamic> json, String docId) {
    return CommunityLink(
      id: docId,
      title: json['title'] as String? ?? 'رابط التواصل',
      description: json['description'] as String? ?? '',
      platform: json['platform'] as String? ?? 'whatsapp_group',
      url: json['url'] as String? ?? '',
      badgeText: json['badgeText'] as String? ?? 'رابط رسمي',
      isFeatured: json['isFeatured'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'platform': platform,
      'url': url,
      'badgeText': badgeText,
      'isFeatured': isFeatured,
    };
  }
}
