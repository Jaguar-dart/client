import 'package:source_gen/source_gen.dart';
import 'package:jaguar_serializer/jaguar_serializer.dart';
import 'package:jaguar_http/jaguar_http.dart';
import 'package:analyzer/dart/element/type.dart';

const isGetReq = const TypeChecker.fromRuntime(GetReq);
const isPostReq = const TypeChecker.fromRuntime(PostReq);
const isPutReq = const TypeChecker.fromRuntime(PutReq);
const isDeleteReq = const TypeChecker.fromRuntime(DeleteReq);
const isHeadReq = const TypeChecker.fromRuntime(HeadReq);
const isPatchReq = const TypeChecker.fromRuntime(PatchReq);

const isPath = const TypeChecker.fromRuntime(Path);
const isQueryParam = const TypeChecker.fromRuntime(QueryParam);
const isHeader = const TypeChecker.fromRuntime(Header);
const isBody = const TypeChecker.fromRuntime(Body);