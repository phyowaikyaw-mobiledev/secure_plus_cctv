class ServiceRequest {
  ServiceRequest({
    required this.id,
    required this.name,
    required this.phone,
    required this.township,
    required this.address,
    required this.locationLink,
    required this.premiseType,
    required this.cameraCount,
    required this.indoorOutdoor,
    required this.remoteView,
    required this.audioRequired,
    required this.preferredDateTime,
    required this.notes,
    required this.photoUrl,
    required this.status,
    required this.createdAt,
  });

  final String id;
  final String name;
  final String phone;
  final String township;
  final String address;
  final String locationLink;
  final String premiseType;
  final int cameraCount;
  final String indoorOutdoor;
  final bool remoteView;
  final bool audioRequired;
  final String preferredDateTime;
  final String notes;
  final String? photoUrl;
  final String status;
  final DateTime createdAt;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'township': township,
      'address': address,
      'locationLink': locationLink,
      'premiseType': premiseType,
      'cameraCount': cameraCount,
      'indoorOutdoor': indoorOutdoor,
      'remoteView': remoteView,
      'audioRequired': audioRequired,
      'preferredDateTime': preferredDateTime,
      'notes': notes,
      'photoUrl': photoUrl,
      'status': status,
      'createdAt': createdAt.toUtc(),
    };
  }
}

