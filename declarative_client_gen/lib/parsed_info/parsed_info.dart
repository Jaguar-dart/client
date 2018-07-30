import 'package:analyzer/dart/element/element.dart' show MethodElement;

abstract class Body {}

class JsonBody implements Body {}

class UrlEncodedForm implements Body {}

class MultipartForm implements Body {}

class Req {
  String get name => me.displayName;

  final String method;

  final String path;

  final Set<String> pathParams;

  final Map<String, String> query;

  final Map<String, String> headers;

  final Body body;

  final MethodElement me;

  Req(this.method, this.me,
      {this.path, this.query, this.headers, this.body, this.pathParams});
}

class WriteInfo {
  final String name;

  final List<Req> requests;

  WriteInfo(this.name, this.requests);
}
