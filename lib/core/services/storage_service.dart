import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:typed_data';

class StorageService {
	final SupabaseClient _client = Supabase.instance.client;

	Future<String?> uploadFile(String bucket, String path, List<int> fileBytes) async {
		// Convert List<int> to Uint8List
		final Uint8List bytes = Uint8List.fromList(fileBytes);
		// uploadBinary returns the path or throws an exception
		return await _client.storage.from(bucket).uploadBinary(path, bytes);
	}

	Future<Uint8List> downloadFile(String bucket, String path) async {
		// download returns Uint8List or throws an exception
		return await _client.storage.from(bucket).download(path);
	}

	Future<void> deleteFile(String bucket, String path) async {
		// remove returns a list of deleted files or throws an exception
		await _client.storage.from(bucket).remove([path]);
	}
}
 