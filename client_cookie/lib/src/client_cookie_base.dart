// Copyright (c) 2017, teja. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:http/http.dart' as http;

final _invalidDirective = Exception('Invalid directives found!!');

/// Client cookie
class ClientCookie {
  /// Cookie domain
  final String? domain;

  /// Cookie expiry date
  final DateTime? expires;

  /// Is cookie HTTP only?
  final bool httpOnly;

  /// Max age of cookie
  final int? maxAge;

  /// Cookie name
  final String name;

  /// Cookie path
  final String? path;

  /// Should the cookie be only sent on secure requests?
  final bool secure;

  /// Value of cookie
  final String value;

  /// TIme at which cookie was created
  final DateTime createdAt;

  ClientCookie(this.name, this.value, this.createdAt,
      {this.domain,
      this.expires,
      this.httpOnly: false,
      this.maxAge,
      this.secure: false,
      this.path});

  /// Receives directives as [Map]
  factory ClientCookie.fromMap(
      String name, String value, DateTime createdAt, Map map) {
    return ClientCookie(
      name,
      value,
      createdAt,
      domain: map['Domain'],
      expires: map['Expires'],
      httpOnly: map['HttpOnly'] ?? false,
      maxAge: map['Max-Age'],
      secure: map['Secure'] ?? false,
      path: map['Path'],
    );
  }

  /// Parses one 'set-cookie' item
  ///
  /// Parameters:
  /// - [enableExtendedDirectiveParsing]
  ///   When enabled and a directive is not recognized, the parser will try extended methods to find the right directive. These methods are:
  ///   - Comparing Case-insensitive
  factory ClientCookie.fromSetCookie(String cookieItem,
      {bool enableExtendedDirectiveParsing = true}) {
    final List<String> parts =
        cookieItem.split(';').reversed.map((String str) => str.trim()).toList();

    if (parts.isEmpty) throw Exception('Invalid cookie set!');

    String name;
    String value;
    final map = {};

    {
      final String first = parts.removeLast();
      final int idx = first.indexOf('=');
      if (idx == -1) throw Exception('Invalid Name=Value pair!');
      name = first.substring(0, idx).trim();
      value = first.substring(idx + 1).trim();
      if (name.isEmpty) {
        throw Exception('Cookie must have a name!');
      }
    }

    for (String directive in parts) {
      final List<String> points = directive //
          .split('=')
          .map((String str) => str.trim())
          .toList();

      if (points.length == 0 || points.length > 2) {
        throw Exception('Invalid directive!');
      }

      String key = points.first;
      final String val = points.length == 2 ? points.last : '';
      if (!_parsers.containsKey(key)) {
        if (!enableExtendedDirectiveParsing) {
          throw _invalidDirective;
        }
        key = _parsers.keys.firstWhere(
          (e) => e.toLowerCase() == key.toLowerCase(),
          orElse: () => throw _invalidDirective,
        );
      }
      map[key] = _parsers[key](val);
    }

    return ClientCookie.fromMap(name, value, DateTime.now(), map);
  }

  /// Formats Date
  String _formatDate(DateTime datetime) {
    /* To Dart team: why i have to do this?! this is so awkward (need native JS Date()!!§) */
    final day = ['Mon', 'Tue', 'Wed', 'Thi', 'Fri', 'Sat', 'Sun'];
    final mon = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    var _intToString = (int i, int pad) {
      var str = i.toString();
      var pads = pad - str.length;
      return (pads > 0) ? '${List.filled(pads, '0').join('')}$i' : str;
    };

    var utc = datetime.toUtc();
    var hour = _intToString(utc.hour, 2);
    var minute = _intToString(utc.minute, 2);
    var second = _intToString(utc.second, 2);

    return '${day[utc.weekday - 1]}, ${utc.day} ${mon[utc.month - 1]} ${utc.year} ' +
        '${hour}:${minute}:${second} ${utc.timeZoneName}';
  }

  /// Returns a [String] representation that can be written directly to
  /// [http.Request] 'cookie' header
  String get toReqHeader {
    final sb = StringBuffer();

    //TODO encode all

    sb.write(name);
    sb.write('=');
    if (value is String) sb.write(value);

    return sb.toString();
  }

  /// Returns a [String] representation that can be directly written to
  /// 'set-cookie' header of server response
  String get setCookie => toString();

  /// String representation that is useful for debug printing
  String toString() {
    final sb = StringBuffer();

    //TODO encode all

    sb.write(name);
    sb.write('=');
    if (value is String) sb.write(value);

    if (httpOnly) {
      sb.write('; HttpOnly');
    }
    if (secure) {
      sb.write('; Secure');
    }
    if (path != null) {
      sb.write('; Path=$path');
    }
    if (domain != null) {
      sb.write('; Domain=$domain');
    }
    if (maxAge != null) {
      sb.write('; Max-Age=$maxAge');
    }
    if (expires != null) {
      sb.write('; Max-Age=${_formatDate(expires!)}');
    }

    return sb.toString();
  }

  /// Returns [true] if the cookie has expired
  bool get hasExpired {
    if (expires is DateTime) {
      //TODO
      return false;
    }

    if (maxAge is int) {
      //TODO
      return false;
    }

    return false;
  }

  /// Returns a [String] representation that can be directly written to
  /// 'set-cookie' header
  static String toSetCookie(Iterable<ClientCookie> cookies) =>
      cookies.where((c) => !c.hasExpired).join(',');

  /// A map of field to parser function
  static final Map<String, dynamic> _parsers = <String, dynamic>{
    'Expires': (String val) {
      //TODO
    },
    'Max-Age': (String? val) {
      if (val == null) throw Exception('Invalid Max-Age directive!');
      return int.parse(val);
    },
    'Domain': (String? val) {
      if (val == null) throw Exception('Invalid Domain directive!');
      return val;
    },
    'Path': (String? val) {
      if (val == null) throw Exception('Invalid Path directive!');
      return val;
    },
    'Secure': (String? val) {
      if (val == null) throw Exception('Invalid Secure directive!');
      return true;
    },
    'HttpOnly': (String? val) {
      if (val == null) throw Exception('Invalid HttpOnly directive!');
      return true;
    },
    'SameSite': (String? val) {
      if (val == null) throw Exception('Invalid SameSite directive!');
      return val;
    },
  };
}

/// A store for Cookies
class CookieStore {
  /// Influences the parsing of the 'set-cookie' header.
  ///
  /// When enabled and a directive is not recognized, the parser will try extended methods to find the right directive. These methods are:
  /// - Comparing Case-insensitive
  bool enableExtendedDirectiveParsing;

  /// The actual storeage
  Map<String, ClientCookie> cookieMap = {};

  List<ClientCookie> get cookies => cookieMap.values.toList();

  CookieStore({this.enableExtendedDirectiveParsing = true});

  /// Returns a cookie by [name]
  ///
  /// Returns [null] if cookie with name is not present
  ClientCookie? get(String name) {
    if (!cookieMap.containsKey(name)) return null;

    final ret = cookieMap[name]!;

    // Remove expired cookie
    if (ret.hasExpired) {
      cookieMap.remove(name);
      return null;
    }

    return ret;
  }

  /// Returns a [String] representation that can be directly written
  /// [http.Request] header.
  String get toReqHeader {
    final removes = <String>[];
    final rets = <String>[];

    for (ClientCookie cookie in cookieMap.values) {
      if (cookie.hasExpired) {
        removes.add(cookie.name);
        continue;
      }
      rets.add(cookie.toReqHeader);
    }

    for (String rem in removes) cookieMap.remove(rem);

    return rets.join(', ');
  }

  /// Parses and adds all 'set-cookies' from [http.Response] to the Cookie store
  ///
  /// Parameters:
  /// - [enableExtendedDirectiveParsing]
  ///   When enabled and a directive is not recognized, the parser will try extended methods to find the right directive. These methods are:
  ///   - Comparing Case-insensitive
  ///
  ///   overrides [CookieStore.enableExtendedDirectiveParsing]
  void addFromResponse(http.Response resp,
      {bool? enableExtendedDirectiveParsing}) {
    if (resp.headers.containsKey('set-cookie')) {
      addFromHeader(resp.headers['set-cookie']!);
    }
  }

  /// Parses and adds all 'set-cookies' from [http.Response] to the Cookie store
  ///
  /// Parameters:
  /// - [enableExtendedDirectiveParsing]
  ///   When enabled and a directive is not recognized, the parser will try extended methods to find the right directive. These methods are:
  ///   - Comparing Case-insensitive
  ///
  ///   overrides [CookieStore.enableExtendedDirectiveParsing]
  void addFromHeader(String? setCookieLine,
      {bool? enableExtendedDirectiveParsing}) {
    if (setCookieLine == null || setCookieLine.isEmpty) {
      return;
    }

    final map = parseSetCookie(setCookieLine,
        enableExtendedDirectiveParsing: enableExtendedDirectiveParsing ??
            this.enableExtendedDirectiveParsing);

    for (String name in map.keys) {
      final ClientCookie cookie = map[name]!;
      if (cookie.value.isEmpty) {
        cookieMap.remove(name);
        continue;
      }
      cookieMap[name] = cookie;
    }
  }

  /// String representation that is useful for debug printing
  String toString() => 'CookieStore($cookieMap)';
}

/// Parses and adds all 'set-cookies' from [http.Response] to the Cookie store
///
/// Parameters:
/// - [enableExtendedDirectiveParsing]
///   When enabled and a directive is not recognized, the parser will try extended methods to find the right directive. These methods are:
///   - Comparing Case-insensitive
Map<String, ClientCookie> parseSetCookie(String? setCookieLine,
    {bool enableExtendedDirectiveParsing = true}) {
  final cookieMap = <String, ClientCookie>{};

  if (setCookieLine == null || setCookieLine.isEmpty) {
    return cookieMap;
  }

  final cookieStrings = setCookieLine.split(RegExp(r',(?=[A-Za-z0-9_-]+\s*=)'));
  for (String itemStr in cookieStrings) {
    final cookie = ClientCookie.fromSetCookie(itemStr,
        enableExtendedDirectiveParsing: enableExtendedDirectiveParsing);
    cookieMap[cookie.name] = cookie;
  }

  return cookieMap;
}
