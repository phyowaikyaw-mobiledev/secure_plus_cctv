class Ticket {
  Ticket({
    required this.id,
    required this.issueType,
    required this.description,
    required this.urgency,
    required this.photoUrl,
    required this.status,
    required this.createdAt,
  });

  final String id;
  final String issueType;
  final String description;
  final String urgency; // low / normal / high
  final String? photoUrl;
  final String status;
  final DateTime createdAt;

  Map<String, dynamic> toMap() {
    return {
      'issueType': issueType,
      'description': description,
      'urgency': urgency,
      'photoUrl': photoUrl,
      'status': status,
      'createdAt': createdAt.toUtc(),
    };
  }
}

