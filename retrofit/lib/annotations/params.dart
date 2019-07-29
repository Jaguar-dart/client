library retrofit.annotations.params;

/// Sends the argument annontated with [PathParam] as path parameter in the http
/// request.
///
///     @GetReq(path: "/book/:id")
///     Future<Book> get(@PathParam() String id);
class PathParam {
  final String alias;
  const PathParam([this.alias]);
}

/// Sends the argument annotated with [QueryParam] as query parameter in the
/// http request.
///
///     @GetReq(path: "/book")
///     Future<Book> get(@QueryParam() String id);
class QueryParam {
  final String alias;
  const QueryParam([this.alias]);
}

/// Sends the Map<String, dynamic> argument annotated with [QueryMap] as query
/// parameters in the http request.
///
///     @GetReq(path: "/book")
///     Future<List<Book>> get(@QueryMap() Map<String, dynamic> attributes);
class QueryMap {
  const QueryMap();
}

class Header {
  final String alias;
  const Header([this.alias]);
}

class HeaderMap {
  const HeaderMap();
}

abstract class BodyAnnotation {}

/// Sends the argument annotated with [AsJson] as JSON body in the http request.
/// Uses [ApiClient.serializers] for serialization.
///
///     @PostReq(path: "/book")
///     Future<List<Book>> create(@AsJson() Book book);
class AsJson implements BodyAnnotation {
  const AsJson();
}

/// Sends the argument annotated with [AsBody] as string or bytes in http
/// request.
///
///     @PostReq(path: "/image")
///     Future<void> upload(@AsBody() List<int> bytes);
class AsBody implements BodyAnnotation {
  const AsBody();
}

/// Sends the argument annotated with [AsForm] as url-encoded-form body in the
/// http request. Uses [ApiClient.serializers] for serialization.
///
///     @PostReq(path: "/book")
///     Future<void> upload(@AsForm() Book book);
class AsForm implements BodyAnnotation {
  const AsForm();
}

/// Sends the argument annotated with [AsFormField] as a field in
/// url-encoded-form body in the http request.
///
///     @PostReq(path: "/book")
///     Future<void> upload(@AsForm() Book book, @AsFormField() String id);
class AsFormField implements BodyAnnotation {
  final String alias;
  const AsFormField([this.alias]);
}

/// Sends the argument annotated with [AsMultipart] as multipart/form-data body
/// in the http request. Uses [ApiClient.serializers] for serialization if [serialize]
/// is true.
///
///     @PostReq(path: "/book")
///     Future<void> upload(@AsMultipart() Book book);
///
///     @PostReq(path: "/book")
///     Future<void> upload(@AsMultipart(serialize: false) Map<String, dynamic> book);
class AsMultipart implements BodyAnnotation {
  final bool serialize;
  const AsMultipart({this.serialize: true});
}

/// Sends the argument annotated with [AsMultipartField] as multipart/form-data body
/// field in the http request.
///
///     @PostReq(path: "/book")
///     Future<void> upload(@AsMultipart() Book book, @AsMultipartField() String id);
///
///     @PostReq(path: "/image")
///     Future<void> upload(@AsMultipartField() MultipartFile image);
class AsMultipartField implements BodyAnnotation {
  final String alias;
  const AsMultipartField([this.alias]);
}

/// Sends the argument annotated with [Serialized] as string or bytes in http
/// request.
///
///     @PostReq(path: "/image")
///     Future<void> upload(@AsBody() List<int> bytes);
class Serialized implements BodyAnnotation {
  final String as;
  const Serialized(this.as);
}

class HookHeader {
  final String alias;
  const HookHeader([this.alias]);
}
