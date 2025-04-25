import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileService {
  final SupabaseClient _supabase;

  ProfileService({SupabaseClient? supabase})
      : _supabase = supabase ?? Supabase.instance.client;

  Future<Map<String, dynamic>?> fetchProfile(String userId) async {
    try {
      final response = await _supabase
          .from('profile')
          .select()
          .eq('id', userId)
          .single();

      return response as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to fetch profile: ${e.toString()}');
    }
  }

  Future<void> updateProfile(String userId, Map<String, dynamic> data) async {
    try {
      await _supabase
          .from('profile')
          .update(data)
          .eq('id', userId);
    } catch (e) {
      throw Exception('Failed to update profile: ${e.toString()}');
    }
  }

  Future<String> uploadProfilePicture(String userId, String filePath) async {
    try {
      final file = File(filePath);
      final fileName = '${userId}_${DateTime.now().millisecondsSinceEpoch}.jpg';

      // Ensure the file exists before uploading
      if (!file.existsSync()) {
        throw Exception('File does not exist at path: $filePath');
      }

      print("File exists and size is: ${file.lengthSync()} bytes");

      try {
        // Upload the file to the Supabase storage bucket
        await _supabase.storage
            .from('profile-pictures')
            .upload(fileName, file);

        // Get the public URL of the uploaded file
        final publicUrl = _supabase.storage
            .from('profile-pictures')
            .getPublicUrl(fileName);

        print("File uploaded successfully, URL: $publicUrl");
        return publicUrl;
      } catch (uploadError) {
        print("Specific upload error: $uploadError");
        throw Exception('Failed to upload: $uploadError');
      }
    } catch (e) {
      print("General error during upload process: $e");
      throw Exception('Failed to upload profile picture: ${e.toString()}');
    }
  }

}