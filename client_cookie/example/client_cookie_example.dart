// Copyright (c) 2017, teja. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:client_cookie/client_cookie.dart';

main() {
  // Initializing a cookie
  var cookie1 = new ClientCookie('Client', 'jaguar_resty', new DateTime.now());

  // Cookie to header string
  print(cookie1.header);

  // Encoding many cookies
  var cookie2 = new ClientCookie('Client', 'jaguar_resty', new DateTime.now());
  print(ClientCookie.toHeader([cookie1, cookie2]));
}
