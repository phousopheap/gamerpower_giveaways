/// One giveaway from https://www.gamerpower.com/api/giveaways
class Giveaway {
  const Giveaway({
    required this.id,
    required this.title,
    required this.worth,
    required this.thumbnail,
    required this.image,
    required this.description,
    required this.instructions,
    required this.openGiveawayUrl,
    required this.publishedDate,
    required this.type,
    required this.platforms,
    required this.endDate,
    required this.users,
    required this.status,
  });

  final int id;
  final String title;
  final String worth;
  final String thumbnail;
  final String image;
  final String description;
  final String instructions;
  final String openGiveawayUrl;
  final String publishedDate;
  final String type;
  final String platforms;
  final String endDate;
  final int users;
  final String status;

  factory Giveaway.fromJson(Map<String, dynamic> json) {
    String str(String key) => (json[key] ?? '').toString();
    return Giveaway(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: str('title'),
      worth: str('worth'),
      thumbnail: str('thumbnail'),
      image: str('image'),
      description: str('description'),
      instructions: str('instructions'),
      openGiveawayUrl: str('open_giveaway_url').isNotEmpty
          ? str('open_giveaway_url')
          : str('open_giveaway'),
      publishedDate: str('published_date'),
      type: str('type'),
      platforms: str('platforms'),
      endDate: str('end_date'),
      users: (json['users'] as num?)?.toInt() ?? 0,
      status: str('status'),
    );
  }

  /// True when the API gives a real price (it sends "N/A" otherwise).
  bool get hasWorth => worth.isNotEmpty && worth != 'N/A';

  bool get isActive => status.toLowerCase() == 'active';

  String get heroImage => image.isNotEmpty ? image : thumbnail;

  List<String> get platformList => platforms
      .split(',')
      .map((p) => p.trim())
      .where((p) => p.isNotEmpty)
      .toList();

  String get cleanDescription => description.replaceAll('\r', '').trim();

  /// Instructions split into steps, with the "1." numbering removed.
  List<String> get steps => instructions
      .split(RegExp(r'\r?\n'))
      .map((line) => line.replaceFirst(RegExp(r'^\s*\d+[.)]\s*'), '').trim())
      .where((line) => line.isNotEmpty)
      .toList();
}
