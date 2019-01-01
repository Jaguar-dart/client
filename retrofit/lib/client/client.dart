library jaguar.retrofit.client;

import 'dart:async';
import 'package:jaguar_serializer/jaguar_serializer.dart';
import 'package:jaguar_resty/jaguar_resty.dart';
import 'package:jaguar_mimetype/jaguar_mimetype.dart';

abstract class ApiClient {
  Route get base;

  final converters = <String, CodecRepo>{};

  CodecRepo<String> get jsonConverter => converters[MimeTypes.json];

  set jsonConverter(CodecRepo<String> value) =>
      converters[MimeTypes.json] = value;

  Future<T> decodeOne<T>(StringResponse response) async {
    String contentType = await response.mimeType ?? MimeTypes.json;

    CodecRepo converter = converters[contentType];
    if (converter == null)
      throw Exception("Converter for content type '$contentType' not found!");
    if (converter is CodecRepo<List<int>>) {
      return converter.decodeOne<T>(response.bytes);
    }
    return converter.decodeOne<T>(response.body);
  }

  Future<List<T>> decodeList<T>(StringResponse response) async {
    String contentType = await response.mimeType ?? MimeTypes.json;

    CodecRepo converter = converters[contentType];
    if (converter == null)
      throw Exception("Converter for content type '$contentType' not found!");
    if (converter is CodecRepo<List<int>>) {
      return converter.decodeList<T>(response.bytes);
    }
    return converter.decodeList<T>(response.body);
  }
}
