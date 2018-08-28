import 'package:source_gen/source_gen.dart';
import 'package:jaguar_retrofit/jaguar_retrofit.dart';
import 'package:analyzer/dart/element/type.dart';

const isReq = const TypeChecker.fromRuntime(Req);
const isGetReq = const TypeChecker.fromRuntime(GetReq);
const isPostReq = const TypeChecker.fromRuntime(PostReq);
const isPutReq = const TypeChecker.fromRuntime(PutReq);
const isDeleteReq = const TypeChecker.fromRuntime(DeleteReq);
const isHeadReq = const TypeChecker.fromRuntime(HeadReq);
const isPatchReq = const TypeChecker.fromRuntime(PatchReq);

const isQueryParam = const TypeChecker.fromRuntime(QueryParam);
const isQueryMap = const TypeChecker.fromRuntime(QueryMap);
const isHeader = const TypeChecker.fromRuntime(Header);
const isHeaderMap = const TypeChecker.fromRuntime(HeaderMap);
const isAsJson = const TypeChecker.fromRuntime(AsJson);
const isAsMultipart = const TypeChecker.fromRuntime(AsMultipart);

const isList = const TypeChecker.fromRuntime(List);
const isMap = const TypeChecker.fromRuntime(Map);
const isInt = const TypeChecker.fromRuntime(int);
const isDouble = const TypeChecker.fromRuntime(double);
const isNum = const TypeChecker.fromRuntime(num);
const isBool = const TypeChecker.fromRuntime(bool);
const isString = const TypeChecker.fromRuntime(String);

bool isBuiltin(DartType type) =>
    isInt.isExactlyType(type) ||
    isDouble.isExactlyType(type) ||
    isNum.isExactlyType(type) ||
    isBool.isExactlyType(type) ||
    isString.isExactlyType(type);
