class ConfigEntity {
  final String Server;


  ConfigEntity.fromJson(Map<String, dynamic> json)
      :Server=json['Server'];


}

// class V2RayStatus {
//   final String state;
//   final String uploadSpeed;
//   final String downloadSpeed;
//   final String upload;
//   final String download;
//
//   V2RayStatus({
//     required this.state,
//     required this.uploadSpeed,
//     required this.downloadSpeed,
//     required this.upload,
//     required this.download,
//   });
//
//   factory V2RayStatus.fromMap(Map<String, dynamic> map) {
//     return V2RayStatus(
//       state: map['state'] ?? 'UNKNOWN',
//       uploadSpeed: map['uploadSpeed'] ?? '0',
//       downloadSpeed: map['downloadSpeed'] ?? '0',
//       upload: map['upload'] ?? '0',
//       download: map['download'] ?? '0',
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       'state': state,
//       'uploadSpeed': uploadSpeed,
//       'downloadSpeed': downloadSpeed,
//       'upload': upload,
//       'download': download,
//     };
//   }
// }

class V2RayStatuss {
  final String state;
  final String uploadSpeed;
  final String downloadSpeed;
  final String upload;
  final String download;

  V2RayStatuss({
    required this.state,
    required this.uploadSpeed,
    required this.downloadSpeed,
    required this.upload,
    required this.download,
  });

  // متد toMap برای تبدیل شیء به Map
  Map<String, String> toMap() {
    return {
      'state': state,
      'uploadSpeed': uploadSpeed,
      'downloadSpeed': downloadSpeed,
      'upload': upload,
      'download': download,
    };
  }

  // متد fromMap برای تبدیل Map به شیء
  factory V2RayStatuss.fromMap(Map<String, String> map) {
    return V2RayStatuss(
      state: map['state'] ?? 'UNKNOWN',
      uploadSpeed: map['uploadSpeed'] ?? '0',
      downloadSpeed: map['downloadSpeed'] ?? '0',
      upload: map['upload'] ?? '0',
      download: map['download'] ?? '0',
    );
  }
}

