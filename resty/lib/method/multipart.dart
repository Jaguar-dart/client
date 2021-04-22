import 'package:http_parser/http_parser.dart';

abstract class Multipart {}

class MultipartString implements Multipart {
  final String value;

  MultipartString(this.value);
}

class MultipartFile implements Multipart {
  final String? filename;

  final MediaType? contentType;

  final List<int> value;

  MultipartFile(this.value, {this.filename, this.contentType});
}

class MultipartStreamFile implements Multipart {
  final String? filename;

  final MediaType? contentType;

  final Stream<List<int>> value;

  final int length;

  MultipartStreamFile(this.value, this.length,
      {this.filename, this.contentType});
}

class MultipartStringFile implements Multipart {
  final String? filename;

  final MediaType? contentType;

  final String value;

  MultipartStringFile(this.value, {this.filename, this.contentType});
}
