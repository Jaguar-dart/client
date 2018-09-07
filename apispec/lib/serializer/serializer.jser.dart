// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'serializer.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$OpenApiSerializer implements Serializer<OpenApi> {
  Serializer<Info> __infoSerializer;
  Serializer<Info> get _infoSerializer =>
      __infoSerializer ??= new InfoSerializer();
  Serializer<PathItem> __pathItemSerializer;
  Serializer<PathItem> get _pathItemSerializer =>
      __pathItemSerializer ??= new PathItemSerializer();
  Serializer<Tag> __tagSerializer;
  Serializer<Tag> get _tagSerializer => __tagSerializer ??= new TagSerializer();
  @override
  Map<String, dynamic> toMap(OpenApi model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'openapi', model.openapi);
    setMapValue(ret, 'info', _infoSerializer.toMap(model.info));
    setMapValue(
        ret,
        'paths',
        codeIterable(
            model.paths, (val) => _pathItemSerializer.toMap(val as PathItem)));
    setMapValue(ret, 'tags',
        codeIterable(model.tags, (val) => _tagSerializer.toMap(val as Tag)));
    return ret;
  }

  @override
  OpenApi fromMap(Map map) {
    if (map == null) return null;
    final obj = new OpenApi(
        openapi: map['openapi'] as String ?? getJserDefault('openapi'),
        info: _infoSerializer.fromMap(map['info'] as Map) ??
            getJserDefault('info'),
        tags: codeIterable<Tag>(map['tags'] as Iterable,
                (val) => _tagSerializer.fromMap(val as Map)) ??
            getJserDefault('tags'),
        paths: codeIterable<PathItem>(map['paths'] as Iterable,
                (val) => _pathItemSerializer.fromMap(val as Map)) ??
            getJserDefault('paths'));
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
    setMapValue(ret, 'title', model.title);
    setMapValue(ret, 'description', model.description);
    setMapValue(ret, 'termsOfService', model.termsOfService);
    setMapValue(ret, 'contact', _contactSerializer.toMap(model.contact));
    setMapValue(ret, 'license', _licenseSerializer.toMap(model.license));
    setMapValue(ret, 'version', model.version);
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
    setMapValue(ret, 'name', model.name);
    setMapValue(ret, 'url', model.url);
    setMapValue(ret, 'email', model.email);
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
    setMapValue(ret, 'name', model.name);
    setMapValue(ret, 'description', model.description);
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
    setMapValue(ret, 'name', model.name);
    setMapValue(ret, 'url', model.url);
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

abstract class _$PathItemSerializer implements Serializer<PathItem> {
  Serializer<Operation> __operationSerializer;
  Serializer<Operation> get _operationSerializer =>
      __operationSerializer ??= new OperationSerializer();
  @override
  Map<String, dynamic> toMap(PathItem model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'summary', model.summary);
    setMapValue(ret, 'description', model.description);
    setMapValue(ret, 'get', _operationSerializer.toMap(model.get));
    setMapValue(ret, 'put', _operationSerializer.toMap(model.put));
    setMapValue(ret, 'post', _operationSerializer.toMap(model.post));
    setMapValue(ret, 'delete', _operationSerializer.toMap(model.delete));
    setMapValue(ret, 'options', _operationSerializer.toMap(model.options));
    setMapValue(ret, 'head', _operationSerializer.toMap(model.head));
    setMapValue(ret, 'patch', _operationSerializer.toMap(model.patch));
    setMapValue(ret, 'trace', _operationSerializer.toMap(model.trace));
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
            getJserDefault('trace'));
    return obj;
  }
}

abstract class _$OperationSerializer implements Serializer<Operation> {
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
    setMapValue(ret, 'tags', codeIterable(model.tags, (val) => val as String));
    setMapValue(ret, 'summary', model.summary);
    setMapValue(ret, 'description', model.description);
    setMapValue(ret, 'operationId', model.operationId);
    setMapValue(ret, 'request', _requestSerializer.toMap(model.request));
    setMapValue(
        ret,
        'response',
        codeMap(model.response,
            (val) => _responseSerializer.toMap(val as Response)));
    setMapValue(ret, 'deprecated', model.deprecated);
    return ret;
  }

  @override
  Operation fromMap(Map map) {
    if (map == null) return null;
    final obj = new Operation(
        tags: codeIterable<String>(
                map['tags'] as Iterable, (val) => val as String) ??
            getJserDefault('tags'),
        summary: map['summary'] as String ?? getJserDefault('summary'),
        description:
            map['description'] as String ?? getJserDefault('description'),
        operationId:
            map['operationId'] as String ?? getJserDefault('operationId'),
        request: _requestSerializer.fromMap(map['request'] as Map) ??
            getJserDefault('request'),
        response: codeMap<Response>(map['response'] as Map,
                (val) => _responseSerializer.fromMap(val as Map)) ??
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

abstract class _$HeaderSerializer implements Serializer<Header> {
  Serializer<Schema> __schemaSerializer;
  Serializer<Schema> get _schemaSerializer =>
      __schemaSerializer ??= new SchemaSerializer();
  @override
  Map<String, dynamic> toMap(Header model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'description', model.description);
    setMapValue(ret, 'required', model.required);
    setMapValue(ret, 'deprecated', model.deprecated);
    setMapValue(ret, 'allowEmptyValue', model.allowEmptyValue);
    setMapValue(ret, 'style', model.style);
    setMapValue(ret, 'explode', model.explode);
    setMapValue(ret, 'allowReserved', model.allowReserved);
    setMapValue(ret, 'schema', _schemaSerializer.toMap(model.schema));
    setMapValue(ret, 'example', passProcessor.serialize(model.example));
    setMapValue(ret, 'examples',
        codeMap(model.examples, (val) => passProcessor.serialize(val)));
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
        examples: codeMap<dynamic>(map['examples'] as Map,
                (val) => passProcessor.deserialize(val)) ??
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
    setMapValue(ret, 'schema', _schemaSerializer.toMap(model.schema));
    setMapValue(ret, 'example', passProcessor.serialize(model.example));
    setMapValue(ret, 'examples',
        codeMap(model.examples, (val) => passProcessor.serialize(val)));
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
        examples: codeMap<dynamic>(map['examples'] as Map,
                (val) => passProcessor.deserialize(val)) ??
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
    setMapValue(ret, 'description', model.description);
    setMapValue(
        ret,
        'headers',
        codeMap(
            model.headers, (val) => _headerSerializer.toMap(val as Header)));
    setMapValue(
        ret,
        'mediaType',
        codeMap(model.mediaType,
            (val) => _mediaTypeSerializer.toMap(val as MediaType)));
    return ret;
  }

  @override
  Response fromMap(Map map) {
    if (map == null) return null;
    final obj = new Response(
        description:
            map['description'] as String ?? getJserDefault('description'),
        headers: codeMap<Header>(map['headers'] as Map,
                (val) => _headerSerializer.fromMap(val as Map)) ??
            getJserDefault('headers'),
        mediaType: codeMap<MediaType>(map['mediaType'] as Map,
                (val) => _mediaTypeSerializer.fromMap(val as Map)) ??
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
    setMapValue(ret, 'description', model.description);
    setMapValue(
        ret,
        'content',
        codeMap(model.content,
            (val) => _mediaTypeSerializer.toMap(val as MediaType)));
    setMapValue(ret, 'required', model.required);
    return ret;
  }

  @override
  Request fromMap(Map map) {
    if (map == null) return null;
    final obj = new Request(
        description:
            map['description'] as String ?? getJserDefault('description'),
        content: codeMap<MediaType>(map['content'] as Map,
                (val) => _mediaTypeSerializer.fromMap(val as Map)) ??
            getJserDefault('content'),
        required: map['required'] as bool ?? getJserDefault('required'));
    return obj;
  }
}
