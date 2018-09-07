import '../models/models.dart';
import 'package:jaguar_serializer/jaguar_serializer.dart';

part 'serializer.jser.dart';

@GenSerializer(nullableFields: false)
class OpenApiSerializer extends Serializer<OpenApi> with _$OpenApiSerializer {}

final OpenApiSerializer openApiSerializer = OpenApiSerializer();

@GenSerializer(nullableFields: false)
class InfoSerializer extends Serializer<Info> with _$InfoSerializer {}

@GenSerializer(nullableFields: false)
class ContactSerializer extends Serializer<Contact> with _$ContactSerializer {}

@GenSerializer(nullableFields: false)
class TagSerializer extends Serializer<Tag> with _$TagSerializer {}

@GenSerializer(nullableFields: false)
class LicenseSerializer extends Serializer<License> with _$LicenseSerializer {}

@GenSerializer(nullableFields: false)
class ServerSerializer extends Serializer<Server> with _$ServerSerializer {}

@GenSerializer(nullableFields: false)
class PathItemSerializer extends Serializer<PathItem>
    with _$PathItemSerializer {}

@GenSerializer(nullableFields: false)
class OperationSerializer extends Serializer<Operation>
    with _$OperationSerializer {}

@GenSerializer(nullableFields: false, fields: {"enumerated": Alias("enum")})
class SchemaSerializer extends Serializer<Schema> with _$SchemaSerializer {}

@GenSerializer(nullableFields: false, fields: {"in_": Alias("in")})
class ParameterSerializer extends Serializer<Parameter>
    with _$ParameterSerializer {}

@GenSerializer(nullableFields: false)
class HeaderSerializer extends Serializer<Header> with _$HeaderSerializer {}

@GenSerializer(nullableFields: false)
class MediaTypeSerializer extends Serializer<MediaType>
    with _$MediaTypeSerializer {}

@GenSerializer(nullableFields: false)
class ResponseSerializer extends Serializer<Response>
    with _$ResponseSerializer {}

@GenSerializer(nullableFields: false)
class RequestSerializer extends Serializer<Request> with _$RequestSerializer {}
