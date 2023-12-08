import 'dart:convert';

import 'package:http/http.dart' as http;

class IpfsService {
  static Future<(int, String)> uploadBytesToIPFS(List<int> bytes) async {
    final Uri uri = Uri.parse('https://node.lighthouse.storage/api/v0/add');
    final http.MultipartRequest request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] =
          'Bearer d77c394a.cedb367357cb48a0917d7f9af20a7061'
      ..files.add(http.MultipartFile.fromBytes('file', bytes));

    final http.StreamedResponse response = await request.send();

    final String respStr = await response.stream.bytesToString();
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(respStr);
      final String cid = data['Hash'];
      return (response.statusCode, cid);
    } else {
      return (response.statusCode, respStr);
    }
  }
}
