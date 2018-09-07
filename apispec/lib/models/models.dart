import '../serializer/serializer.dart';

class OpenApi {
  final String openapi;

  final Info info;

  final List<Server> servers;

  final Map<String, PathItem> paths;

  // TODO components

  // TODO security

  final List<Tag> tags;

  // TODO externalDocs

  const OpenApi(
      {this.openapi: "3.0.1", this.info, this.servers, this.paths, this.tags});

  Map<String, dynamic> toJson() => openApiSerializer.toMap(this);
}

class Info {
  final String title;

  final String description;

  final String termsOfService;

  final Contact contact;

  final License license;

  final String version;

  const Info(
      {this.title,
      this.description,
      this.termsOfService,
      this.contact,
      this.license,
      this.version});
}

class Contact {
  final String name;

  final String url;

  final String email;

  const Contact({this.name, this.url, this.email});
}

class Tag {
  final String name;

  final String description;

  // TODO externalDocs

  const Tag({this.name, this.description});
}

class License {
  final String name;

  final String url;

  const License({this.name, this.url});
}

class Server {
  final String url;

  final String description;

  // TODO variables

  const Server({this.url, this.description});
}

class PathItem {
  // TODO ref

  final String summary;

  final String description;

  final Operation get;

  final Operation put;

  final Operation post;

  final Operation delete;

  final Operation options;

  final Operation head;

  final Operation patch;

  final Operation trace;

  // TODO servers

  final List<Parameter> parameters;

  const PathItem(
      {this.summary,
      this.description,
      this.get,
      this.put,
      this.post,
      this.delete,
      this.options,
      this.head,
      this.patch,
      this.trace,
      this.parameters});
}

class Operation {
  final List<String> tags;

  final String summary;

  final String description;

  // TODO external docs

  final String operationId;

  final List<Parameter> parameters;

  final Request requestBody;

  final Map<String, Response> response;

  // TODO callbacks

  final bool deprecated;

  // TODO security

  // TODO servers

  const Operation(
      {this.tags,
      this.summary,
      this.description,
      this.operationId,
      this.parameters,
      this.requestBody,
      this.response,
      this.deprecated});
}

class Schema {
  final String title;

  // TODO multipleOf

  final String type;

  final List<Schema> allOf;

  final List<Schema> oneOf;

  final List<Schema> anyOf;

  // TODO not

  final Schema items;

  final Map<String, Schema> properties;

  // TODO final bool additionalProperties;

  final String description;

  final String format;

  // TODO default

  final bool nullable;

  // TODO discriminator

  final bool readOnly;

  final bool writeOnly;

  // TODO xml

  // TODO externalDocs

  final dynamic example;

  final bool deprecated;

  const Schema(
      {this.title,
      this.type,
      this.items,
      this.properties,
      // TODO this.additionalProperties,
      this.description,
      this.format,
      this.nullable,
      this.readOnly,
      this.writeOnly,
      this.example,
      this.deprecated});
}

class Parameter {
  final String name;

  final String in_;

  final String description;

  final bool required;

  final bool deprecated;

  final bool allowEmptyValue;

  final String style;

  final bool explode;

  final bool allowReserved;

  final Schema schema;

  final dynamic example;

  final Map<String, dynamic> examples;

  // TODO content

  const Parameter(
      {this.name,
      this.in_,
      this.description,
      this.required,
      this.deprecated,
      this.allowEmptyValue,
      this.style,
      this.explode,
      this.allowReserved,
      this.schema,
      this.example,
      this.examples});
}

class Header {
  final String description;

  final bool required;

  final bool deprecated;

  final bool allowEmptyValue;

  final String style;

  final bool explode;

  final bool allowReserved;

  final Schema schema;

  final dynamic example;

  final Map<String, dynamic> examples;

  // TODO content

  const Header(
      {this.description,
      this.required,
      this.deprecated,
      this.allowEmptyValue,
      this.style,
      this.explode,
      this.allowReserved,
      this.schema,
      this.example,
      this.examples});
}

class MediaType {
  final Schema schema;

  final dynamic example;

  final Map<String, dynamic> examples;

  // TODO encoding

  const MediaType({this.schema, this.example, this.examples});
}

class Response {
  final String description;

  final Map<String, Header> headers;

  final Map<String, MediaType> mediaType;

  // TODO links

  const Response({this.description, this.headers, this.mediaType});
}

class Request {
  final String description;

  final Map<String, MediaType> content;

  final bool required;

  const Request({this.description, this.content, this.required});
}
