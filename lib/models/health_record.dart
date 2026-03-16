class HealthRecord {
  final String id;
  final String userId;
  String tanggal;
  String namaDokter;
  String diagnosis;
  String obat;
  String tekananDarah;
  String beratTinggi;
  String catatan;
  final DateTime? createdAt;

  HealthRecord({
    required this.id,
    required this.userId,
    required this.tanggal,
    required this.namaDokter,
    required this.diagnosis,
    required this.obat,
    required this.tekananDarah,
    required this.beratTinggi,
    this.catatan = '',
    this.createdAt,
  });

  factory HealthRecord.fromJson(Map<String, dynamic> json) {
    return HealthRecord(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      tanggal: json['tanggal'] ?? '',
      namaDokter: json['nama_dokter'] ?? '',
      diagnosis: json['diagnosis'] ?? '',
      obat: json['obat'] ?? '',
      tekananDarah: json['tekanan_darah'] ?? '',
      beratTinggi: json['berat_tinggi'] ?? '',
      catatan: json['catatan'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'tanggal': tanggal,
      'nama_dokter': namaDokter,
      'diagnosis': diagnosis,
      'obat': obat,
      'tekanan_darah': tekananDarah,
      'berat_tinggi': beratTinggi,
      'catatan': catatan,
    };
  }
}
