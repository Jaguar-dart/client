abstract class Req {
  String get path;
}

class GetReq implements Req {
  final String path;
  const GetReq([this.path = ""]);
}

class PostReq implements Req {
  final String path;
  const PostReq([this.path = ""]);
}

class PutReq implements Req {
  final String path;
  const PutReq([this.path = ""]);
}

class DeleteReq implements Req {
  final String path;
  const DeleteReq([this.path = ""]);
}

class HeadReq implements Req {
  final String path;
  const HeadReq([this.path = ""]);
}

class PatchReq implements Req {
  final String path;
  const PatchReq([this.path = "/"]);
}