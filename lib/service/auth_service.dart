import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String apiUrl =
      'http://10.0.2.2:5137/api/auth'; // Adjust the URL as needed

  // Sign-Up Method
  Future<bool> signUp(String username, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/register'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        print('Sign-Up failed: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error in signUp: $e');
      return false;
    }
  }

  Future<bool> signIn(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        // Check if the response is JSON or plain text
        if (response.headers['content-type']?.contains('application/json') ??
            false) {
          final responseData = jsonDecode(response.body);
          final token = responseData['token'].trim();
          final userId = responseData['userId'];

          await _saveToken(token);
          await _saveUserId(userId);
        } else if (response.body == "Login successful.") {
          // Handle plain text response
          print("Logged in successfully, but no token/userId received.");
        } else {
          print("Unexpected response format: ${response.body}");
        }

        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error in signIn: $e');
      return false;
    }
  }

  // Save UserId
  Future<void> _saveUserId(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    print('Saving userId: $userId'); // Add this line
    await prefs.setInt('user_id', userId);
  }

  // Get UserId
  Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');
    print('Retrieved userId: $userId'); // Add this line
    return userId;
  }

  // Save Token
  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  // Get Token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // Logout Method
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_id'); // Clear userId on logout
  }
}
