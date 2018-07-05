library jaguar_http.definitions;

import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:jaguar_serializer/jaguar_serializer.dart';
import 'package:jaguar_client/jaguar_client.dart';

class JaguarHttp {
  const JaguarHttp();
}

class GetReq {
  final String url;
  const GetReq([this.url = ""]);
}

class PostReq {
  final String url;
  const PostReq([this.url = ""]);
}

class PutReq {
  final String url;
  const PutReq([this.url = ""]);
}

class DeleteReq {
  final String url;
  const DeleteReq([this.url = ""]);
}

class HeadReq {
  final String url;
  const HeadReq([this.url = ""]);
}

class PatchReq {
  final String url;
  const PatchReq([this.url = "/"]);
}

class Path {
  final String name;
  const Path([this.name]);
}

class QueryParam {
  final String name;

  const QueryParam([this.name]);
}

class Header {
  const Header();
}

class Body {
  const Body();
}

abstract class ApiClient {
  // final Map headers;
  Route base;
  SerializerRepo serializers;

  ApiClient(this.base, this.serializers);
}
