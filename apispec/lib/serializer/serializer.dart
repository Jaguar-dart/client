import '../models/models.dart';
import 'package:jaguar_serializer/jaguar_serializer.dart';

part 'serializer.jser.dart';

@GenSerializer()
class OpenApiSerializer extends Serializer<OpenApi> with _$OpenApiSerializer {}

final OpenApiSerializer openApiSerializer = OpenApiSerializer();

@GenSerializer()
class InfoSerializer extends Serializer<Info> with _$InfoSerializer {}

@GenSerializer()
class ContactSerializer extends Serializer<Contact> with _$ContactSerializer {}

@GenSerializer()
class TagSerializer extends Serializer<Tag> with _$TagSerializer {}

@GenSerializer()
class LicenseSerializer extends Serializer<License> with _$LicenseSerializer {}

@GenSerializer()
class PathItemSerializer extends Serializer<PathItem>
    with _$PathItemSerializer {}

@GenSerializer()
class OperationSerializer extends Serializer<Operation>
    with _$OperationSerializer {}

@GenSerializer()
class SchemaSerializer extends Serializer<Schema> with _$SchemaSerializer {}

@GenSerializer()
class HeaderSerializer extends Serializer<Header> with _$HeaderSerializer {}

@GenSerializer()
class MediaTypeSerializer extends Serializer<MediaType>
    with _$MediaTypeSerializer {}

@GenSerializer()
class ResponseSerializer extends Serializer<Response>
    with _$ResponseSerializer {}

@GenSerializer()
class RequestSerializer extends Serializer<Request> with _$RequestSerializer {}
