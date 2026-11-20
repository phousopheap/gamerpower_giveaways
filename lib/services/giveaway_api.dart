import 'dart:convert';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;

import '../models/giveaway.dart';

class GiveawayApiException implements Exception {
  GiveawayApiException(this.message);
  final String message;

  @override
  String toString() => message;
}

/// Reads the giveaway list from the GamerPower API.
class GiveawayApi {
  GiveawayApi({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  static const endpoint = 'https://www.gamerpower.com/api/giveaways';

  /// Browsers block cross-site requests the API doesn't allow (CORS).
  /// On the web build we fall back to a public CORS proxy if the direct call fails.
  static const _webCorsProxy = 'https://corsproxy.io/?url=';

  Future<List<Giveaway>> fetchGiveaways() async {
    try {
      return await _get(Uri.parse(endpoint));
    } catch (_) {
      if (!kIsWeb) rethrow;
      return _get(Uri.parse('$_webCorsProxy${Uri.encodeComponent(endpoint)}'));
    }
  }

  Future<List<Giveaway>> _get(Uri uri) async {
    final response =
        await _client.get(uri).timeout(const Duration(seconds: 20));

    // The API answers 201 when there are no active giveaways.
    if (response.statusCode == 201) return const [];
    if (response.statusCode != 200) {
      throw GiveawayApiException(
          'Server responded with status ${response.statusCode}');
    }

    final data = jsonDecode(utf8.decode(response.bodyBytes));
    if (data is! List) {
      throw GiveawayApiException('Unexpected response from server');
    }
    return data
        .whereType<Map<String, dynamic>>()
        .map(Giveaway.fromJson)
        .toList();
  }
}
