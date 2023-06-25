class IgMetaData {
  const IgMetaData({
    required this.username,
    required this.followersCount,
    required this.followsCount,
    required this.mediaCount,
    required this.totalLikes,
    required this.profilePictureUrl,
    required this.name,
    required this.biography,
    this.accessToken,
    this.userId,
  });
  final String username;
  final int followersCount;
  final int followsCount;
  final int mediaCount;
  final int totalLikes;
  final String profilePictureUrl;
  final String name;
  final String biography;
  final String? accessToken;
  final String? userId;
}
