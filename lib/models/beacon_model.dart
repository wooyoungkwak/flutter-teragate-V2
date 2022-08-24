class BeaconData  {
   String name;
   String uuid;
   String major;
   String minor;
   String distance;
   String rssi;
   String? macAddress;
   String? proximity;
   String? scanTime;
   String? txPower;

  BeaconData (this.name, this.uuid, this.major, this.minor, this.distance, this.rssi, this.macAddress, this.proximity, this.scanTime, this.txPower);

  BeaconData.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        uuid = json['uuid'],
        major = json['major'],
        minor = json['minor'],
        distance = json['distance'],
        rssi = json['rssi'],
        macAddress = null,
        proximity = null,
        scanTime = null,
        txPower = null;

  Map<String, dynamic> toJson() => {
        'name': name,
        'uuid': uuid,
        'major': major,
        'minor': minor,
        'distance' : distance,
        'rssi':rssi,
      };
}

class BeaconInfoData {
  String location;
  String uuid;

  BeaconInfoData({required this.uuid, required this.location});

  static BeaconInfoData fromJson(Map<String, dynamic> json) {
      return BeaconInfoData(location: json["location"], uuid: json["uuid"]);
  }

  static List<BeaconInfoData> fromJsons(List<dynamic> jsons) {
    List<BeaconInfoData> beaconInfoDatas = [];

    for (int i=0; i< jsons.length; i++) {
      beaconInfoDatas.add(BeaconInfoData.fromJson(jsons[i]));
    }

    return beaconInfoDatas;
  }

}