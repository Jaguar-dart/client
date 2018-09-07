// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'serializer.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$OpenApiSerializer implements Serializer<OpenApi> {
  Serializer<Info> __infoSerializer;
  Serializer<Info> get _infoSerializer =>
      __infoSerializer ??= new InfoSerializer();
  Serializer<Server> __serverSerializer;
  Serializer<Server> get _serverSerializer =>
      __serverSerializer ??= new ServerSerializer();
  Serializer<PathItem> __pathItemSerializer;
  Serializer<PathItem> get _pathItemSerializer =>
      __pathItemSerializer ??= new PathItemSerializer();
  Serializer<Tag> __tagSerializer;
  Serializer<Tag> get _tagSerializer => __tagSerializer ??= new TagSerializer();
  @override
  Map<String, dynamic> toMap(OpenApi model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValueIfNotNull(ret, 'openapi', model.openapi);
    setMapValueIfNotNull(ret, 'info', _infoSerializer.toMap(model.info));
    setMapValueIfNotNull(
        ret,
        'servers',
        codeNonNullIterable(model.servers,
            (val) => _serverSerializer.toMap(val as Server), []));
    setMapValueIfNotNull(
        ret,
        'paths',
        codeNonNullMap(
            model.paths,
            (val) => _pathItemSerializer.toMap(val as PathItem),
            <String, dynamic>{}));
    setMapValueIfNotNull(
        ret,
        'tags',
        codeNonNullIterable(
            model.tags, (val) => _tagSerializer.toMap(val as Tag), []));
    return ret;
  }

  @override
  OpenApi fromMap(Map map) {
    if (map == null) return null;
    final obj = new OpenApi(
        openapi: map['openapi'] as String ?? getJserDefault('openapi'),
        info: _infoSerializer.fromMap(map['info'] as Map) ??
            getJserDefault('info'),
        servers: codeNonNullIterable<Server>(map['servers'] as Iterable,
                (val) => _serverSerializer.fromMap(val as Map), <Server>[]) ??
            getJserDefault('servers'),
        paths: codeNonNullMap<PathItem>(
                map['paths'] as Map,
                (val) => _pathItemSerializer.fromMap(val as Map),
                <String, PathItem>{}) ??
            getJserDefault('paths'),
        tags: codeNonNullIterable<Tag>(map['tags'] as Iterable,
                (val) => _tagSerializer.fromMap(val as Map), <Tag>[]) ??
            getJserDefault('tags'));
    return obj;
  }
}

abstract class _$InfoSerializer implements Serializer<Info> {
  Serializer<Contact> __contactSerializer;
  Serializer<Contact> get _contactSerializer =>
      __contactSerializer ??= new ContactSerializer();
  Serializer<License> __licenseSerializer;
  Serializer<License> get _licenseSerializer =>
      __licenseSerializer ??= new LicenseSerializer();
  @override
  Map<String, dynamic> toMap(Info model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValueIfNotNull(ret, 'title', model.title);
    setMapValueIfNotNull(ret, 'description', model.description);
    setMapValueIfNotNull(ret, 'termsOfService', model.termsOfService);
    setMapValueIfNotNull(
        ret, 'contact', _contactSerializer.toMap(model.contact));
    setMapValueIfNotNull(
        ret, 'license', _licenseSerializer.toMap(model.license));
    setMapValueIfNotNull(ret, 'version', model.version);
    return ret;
  }

  @override
  Info fromMap(Map map) {
    if (map == null) return null;
    final obj = new Info(
        title: map['title'] as String ?? getJserDefault('title'),
        description:
            map['description'] as String ?? getJserDefault('description'),
        termsOfService:
            map['termsOfService'] as String ?? getJserDefault('termsOfService'),
        contact: _contactSerializer.fromMap(map['contact'] as Map) ??
            getJserDefault('contact'),
        license: _licenseSerializer.fromMap(map['license'] as Map) ??
            getJserDefault('license'),
        version: map['version'] as String ?? getJserDefault('version'));
    return obj;
  }
}

abstract class _$ContactSerializer implements Serializer<Contact> {
  @override
  Map<String, dynamic> toMap(Contact model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValueIfNotNull(ret, 'name', model.name);
    setMapValueIfNotNull(ret, 'url', model.url);
    setMapValueIfNotNull(ret, 'email', model.email);
    return ret;
  }

  @override
  Contact fromMap(Map map) {
    if (map == null) return null;
    final obj = new Contact(
        name: map['name'] as String ?? getJserDefault('name'),
        url: map['url'] as String ?? getJserDefault('url'),
        email: map['email'] as String ?? getJserDefault('email'));
    return obj;
  }
}

abstract class _$TagSerializer implements Serializer<Tag> {
  @override
  Map<String, dynamic> toMap(Tag model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValueIfNotNull(ret, 'name', model.name);
    setMapValueIfNotNull(ret, 'description', model.description);
    return ret;
  }

  @override
  Tag fromMap(Map map) {
    if (map == null) return null;
    final obj = new Tag(
        name: map['name'] as String ?? getJserDefault('name'),
        description:
            map['description'] as String ?? getJserDefault('description'));
    return obj;
  }
}

abstract class _$LicenseSerializer implements Serializer<License> {
  @override
  Map<String, dynamic> toMap(License model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValueIfNotNull(ret, 'name', model.name);
    setMapValueIfNotNull(ret, 'url', model.url);
    return ret;
  }

  @override
  License fromMap(Map map) {
    if (map == null) return null;
    final obj = new License(
        name: map['name'] as String ?? getJserDefault('name'),
        url: map['url'] as String ?? getJserDefault('url'));
    return obj;
  }
}

abstract class _$ServerSerializer implements Serializer<Server> {
  @override
  Map<String, dynamic> toMap(Server model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValueIfNotNull(ret, 'url', model.url);
    setMapValueIfNotNull(ret, 'description', model.description);
    return ret;
  }

  @override
  Server fromMap(Map map) {
    if (map == null) return null;
    final obj = new Server(
        url: map['url'] as String ?? getJserDefault('url'),
        description:
            map['description'] as String ?? getJserDefault('description'));
    return obj;
  }
}

abstract class _$PathItemSerializer implements Serializer<PathItem> {
  Serializer<Operation> __operationSerializer;
  Serializer<Operation> get _operationSerializer =>
      __operationSerializer ??= new OperationSerializer();
  Serializer<Parameter> __parameterSerializer;
  Serializer<Parameter> get _parameterSerializer =>
      __parameterSerializer ??= new ParameterSerializer();
  @override
  Map<String, dynamic> toMap(PathItem model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValueIfNotNull(ret, 'summary', model.summary);
    setMapValueIfNotNull(ret, 'description', model.description);
    setMapValueIfNotNull(ret, 'get', _operationSerializer.toMap(model.get));
    setMapValueIfNotNull(ret, 'put', _operationSerializer.toMap(model.put));
    setMapValueIfNotNull(ret, 'post', _operationSerializer.toMap(model.post));
    setMapValueIfNotNull(
        ret, 'delete', _operationSerializer.toMap(model.delete));
    setMapValueIfNotNull(
        ret, 'options', _operationSerializer.toMap(model.options));
    setMapValueIfNotNull(ret, 'head', _operationSerializer.toMap(model.head));
    setMapValueIfNotNull(ret, 'patch', _operationSerializer.toMap(model.patch));
    setMapValueIfNotNull(ret, 'trace', _operationSerializer.toMap(model.trace));
    setMapValueIfNotNull(
        ret,
        'parameters',
        codeNonNullIterable(model.parameters,
            (val) => _parameterSerializer.toMap(val as Parameter), []));
    return ret;
  }

  @override
  PathItem fromMap(Map map) {
    if (map == null) return null;
    final obj = new PathItem(
        summary: map['summary'] as String ?? getJserDefault('summary'),
        description:
            map['description'] as String ?? getJserDefault('description'),
        get: _operationSerializer.fromMap(map['get'] as Map) ??
            getJserDefault('get'),
        put: _operationSerializer.fromMap(map['put'] as Map) ??
            getJserDefault('put'),
        post: _operationSerializer.fromMap(map['post'] as Map) ??
            getJserDefault('post'),
        delete: _operationSerializer.fromMap(map['delete'] as Map) ??
            getJserDefault('delete'),
        options: _operationSerializer.fromMap(map['options'] as Map) ??
            getJserDefault('options'),
        head: _operationSerializer.fromMap(map['head'] as Map) ??
            getJserDefault('head'),
        patch: _operationSerializer.fromMap(map['patch'] as Map) ??
            getJserDefault('patch'),
        trace: _operationSerializer.fromMap(map['trace'] as Map) ??
            getJserDefault('trace'),
        parameters: codeNonNullIterable<Parameter>(
                map['parameters'] as Iterable,
                (val) => _parameterSerializer.fromMap(val as Map),
                <Parameter>[]) ??
            getJserDefault('parameters'));
    return obj;
  }
}

abstract class _$OperationSerializer implements Serializer<Operation> {
  Serializer<Parameter> __parameterSerializer;
  Serializer<Parameter> get _parameterSerializer =>
      __parameterSerializer ??= new ParameterSerializer();
  Serializer<Request> __requestSerializer;
  Serializer<Request> get _requestSerializer =>
      __requestSerializer ??= new RequestSerializer();
  Serializer<Response> __responseSerializer;
  Serializer<Response> get _responseSerializer =>
      __responseSerializer ??= new ResponseSerializer();
  @override
  Map<String, dynamic> toMap(Operation model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValueIfNotNull(ret, 'tags',
        codeNonNullIterable(model.tags, (val) => val as String, []));
    setMapValueIfNotNull(ret, 'summary', model.summary);
    setMapValueIfNotNull(ret, 'description', model.description);
    setMapValueIfNotNull(ret, 'operationId', model.operationId);
    setMapValueIfNotNull(
        ret,
        'parameters',
        codeNonNullIterable(model.parameters,
            (val) => _parameterSerializer.toMap(val as Parameter), []));
    setMapValueIfNotNull(
        ret, 'requestBody', _requestSerializer.toMap(model.requestBody));
    setMapValueIfNotNull(
        ret,
        'response',
        codeNonNullMap(
            model.response,
            (val) => _responseSerializer.toMap(val as Response),
            <String, dynamic>{}));
    setMapValueIfNotNull(ret, 'deprecated', model.deprecated);
    return ret;
  }

  @override
  Operation fromMap(Map map) {
    if (map == null) return null;
    final obj = new Operation(
        tags:
            codeNonNullIterable<String>(map['tags'] as Iterable, (val) => val as String, <String>[]) ??
                getJserDefault('tags'),
        summary: map['summary'] as String ?? getJserDefault('summary'),
        description:
            map['description'] as String ?? getJserDefault('description'),
        operationId:
            map['operationId'] as String ?? getJserDefault('operationId'),
        parameters: codeNonNullIterable<Parameter>(
                map['parameters'] as Iterable,
                (val) => _parameterSerializer.fromMap(val as Map),
                <Parameter>[]) ??
            getJserDefault('parameters'),
        requestBody: _requestSerializer.fromMap(map['requestBody'] as Map) ??
            getJserDefault('requestBody'),
        response: codeNonNullMap<Response>(
                map['response'] as Map,
                (val) => _responseSerializer.fromMap(val as Map),
                <String, Response>{}) ??
            getJserDefault('response'),
        deprecated: map['deprecated'] as bool ?? getJserDefault('deprecated'));
    return obj;
  }
}

abstract class _$SchemaSerializer implements Serializer<Schema> {
  @override
  Map<String, dynamic> toMap(Schema model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    return ret;
  }

  @override
  Schema fromMap(Map map) {
    if (map == null) return null;
    final obj = new Schema();
    return obj;
  }
}

abstract class _$ParameterSerializer implements Serializer<Parameter> {
  Serializer<Schema> __schemaSerializer;
  Serializer<Schema> get _schemaSerializer =>
      __schemaSerializer ??= new SchemaSerializer();
  @override
  Map<String, dynamic> toMap(Parameter model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValueIfNotNull(ret, 'name', model.name);
    setMapValueIfNotNull(ret, 'in_', model.in_);
    setMapValueIfNotNull(ret, 'description', model.description);
    setMapValueIfNotNull(ret, 'required', model.required);
    setMapValueIfNotNull(ret, 'deprecated', model.deprecated);
    setMapValueIfNotNull(ret, 'allowEmptyValue', model.allowEmptyValue);
    setMapValueIfNotNull(ret, 'style', model.style);
    setMapValueIfNotNull(ret, 'explode', model.explode);
    setMapValueIfNotNull(ret, 'allowReserved', model.allowReserved);
    setMapValueIfNotNull(ret, 'schema', _schemaSerializer.toMap(model.schema));
    setMapValueIfNotNull(
        ret, 'example', passProcessor.serialize(model.example));
    setMapValueIfNotNull(
        ret,
        'examples',
        codeNonNullMap(model.examples, (val) => passProcessor.serialize(val),
            <String, dynamic>{}));
    return ret;
  }

  @override
  Parameter fromMap(Map map) {
    if (map == null) return null;
    final obj = new Parameter(
        name: map['name'] as String ?? getJserDefault('name'),
        in_: map['in_'] as String ?? getJserDefault('in_'),
        description:
            map['description'] as String ?? getJserDefault('description'),
        required: map['required'] as bool ?? getJserDefault('required'),
        deprecated: map['deprecated'] as bool ?? getJserDefault('deprecated'),
        allowEmptyValue:
            map['allowEmptyValue'] as bool ?? getJserDefault('allowEmptyValue'),
        style: map['style'] as String ?? getJserDefault('style'),
        explode: map['explode'] as bool ?? getJserDefault('explode'),
        allowReserved:
            map['allowReserved'] as bool ?? getJserDefault('allowReserved'),
        schema: _schemaSerializer.fromMap(map['schema'] as Map) ??
            getJserDefault('schema'),
        example: passProcessor.deserialize(map['example']) ??
            getJserDefault('example'),
        examples: codeNonNullMap<dynamic>(map['examples'] as Map,
                (val) => passProcessor.deserialize(val), <String, dynamic>{}) ??
            getJserDefault('examples'));
    return obj;
  }
}

abstract class _$HeaderSerializer implements Serializer<Header> {
  Serializer<Schema> __schemaSerializer;
  Serializer<Schema> get _schemaSerializer =>
      __schemaSerializer ??= new SchemaSerializer();
  @override
  Map<String, dynamic> toMap(Header model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValueIfNotNull(ret, 'description', model.description);
    setMapValueIfNotNull(ret, 'required', model.required);
    setMapValueIfNotNull(ret, 'deprecated', model.deprecated);
    setMapValueIfNotNull(ret, 'allowEmptyValue', model.allowEmptyValue);
    setMapValueIfNotNull(ret, 'style', model.style);
    setMapValueIfNotNull(ret, 'explode', model.explode);
    setMapValueIfNotNull(ret, 'allowReserved', model.allowReserved);
    setMapValueIfNotNull(ret, 'schema', _schemaSerializer.toMap(model.schema));
    setMapValueIfNotNull(
        ret, 'example', passProcessor.serialize(model.example));
    setMapValueIfNotNull(
        ret,
        'examples',
        codeNonNullMap(model.examples, (val) => passProcessor.serialize(val),
            <String, dynamic>{}));
    return ret;
  }

  @override
  Header fromMap(Map map) {
    if (map == null) return null;
    final obj = new Header(
        description:
            map['description'] as String ?? getJserDefault('description'),
        required: map['required'] as bool ?? getJserDefault('required'),
        deprecated: map['deprecated'] as bool ?? getJserDefault('deprecated'),
        allowEmptyValue:
            map['allowEmptyValue'] as bool ?? getJserDefault('allowEmptyValue'),
        style: map['style'] as String ?? getJserDefault('style'),
        explode: map['explode'] as bool ?? getJserDefault('explode'),
        allowReserved:
            map['allowReserved'] as bool ?? getJserDefault('allowReserved'),
        schema: _schemaSerializer.fromMap(map['schema'] as Map) ??
            getJserDefault('schema'),
        example: passProcessor.deserialize(map['example']) ??
            getJserDefault('example'),
        examples: codeNonNullMap<dynamic>(map['examples'] as Map,
                (val) => passProcessor.deserialize(val), <String, dynamic>{}) ??
            getJserDefault('examples'));
    return obj;
  }
}

abstract class _$MediaTypeSerializer implements Serializer<MediaType> {
  Serializer<Schema> __schemaSerializer;
  Serializer<Schema> get _schemaSerializer =>
      __schemaSerializer ??= new SchemaSerializer();
  @override
  Map<String, dynamic> toMap(MediaType model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValueIfNotNull(ret, 'schema', _schemaSerializer.toMap(model.schema));
    setMapValueIfNotNull(
        ret, 'example', passProcessor.serialize(model.example));
    setMapValueIfNotNull(
        ret,
        'examples',
        codeNonNullMap(model.examples, (val) => passProcessor.serialize(val),
            <String, dynamic>{}));
    return ret;
  }

  @override
  MediaType fromMap(Map map) {
    if (map == null) return null;
    final obj = new MediaType(
        schema: _schemaSerializer.fromMap(map['schema'] as Map) ??
            getJserDefault('schema'),
        example: passProcessor.deserialize(map['example']) ??
            getJserDefault('example'),
        examples: codeNonNullMap<dynamic>(map['examples'] as Map,
                (val) => passProcessor.deserialize(val), <String, dynamic>{}) ??
            getJserDefault('examples'));
    return obj;
  }
}

abstract class _$ResponseSerializer implements Serializer<Response> {
  Serializer<Header> __headerSerializer;
  Serializer<Header> get _headerSerializer =>
      __headerSerializer ??= new HeaderSerializer();
  Serializer<MediaType> __mediaTypeSerializer;
  Serializer<MediaType> get _mediaTypeSerializer =>
      __mediaTypeSerializer ??= new MediaTypeSerializer();
  @override
  Map<String, dynamic> toMap(Response model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValueIfNotNull(ret, 'description', model.description);
    setMapValueIfNotNull(
        ret,
        'headers',
        codeNonNullMap(
            model.headers,
            (val) => _headerSerializer.toMap(val as Header),
            <String, dynamic>{}));
    setMapValueIfNotNull(
        ret,
        'mediaType',
        codeNonNullMap(
            model.mediaType,
            (val) => _mediaTypeSerializer.toMap(val as MediaType),
            <String, dynamic>{}));
    return ret;
  }

  @override
  Response fromMap(Map map) {
    if (map == null) return null;
    final obj = new Response(
        description:
            map['description'] as String ?? getJserDefault('description'),
        headers: codeNonNullMap<Header>(
                map['headers'] as Map,
                (val) => _headerSerializer.fromMap(val as Map),
                <String, Header>{}) ??
            getJserDefault('headers'),
        mediaType: codeNonNullMap<MediaType>(
                map['mediaType'] as Map,
                (val) => _mediaTypeSerializer.fromMap(val as Map),
                <String, MediaType>{}) ??
            getJserDefault('mediaType'));
    return obj;
  }
}

abstract class _$RequestSerializer implements Serializer<Request> {
  Serializer<MediaType> __mediaTypeSerializer;
  Serializer<MediaType> get _mediaTypeSerializer =>
      __mediaTypeSerializer ??= new MediaTypeSerializer();
  @override
  Map<String, dynamic> toMap(Request model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValueIfNotNull(ret, 'description', model.description);
    setMapValueIfNotNull(
        ret,
        'content',
        codeNonNullMap(
            model.content,
            (val) => _mediaTypeSerializer.toMap(val as MediaType),
            <String, dynamic>{}));
    setMapValueIfNotNull(ret, 'required', model.required);
    return ret;
  }

  @override
  Request fromMap(Map map) {
    if (map == null) return null;
    final obj = new Request(
        description:
            map['description'] as String ?? getJserDefault('description'),
        content: codeNonNullMap<MediaType>(
                map['content'] as Map,
                (val) => _mediaTypeSerializer.fromMap(val as Map),
                <String, MediaType>{}) ??
            getJserDefault('content'),
        required: map['required'] as bool ?? getJserDefault('required'));
    return obj;
  }
}
