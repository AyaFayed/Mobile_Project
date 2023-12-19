import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiResponse {
  bool clean;
  bool success;
  double toxicityScore; // You can include additional data if needed
  String errorMessage;
  String language;

  ApiResponse.success(this.toxicityScore, this.language)
      : clean = true,
        success = true,
        errorMessage = '';

  ApiResponse.failure(this.toxicityScore, this.language)
      : clean = false,
        success = true,
        errorMessage = '';

  ApiResponse.error(this.errorMessage)
      : clean = false,
        success = false,
        toxicityScore = 0.0,
        language = '', // Set to a default value or omit if not needed
        super();

  bool get hasError => errorMessage.isNotEmpty;
}

class perspectiveAPI {
  static Future<ApiResponse> sendRequest(String content) async {
    const apiUrl =
        "https://commentanalyzer.googleapis.com/v1alpha1/comments:analyze?key=AIzaSyDNpeXtWlcxIXOawI1R0YfSX8KioAE81KA";

    Map<String, dynamic> requestData = {
      'comment': {'text': content},
      'languages': ['en'],
      'requestedAttributes': {'TOXICITY': {}}
    };

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requestData),
    );

    if (response.statusCode == 200) {
      // print('Response: ${response.body}');
      String responseString = response.body.toString();
      Map<String, dynamic> jsonResponse = jsonDecode(responseString);

      double toxicityScore = jsonResponse['attributeScores']['TOXICITY']
          ['spanScores'][0]['score']['value'];
      // print('TOXICITY Score: $toxicityScore');
      String language = jsonResponse['detectedLanguages'][0];
      // print("the model detected:" + language);
      if (language == 'en') {
        if (toxicityScore > 0.8) {
          return ApiResponse.failure(toxicityScore, language);
        } else {
          return ApiResponse.success(toxicityScore, language);
        }
      } else {
        if (toxicityScore > 0.4) {
          return ApiResponse.failure(toxicityScore, language);
        } else {
          return ApiResponse.success(toxicityScore, language);
        }
      }
    } else {
      // print(content);
      // print("perspective API failed");
      // print('Error: ${response.statusCode}, ${response.reasonPhrase}');
      return ApiResponse.error(
          'Error: ${response.statusCode}, ${response.reasonPhrase}');
    }
  }
}
