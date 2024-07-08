class AppInfo {
  final String appVersion;
  final String isUpdating;
  final String? notification;
  final String protocol;

  AppInfo({
    required this.appVersion,
    required this.isUpdating,
    this.notification,
    required this.protocol,
  });

  // متد factory برای ساخت یک نمونه از JSON
  factory AppInfo.fromJson(Map<String, dynamic> json) {
    return AppInfo(
      appVersion: json['app_version'] as String,
      isUpdating: json['is_updating'] as String,
      notification: json['notification'] as String?,
      protocol: json['protocol'] as String,
    );
  }
}