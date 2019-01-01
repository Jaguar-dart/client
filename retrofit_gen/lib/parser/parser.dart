import '../utils/utils.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/constant/value.dart';
import 'package:source_gen/source_gen.dart';
import '../parsed_info/parsed_info.dart';

Req _parseReq(String httpMethod, DartObject annot, MethodElement method) {
  final reader = ConstantReader(annot);
  String path = reader.read('path').stringValue;
  Map<String, String> metadata = reader.read('metadata').mapValue.map(
      (k, v) => MapEntry<String, String>(k.toStringValue(), toStringValue(v)));

  final pathParams = <String, String>{};
  final query = <String, String>{};
  final headers = <String, String>{};
  final queryMap = Set<String>();
  final headerMap = Set<String>();
  final body = List<Body>();
  final headerHook = <String, String>{};

  for (ParameterElement pe in method.parameters) {
    {
      DartObject pathParam = isPathParam.firstAnnotationOfExact(pe);
      if (pathParam != null) {
        pathParams[pathParam.getField('alias').toStringValue() ??
            pe.displayName] = pe.displayName;
      }
    }

    {
      DartObject qp = isQueryParam.firstAnnotationOfExact(pe);
      if (qp != null) {
        query[qp.getField('alias').toStringValue() ?? pe.displayName] =
            pe.displayName;
      }
    }

    {
      DartObject qp = isQueryMap.firstAnnotationOfExact(pe);
      if (qp != null) {
        queryMap.add(pe.displayName);
      }
    }

    {
      DartObject qp = isHeaderMap.firstAnnotationOfExact(pe);
      if (qp != null) {
        headerMap.add(pe.displayName);
      }
    }

    {
      DartObject hp = isHeader.firstAnnotationOfExact(pe);
      if (hp != null) {
        headers[hp.getField('alias').toStringValue() ?? pe.displayName] =
            pe.displayName;
      }
    }

    {
      DartObject isBody = isAsBody.firstAnnotationOfExact(pe);
      if (isBody != null) {
        body.add(RawBody(pe.displayName));
      }
    }

    {
      DartObject isSer = isSerialized.firstAnnotationOfExact(pe);
      if (isSer != null) {
        final contentType = isSer.getField('as')?.toStringValue();
        body.add(SerializedBody(pe.displayName, contentType));
      }
    }

    {
      DartObject json = isAsJson.firstAnnotationOfExact(pe);
      if (json != null) body.add(JsonBody(pe.displayName));
    }

    {
      DartObject form = isAsForm.firstAnnotationOfExact(pe);
      if (form != null) body.add(FormBody(pe.displayName));
    }

    {
      DartObject formField = isAsFormField.firstAnnotationOfExact(pe);
      if (formField != null)
        body.add(FormFieldBody(
            formField.getField('alias').toStringValue() ?? pe.displayName,
            pe.displayName));
    }

    {
      DartObject data = isAsMultipart.firstAnnotationOfExact(pe);
      if (data != null) {
        final serialize = data.getField("serialize").toBoolValue();
        body.add(MultipartForm(pe.displayName, serialize: serialize));
      }
    }

    {
      DartObject multipartField = isAsMultipartField.firstAnnotationOfExact(pe);
      if (multipartField != null)
        body.add(MultipartFormField(
            multipartField.getField('alias').toStringValue() ?? pe.displayName,
            pe.displayName));
    }

    {
      DartObject hp = isHeaderHook.firstAnnotationOfExact(pe);
      if (hp != null) {
        headerHook[hp.getField('alias').toStringValue() ?? pe.displayName] =
            pe.displayName;
      }
    }
  }

  return Req(httpMethod, method,
      path: path,
      query: query,
      metadata: metadata,
      headers: headers,
      body: body,
      pathParams: pathParams,
      queryMap: queryMap,
      headerMap: headerMap,
      headerHooks: headerHook);
}

WriteInfo parse(ClassElement element, ConstantReader annotation) {
  final an = isGenApiClient.firstAnnotationOfExact(element);
  final basePath = an.getField("path").toStringValue() ?? '';
  final baseMetadata = an.getField("metadata").toMapValue().map(
      (k, v) => MapEntry<String, String>(k.toStringValue(), toStringValue(v)));

  final reqs = <Req>[];

  for (MethodElement me in element.methods) {
    DartObject reqOb = isReq.firstAnnotationOf(me);

    if (isGetReq.isAssignableFromType(reqOb.type)) {
      reqs.add(_parseReq('get', reqOb, me));
    } else if (isPostReq.isAssignableFromType(reqOb.type)) {
      reqs.add(_parseReq('post', reqOb, me));
    } else if (isPutReq.isAssignableFromType(reqOb.type)) {
      reqs.add(_parseReq('put', reqOb, me));
    } else if (isDeleteReq.isAssignableFromType(reqOb.type)) {
      reqs.add(_parseReq('delete', reqOb, me));
    } else if (isHeadReq.isAssignableFromType(reqOb.type)) {
      reqs.add(_parseReq('head', reqOb, me));
    } else if (isPatchReq.isAssignableFromType(reqOb.type)) {
      reqs.add(_parseReq('patch', reqOb, me));
    }
  }

  return WriteInfo(element.displayName, basePath, baseMetadata, reqs);
}

String toStringValue(DartObject value) {
  if (value.isNull) {
    return 'null';
  } else if (value.toStringValue() != null) {
    return '"${value.toStringValue()}"';
  } else if (value.toBoolValue() != null) {
    return '${value.toBoolValue()}';
  } else if (value.toIntValue() != null) {
    return '${value.toIntValue()}';
  } else if (value.toDoubleValue() != null) {
    return '${value.toDoubleValue()}';
  } else if (value is Iterable || value.toListValue() != null) {
    return '[' + value.toListValue().map(toStringValue).join(',') + ']';
  } else if (value is Map || value.toMapValue() != null) {
    var sb = StringBuffer('{');
    value.toMapValue().forEach((k, v) {
      if (k.toStringValue() == null) {
        throw UnsupportedError("Key can only be String");
      }
      sb.write('"${k.toStringValue()}": ${toStringValue(v)},');
    });
    sb.write('}');
    return sb.toString();
  } else {
    throw UnsupportedError("Does not support ${value.type.displayName}");
  }
}
