import 'package:jaguar_resty/response/response.dart';
import 'package:collection/collection.dart';

/// Performs a check/validation on [T]
typedef List<Mismatch> Checker<T>(T v);

/// Customizes message of a [Mismatch]
typedef String CustomMismatchMessage<T>(T mismatch);

/// A mismatch exception
abstract class Mismatch<M> implements Exception {}

class EqualityMismatch<T> implements Exception, Mismatch<EqualityMismatch<T>> {
  /// Expected value
  T expected;

  /// Actual value
  T actual;

  CustomMismatchMessage<EqualityMismatch<T>> customMessage;

  EqualityMismatch(this.expected, this.actual, {this.customMessage});

  String toString() => customMessage != null
      ? customMessage(this)
      : "Equality mismatch: Expected: $expected. Found: $actual!";
}

class RangeMismatch<T> implements Exception, Mismatch<RangeMismatch<T>> {
  T lower;

  T higher;

  T actual;

  CustomMismatchMessage<RangeMismatch<T>> customMessage;

  RangeMismatch(this.lower, this.higher, this.actual, {this.customMessage});

  String toString() => customMessage != null
      ? customMessage(this)
      : "Range mismatch: Expected: [$lower, $higher]. Found: $actual!";
}

class MapHasMismatch<T> implements Exception, Mismatch<MapHasMismatch<T>> {
  T key;

  CustomMismatchMessage<MapHasMismatch<T>> customMessage;

  MapHasMismatch(this.key, {this.customMessage});

  String toString() => customMessage != null
      ? customMessage(this)
      : "Map has mismatch: Key $key not found!";
}

Checker<Response> statusCodeIs(int expected) => (Response resp) {
      if (expected != resp.statusCode)
        return <Mismatch>[
          new EqualityMismatch(expected, resp.statusCode,
              customMessage: (m) =>
                  'Expected statuscode ${m.expected} but found ${m.actual}!')
        ];
      return <Mismatch>[];
    };

Checker<Response> get isUnauthorized => statusCodeIs(401);

Checker<Response> statusCodeIsInRange(int lower, int higher) =>
    (Response resp) {
      if (resp.statusCode < lower || resp.statusCode > higher)
        return <Mismatch>[
          new RangeMismatch(lower, higher, resp.statusCode,
              customMessage: (m) =>
                  'Expected statuscode in range [${m.lower}, ${m.higher} but found ${m.actual}!')
        ];
      return <Mismatch>[];
    };

Checker<Response> headersHas(String header, [String value]) => (Response resp) {
      if (!resp.headers.containsKey(header))
        return <Mismatch>[
          new MapHasMismatch(header,
              customMessage: (m) => 'Expected header ${m.key} is not found!')
        ];
      if (value != null) {
        if (resp.headers[header] != value)
          return <Mismatch>[
            new EqualityMismatch(value, resp.headers[header],
                customMessage: (m) =>
                    'Header $header is expected to have value ${m.expected} but found ${m.actual}!')
          ];
      }
      return <Mismatch>[];
    };

Checker<Response<T>> bodyIs<T>(T expected, [bool isEqual(T a, T b)]) =>
    (Response<T> resp) {
      bool equal = isEqual != null
          ? isEqual(expected, resp.body)
          : expected == resp.body;
      if (!equal)
        return <Mismatch>[
          new EqualityMismatch(expected, resp.body,
              customMessage: (m) =>
                  'Expected body ${m.expected} but found ${m.actual}!')
        ];
      return <Mismatch>[];
    };

const _bodyBytesEquality = const IterableEquality<int>();

Checker<Response> bodyBytesIs(List<int> expected) => (Response resp) {
      if (_bodyBytesEquality.equals(expected, resp.bytes))
        return <Mismatch>[
          new EqualityMismatch(expected, resp.body,
              customMessage: (m) =>
                  'Expected body ${m.expected} but found ${m.actual}!')
        ];
      return <Mismatch>[];
    };

Checker<Response> mimeTypeIs(String expected) => (Response resp) {
      if (expected != resp.mimeType)
        return <Mismatch>[
          new EqualityMismatch(expected, resp.mimeType,
              customMessage: (m) =>
                  'Expected mimetype ${m.expected} but found ${m.actual}!')
        ];
      return <Mismatch>[];
    };

final Checker<Response> mimeTypeIsJson = mimeTypeIs('application/json');

final Checker<Response> mimeTypeIsHtml = mimeTypeIs('text/html');

Checker<Response> encodingIs(String expected) => (Response resp) {
      if (expected != resp.encoding)
        return <Mismatch>[
          new EqualityMismatch(expected, resp.encoding,
              customMessage: (m) =>
                  'Expected encoding ${m.expected} but found ${m.actual}!')
        ];
      return <Mismatch>[];
    };
