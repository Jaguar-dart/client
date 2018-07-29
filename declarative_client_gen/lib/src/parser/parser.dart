import '../utils/utils.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/dart/constant/value.dart';
import 'package:source_gen/source_gen.dart';

abstract class Body {}

class JsonBody implements Body {}

class UrlEncodedForm implements Body {}

class MultipartForm implements Body {}

class Req {
  String name;

  String method;

  String path;

  Map<String, String> query;

  Map<String, String> headers;

  Body body;

  Req(this.name, this.method, {this.query, this.headers, this.body});
}

class WriteInfo {
  final String name;

  final List<Req> requests;

  WriteInfo(this.name, this.requests);
}

Req _parseGet(DartObject annot, MethodElement method) {
  // TODO
  return Req(method.displayName, 'get');
}

Req _parsePost(DartObject annot, MethodElement method) {
  // TODO
  return Req(method.displayName, 'post');
}

Req _parsePut(DartObject annot, MethodElement method) {
  // TODO
  return Req(method.displayName, 'put');
}

Req _parseDelete(DartObject annot, MethodElement method) {
  // TODO
  return Req(method.displayName, 'delete');
}

Req _parseHead(DartObject annot, MethodElement method) {
  // TODO
  return Req(method.displayName, 'head');
}

Req _parsePatch(DartObject annot, MethodElement method) {
  // TODO
  return Req(method.displayName, 'patch');
}

WriteInfo parse(ClassElement element, ConstantReader annotation) {
  final reqs = <Req>[];

  for (MethodElement me in element.methods) {
    DartObject reqOb = isReq.firstAnnotationOf(me);

    if (isGetReq.isAssignableFromType(reqOb.type)) {
      reqs.add(_parseGet(reqOb, me));
    } else if (isPostReq.isAssignableFromType(reqOb.type)) {
      reqs.add(_parsePost(reqOb, me));
    } else if (isPutReq.isAssignableFromType(reqOb.type)) {
      reqs.add(_parsePut(reqOb, me));
    } else if (isDeleteReq.isAssignableFromType(reqOb.type)) {
      reqs.add(_parseDelete(reqOb, me));
    } else if (isHeadReq.isAssignableFromType(reqOb.type)) {
      reqs.add(_parseHead(reqOb, me));
    } else if (isPatchReq.isAssignableFromType(reqOb.type)) {
      reqs.add(_parsePatch(reqOb, me));
    }
  }

  return WriteInfo(element.displayName, reqs);
}
