// API Client for handling HTTP requests with proper headers and error handling
import 'dart:convert';
import 'package:http/http.dart' as http;

// Custom exception for API errors
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() {
    return 'ApiException: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
  }
}

// Global API client to handle all HTTP requests
class ApiClient {
  final String baseUrl;
  final String adminSecret;

  // HTTP client for persistent connections
  final http.Client _client = http.Client();

  ApiClient({required this.baseUrl, required this.adminSecret});

  // Basic headers for all requests
  Map<String, String> _getHeaders({
    Map<String, String>? additionalHeaders,
    String? token,
  }) {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Admin-Secret': adminSecret,
    };

    // Add authorization header if token is provided
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    // Add any additional headers
    if (additionalHeaders != null) {
      headers.addAll(additionalHeaders);
    }

    return headers;
  }

  // GET request
  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, String>? headers,
    String? token,
  }) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: _getHeaders(additionalHeaders: headers, token: token),
      );

      return _handleResponse(response);
    } catch (e) {
      throw ApiException('Network error: ${e.toString()}');
    }
  }

  // POST request
  Future<Map<String, dynamic>> post(
    String endpoint, {
    dynamic body,
    Map<String, String>? headers,
    String? token,
  }) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: _getHeaders(additionalHeaders: headers, token: token),
        body: body != null ? jsonEncode(body) : null,
      );

      return _handleResponse(response);
    } catch (e) {
      throw ApiException('Network error: ${e.toString()}');
    }
  }

  // PUT request
  Future<Map<String, dynamic>> put(
    String endpoint, {
    dynamic body,
    Map<String, String>? headers,
    String? token,
  }) async {
    try {
      final response = await _client.put(
        Uri.parse('$baseUrl$endpoint'),
        headers: _getHeaders(additionalHeaders: headers, token: token),
        body: body != null ? jsonEncode(body) : null,
      );

      return _handleResponse(response);
    } catch (e) {
      throw ApiException('Network error: ${e.toString()}');
    }
  }

  // DELETE request
  Future<Map<String, dynamic>> delete(
    String endpoint, {
    Map<String, String>? headers,
    String? token,
  }) async {
    try {
      final response = await _client.delete(
        Uri.parse('$baseUrl$endpoint'),
        headers: _getHeaders(additionalHeaders: headers, token: token),
      );

      return _handleResponse(response);
    } catch (e) {
      throw ApiException('Network error: ${e.toString()}');
    }
  }

  // Handle response and error codes
  Map<String, dynamic> _handleResponse(http.Response response) {
    try {
      final data = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return data;
      } else {
        // Extract error message from response if available
        final errorMessage = data['message'] ?? 'Unknown error occurred';
        throw ApiException(errorMessage, statusCode: response.statusCode);
      }
    } catch (e) {
      if (e is ApiException) {
        throw e;
      } else {
        throw ApiException(
          'Failed to parse response: ${e.toString()}',
          statusCode: response.statusCode,
        );
      }
    }
  }

  // Close the client when done
  void dispose() {
    _client.close();
  }
}
