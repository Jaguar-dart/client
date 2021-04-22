/// Mutable Uri
class MutUri {
  final List<String> _paths;

  final Map<String, String> _pathParams;

  String? _origin;

  final Map<String,
          dynamic /* String | Iterable<String | dynamic | Iterable<dynamic> */ >
      getQuery;

  MutUri(
      {String? origin,
      List<String>? paths,
      Map<String, String>? pathParams,
      Map<String, dynamic>? query})
      : _paths = paths?.toList() ?? <String>[],
        _pathParams =
            pathParams != null ? Map<String, String>.from(pathParams) : {},
        _origin = origin,
        getQuery = query != null ? Map<String, dynamic>.from(query) : {};

  static MutUri from(dynamic from) {
    if (from == null) {
      return MutUri();
    }
    if (from is String) {
      from = Uri.parse(from);
    }
    if (from is Uri) {
      if (from.isScheme('http') || from.isScheme('https')) {
        return MutUri(
          origin: from.origin,
          paths: from.pathSegments,
          query: from.queryParameters,
        );
      } else {
        return MutUri(
          paths: from.pathSegments,
          query: from.queryParameters,
        );
      }
    }
    if (from is MutUri) {
      return from;
    }
    throw Exception('');
  }

  MutUri http(String origin, [String? path]) {
    _origin = 'http://${origin}';
    if (path != null) {
      this.path(path);
    }
    return this;
  }

  MutUri https(String origin, [String? path]) {
    _origin = 'https://${origin}';
    if (path != null) {
      this.path(path);
    }
    return this;
  }

  /// Set origin of the URL
  MutUri origin(String origin, [String? path]) {
    _origin = origin;
    if (path != null) {
      this.path(path);
    }
    return this;
  }

  /// Append path segments to the URL
  MutUri path(String path) {
    if (path.isEmpty) return this;
    final parts = path.split('/').where((p) => p.isNotEmpty);
    _paths.addAll(parts);
    return this;
  }

  MutUri pathParam(String name, dynamic value) {
    if (value != null) {
      _pathParams[name] = value!.toString();
    }
    return this;
  }

  MutUri pathParams(Map<String, dynamic> value) {
    value.forEach(pathParam);
    return this;
  }

  /// Add query parameters
  MutUri query(String key, value) {
    if (value is String || value is Iterable<String>) {
      getQuery[key] = value;
    } else if (value is Iterable) {
      getQuery[key] = value.map((v) => v?.toString() ?? '');
    } else if (value != null) {
      getQuery[key] = value?.toString();
    }
    return this;
  }

  /// Add query parameters
  MutUri queries(Map<String, dynamic> value) {
    value.forEach(query);
    return this;
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

  MutUri clone() => MutUri(
        origin: _origin,
        paths: _paths.toList(),
        pathParams: Map.from(_pathParams),
        query: Map.from(getQuery),
      );
}
