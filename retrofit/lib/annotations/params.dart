class PathParam {
  final String alias;
  const PathParam([this.alias]);
}

class QueryParam {
  final String alias;
  const QueryParam([this.alias]);
}

class QueryMap {
  const QueryMap();
}

class Header {
  final String alias;
  const Header([this.alias]);
}

class HeaderMap {
  const HeaderMap();
}

class AsJson {
  const AsJson();
}

class AsForm {
  const AsForm();
}

class AsFormField {
  final String alias;
  const AsFormField([this.alias]);
}

class AsMultipart {
  const AsMultipart();
}

class AsMultipartField {
  final String alias;
  const AsMultipartField([this.alias]);
}
