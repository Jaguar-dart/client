/// Mutable Uri
class MutUri {
  final _paths = <String>[];

  final _pathParams = <String, String>{};

  String? _origin;

  final getQuery = <String,
      dynamic /* String | Iterable<String | dynamic | Iterable<dynamic> */ >{};

  void http(String origin, [String? path]) {
    _origin = 'http://${origin}';
    if (path != null) {
      this.path(path);
    }
  }

  void https(String origin, [String? path]) {
    _origin = 'https://${origin}';
    if (path != null) {
      this.path(path);
    }
  }

  /// Set origin of the URL
  void origin(String origin, [String? path]) {
    _origin = origin;
    if (path != null) {
      this.path(path);
    }
  }

  /// Append path segments to the URL
  void path(String path) {
    if (path.isEmpty) return;
    final parts = path.split('/').where((p) => p.isNotEmpty);
    _paths.addAll(parts);
  }

  void pathParams(String name, dynamic value) {
    if (value != null) {
      _pathParams[name] = value!.toString();
    }
  }

  /// Add query parameters
  void query(String key, value) {
    if (value is String || value is Iterable<String>) {
      getQuery[key] = value;
    } else if (value is Iterable) {
      getQuery[key] = value.map((v) => v?.toString() ?? '');
    } else if (value != null) {
      getQuery[key] = value?.toString();
    }
  }

  /// Add query parameters
  void queries(Map<String, dynamic> value) {
    value.forEach(query);
  }

  Uri get uri {
    return Uri.parse(url);
  }

  String get url {
    String path = _paths
        .map((ps) => ps.startsWith(':') ? _pathParams[ps.substring(1)] : ps)
        .join('/');

    path = Uri.encodeFull(path);

    if (_origin == null && getQuery.isEmpty) {
      return path;
    }

    final sb = StringBuffer();
    if (_origin != null) {
      sb.write(_origin);
    }
    if (_origin == null || !_origin!.endsWith('/')) {
      sb.write('/');
    }
    sb.write(path);
    if (getQuery.isEmpty) {
      return sb.toString();
    }
    _makeQueryParams(sb, getQuery);
    return sb.toString();
  }

  static void _makeQueryParams(StringBuffer sb, Map<String, dynamic> query) {
    if (query.length == 0) return;
    sb.write('?');

    void writeQuery(String key, String? value, [bool isFirst = false]) {
      if (!isFirst) sb.write('&');
      sb.write(Uri.encodeQueryComponent(key));
      if (value != null && value.isNotEmpty) {
        sb.write("=");
        sb.write(Uri.encodeQueryComponent(value));
      }
    }

    void writeQueries(String key, value, [bool isFirst = false]) {
      if (value is Iterable) {
        for (int i = 0; i < value.length; i++) {
          if (i == 0) {
            writeQuery(key, value.elementAt(i)?.toString() ?? '', isFirst);
          } else {
            writeQuery(key, value.elementAt(i)?.toString() ?? '', false);
          }
        }
        return;
      }
      writeQuery(key, value?.toString() ?? '', isFirst);
    }

    for (int i = 0; i < query.length; i++) {
      String key = query.keys.elementAt(i);
      if (i == 0) {
        writeQueries(key, query[key], true);
      } else {
        writeQueries(key, query[key], false);
      }
    }
  }
}
