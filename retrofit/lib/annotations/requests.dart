library retrofit.annotations.requests;

abstract class Req {
  String get path;
  Map<String, dynamic> get metadata;
}

class GetReq implements Req {
  final String path;
  final Map<String, dynamic> metadata;
  const GetReq({this.path = "", this.metadata: const {}});
}

class PostReq implements Req {
  final String path;
  final Map<String, dynamic> metadata;
  const PostReq({this.path = "", this.metadata: const {}});
}

class PutReq implements Req {
  final String path;
  final Map<String, dynamic> metadata;
  const PutReq({this.path = "", this.metadata: const {}});
}

class DeleteReq implements Req {
  final String path;
  final Map<String, dynamic> metadata;
  const DeleteReq({this.path = "", this.metadata: const {}});
}

class HeadReq implements Req {
  final String path;
  final Map<String, dynamic> metadata;
  const HeadReq({this.path = "", this.metadata: const {}});
}

class PatchReq implements Req {
  final String path;
  final Map<String, dynamic> metadata;
  const PatchReq({this.path = "", this.metadata: const {}});
}
