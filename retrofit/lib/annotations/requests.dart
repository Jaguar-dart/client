abstract class Req {
  String get path;
  Map<String, dynamic> get metaData;
}

class GetReq implements Req {
  final String path;
  final Map<String, dynamic> metaData;
  const GetReq([this.path = "", this.metaData]);
}

class PostReq implements Req {
  final String path;
  final Map<String, dynamic> metaData;
  const PostReq([this.path = "", this.metaData]);
}

class PutReq implements Req {
  final String path;
  final Map<String, dynamic> metaData;
  const PutReq([this.path = "", this.metaData]);
}

class DeleteReq implements Req {
  final String path;
  final Map<String, dynamic> metaData;
  const DeleteReq([this.path = "", this.metaData]);
}

class HeadReq implements Req {
  final String path;
  final Map<String, dynamic> metaData;
  const HeadReq([this.path = "", this.metaData]);
}

class PatchReq implements Req {
  final String path;
  final Map<String, dynamic> metaData;
  const PatchReq([this.path = "/", this.metaData]);
}
