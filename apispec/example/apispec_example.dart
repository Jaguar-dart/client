import 'package:apispec/apispec.dart';
import 'dart:convert';

final pets = OpenApi(
    info: Info(
        description: """This is a sample server Petstore server. 
You can find out more about Swagger at [http://swagger.io](http://swagger.io) or 
on [irc.freenode.net, #swagger](http://swagger.io/irc/). For this sample, you can use the api
key `special-key` to test the authorization filters.""",
        version: "1.0.0",
        title: "Swagger petstore",
        termsOfService: "http://swagger.io/terms/",
        contact: Contact(email: "apiteam@swagger.io"),
        license: License(
            name: "Apache 2.0",
            url: "http://www.apache.org/licenses/LICENSE-2.0.html")),
    tags: [
      Tag(name: "pet", description: "Everything about your Pets"),
      Tag(name: "store", description: "Access to Petstore orders"),
      Tag(name: "user", description: "Operations about user"),
    ]);

main() {
  print(json.encode(pets.toJson()));
}
