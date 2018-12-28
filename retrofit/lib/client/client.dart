library jaguar.retrofit.client;

import 'dart:async';
import 'package:jaguar_serializer/jaguar_serializer.dart';
import 'package:jaguar_resty/jaguar_resty.dart';

abstract class ApiClient {
  Route get base;
  JsonRepo get jsonConverter;

  final converters = <String, CodecRepo>{};

  Future<T> decodeOne<T>(StringResponse response) async {
    String contentType = await response.mimeType;
    if (jsonConverter != null) {
      if (contentType == null ||
          contentType.isEmpty ||
          contentType == "application/json") {
        return jsonConverter.decodeOne<T>(response.body);
      }
    }

    CodecRepo converter = converters[contentType];
    if (converter == null)
      throw Exception("Converter for content type '$contentType' not found!");
    if (converter is CodecRepo<List<int>>) {
      return converter.decodeOne<T>(response.bytes);
    }
    return converter.decodeOne<T>(response.bytes);
  }

  Future<List<T>> decodeList<T>(StringResponse response) async {
    String contentType = await response.mimeType;
    if (jsonConverter != null) {
      if (contentType == null ||
          contentType.isEmpty ||
          contentType == "application/json") {
        return jsonConverter.decodeList<T>(response.body);
      }
    }

    CodecRepo converter = converters[contentType];
    if (converter == null)
      throw Exception("Converter for content type '$contentType' not found!");
    if (converter is CodecRepo<List<int>>) {
      return converter.decodeList<T>(response.bytes);
    }
    return converter.decodeList<T>(response.bytes);
  }
}
