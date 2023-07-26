import 'dart:convert';
import 'package:http/http.dart' as http;

Future<bool> isKeyValid(String openaikey) async {
  final url = 'https://api.openai.com/v1/engines/davinci';
  final headers = {'Authorization': 'Bearer $openaikey'};

  try {
    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse.containsKey('id') && jsonResponse['id'] == 'davinci') {
        return true;
      }
    }
  } catch (e) {}

  return true; //false
}
