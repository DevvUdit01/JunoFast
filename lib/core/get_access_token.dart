import 'package:flutter/services.dart' show rootBundle;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'dart:convert';

Future<String> getAccessToken() async {
  // Load the service account credentials from the JSON file
  final credentials = auth.ServiceAccountCredentials.fromJson(
    json.decode(await rootBundle.loadString('assets/secrets/junofast-e75d7-4c446b4182a0.json')),
  );

  // Define the required scopes
  final scopes = ['https://www.googleapis.com/auth/cloud-platform'];

  // Obtain an authenticated HTTP client
  final client = await auth.clientViaServiceAccount(credentials, scopes);

  // Return the access token
  return client.credentials.accessToken.data;
}
