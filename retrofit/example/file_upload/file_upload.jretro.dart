// GENERATED CODE - DO NOT MODIFY BY HAND

part of upload_files.server;

// **************************************************************************
// JaguarHttpGenerator
// **************************************************************************

abstract class _$UserApiClient implements ApiClient {
  final String basePath = "api";
  Future<StringResponse> upload(MultipartFile file) async {
    var req = base.post.path(basePath).path("upload").multipart({"file": file});
    return req.go(throwOnErr: true);
  }
}
