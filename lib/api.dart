import 'dart:convert';
import 'dart:developer';
import 'package:hotelmgm/models/errorResponse.dart';
import 'package:hotelmgm/models/response.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

// might require auth related info later
Map<String, dynamic>? authInfo;

// Global variables for API endpoint and headers
const String apiBaseUrl = 'https://hotelmgm.azurewebsites.net/api';
Map<String, String> defaultHeaders = {
  'accept': '*/*',
  'Content-Type': 'application/json',
  'origin': 'https://hotelmgm.azurewebsites.net',
};

ApiResponse responseParse(Response response) {
  return ApiResponse.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>);
}

ApiErrorResponse errorParse(Response response) {
  return ApiErrorResponse.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>);
}

// Function to confirm user's email
Future<String?> confirmEmail(String userId, String code) async {
  log('$apiBaseUrl/Account/confirm-email?userId=$userId&code=$code');
  final url =
      Uri.parse('$apiBaseUrl/Account/confirm-email?userId=$userId&code=$code');
  final response = await http.get(url, headers: {
    'accept': '*/*',
  });

  if (response.statusCode == 200) {
    return null;
  } else {
    return responseParse(response).message;
  }
}

// Function to register a user
Future<String?> registerUser(
  String firstName,
  String lastName,
  String email,
  String userName,
  String password,
) async {
  log('registering user, $apiBaseUrl/Account/register');

  final url = Uri.parse('$apiBaseUrl/Account/register');
  final body = json.encode({
    "firstName": firstName,
    "lastName": lastName,
    "email": email,
    "userName": userName,
    "password": password,
    "confirmPassword": password,
  });

  final response = await http.post(
    url,
    headers: defaultHeaders,
    body: body,
  );

  log('Register Response status: ${response.statusCode}');
  log('Register Response body: ${response.body}');

  if (response.statusCode == 200) {
    var resp = responseParse(response).message.split('=');
    var userId = resp[1].split('&')[0];
    var code = resp[2];
    log('confirming email after signup');
    return confirmEmail(userId, code);
    // return null;
  } else {
    log('register returned error');
    try {
      return errorParse(response).errors;
    } on TypeError {
      return responseParse(response).message;
    }
  }
}

Future<String?> authenticateUser(String email, String password) async {
  final url = Uri.parse('${apiBaseUrl}/Account/authenticate');
  final body = json.encode({'email': email, 'password': password});
  final response = await http.post(url, headers: defaultHeaders, body: body);
  if (response.statusCode == 200) {
    authInfo = responseParse(response).data;
    // add token to headers for future
    defaultHeaders = {
      ...defaultHeaders,
      "Authorization": authInfo?["jwToken"],
    };
    return null;
  } else {
    return responseParse(response).message;
  }
}

void main() async {
  // var resp = await http.post(Uri.parse('https://example.com'), body: {'test': 'test'});
  // log(resp.body);
  await authenticateUser('test08@example.com', 'Testtest1!');
  // print(authInfo?["jwToken"]);
}
