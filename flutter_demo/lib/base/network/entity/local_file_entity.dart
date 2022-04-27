///本地存储文件的实体类
///ios端需要把文件存储在本地沙盒中，文件的信息单独存储在本地缓存SP中，后续可能换成数据库
class LocalFileEntity {
  String? fileName; //文件名称
  String? fileType; //文件类型
  String? fileCreTime; //文件存储时间
  String? fileLocPath; //iOS端下本地存储的沙盒路径 安卓端本地文件路径
  int? size; //文件大小 int

  LocalFileEntity({this.fileName, this.fileType, this.fileCreTime, this.fileLocPath, this.size});

  LocalFileEntity.fromJson(Map<String, dynamic> json) {
    fileName = json['fileName'];
    fileType = json['fileType'];
    fileCreTime = json['fileCreTime'];
    fileLocPath = json['fileLocPath'];
    size = json['size'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fileName'] = this.fileName;
    data['fileType'] = this.fileType;
    data['fileCreTime'] = this.fileCreTime;
    data['fileLocPath'] = this.fileLocPath;
    data['size'] = this.size;
    return data;
  }
}
