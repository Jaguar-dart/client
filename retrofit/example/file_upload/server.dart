library upload_files.server;

import 'package:jaguar/jaguar.dart';

server() async {
  final server = Jaguar(port: 8005);

  // API
  server.group('/api')
    // Upload route
    ..post('/upload', (ctx) async {
      final Map<String, FormField> formData = await ctx.bodyAsFormData();
      BinaryFileFormField fileField = formData['file'];
      print(fileField.filename);
      return StreamResponse(fileField.value);
    });

  server.log.onRecord.listen(print);

  await server.serve(logRequests: true);
}
