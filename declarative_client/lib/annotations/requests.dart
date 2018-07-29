abstract class Req {}

class GetReq implements Req {
  final String url;
  const GetReq([this.url = ""]);
}

class PostReq implements Req {
  final String url;
  const PostReq([this.url = ""]);
}

class PutReq implements Req {
  final String url;
  const PutReq([this.url = ""]);
}

class DeleteReq implements Req {
  final String url;
  const DeleteReq([this.url = ""]);
}

class HeadReq implements Req {
  final String url;
  const HeadReq([this.url = ""]);
}

class PatchReq implements Req {
  final String url;
  const PatchReq([this.url = "/"]);
}