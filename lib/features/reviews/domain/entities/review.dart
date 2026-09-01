class Review {
  final String id;
  final String targetId;
  final String targetType; // 'machine', 'worker', 'product'
  final String reviewerId;
  final String reviewerName;
  final double rating;
  final String comment;
  final DateTime createdAt;

  const Review({
    required this.id,
    required this.targetId,
    required this.targetType,
    required this.reviewerId,
    required this.reviewerName,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });
}
