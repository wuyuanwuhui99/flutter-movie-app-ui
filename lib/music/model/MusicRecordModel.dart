class MusicRecordModel {
  int musicId; // 音乐id
  String device; // 设备型号
  String version; // 软件版本
  String platform;// 平台

  MusicRecordModel({
    this.musicId, // 音乐id
    this.device, // 设备型号
    this.version, // 软件版本
    this.platform// 平台
  });

  Map toMap() {
    return {
      "musicId": musicId,
      "platform": platform,
      "device": device,
      "version": version
    };
  }
}
