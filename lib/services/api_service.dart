import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/album.dart';
import '../models/photo.dart';

class ApiService {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';

  Future<List<Album>> fetchAlbums() async {
    final response = await http.get(Uri.parse('$_baseUrl/albums'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonAlbums = json.decode(response.body);
      return jsonAlbums.map((json) => Album.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load albums');
    }
  }

  Future<List<Photo>> fetchPhotosByAlbumId(int albumId) async {
    final response = await http.get(Uri.parse('$_baseUrl/photos?albumId=$albumId'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonPhotos = json.decode(response.body);
      return jsonPhotos.map((json) => Photo.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load photos');
    }
  }

  Future<List<Photo>> fetchAllPhotos() async {
    final response = await http.get(Uri.parse('$_baseUrl/photos'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonPhotos = json.decode(response.body);
      return jsonPhotos.map((json) => Photo.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load all photos');
    }
  }
}