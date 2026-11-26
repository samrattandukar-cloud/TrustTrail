import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

enum VehiclePhotoSource { camera, gallery }

/// Copies a picked vehicle photo into app documents and returns the new path.
/// Old files are kept so already-shared report snapshots keep resolving.
abstract final class VehiclePhotoService {
  static Future<String?> pick(VehiclePhotoSource source) async {
    final picked = await ImagePicker().pickImage(
      source: source == VehiclePhotoSource.camera
          ? ImageSource.camera
          : ImageSource.gallery,
      maxWidth: 1600,
      maxHeight: 1600,
      imageQuality: 85,
    );
    if (picked == null) return null;

    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(docs.path, 'vehicle_photos'));
    await dir.create(recursive: true);
    final destination = p.join(dir.path, '${const Uuid().v4()}.jpg');
    await File(picked.path).copy(destination);
    return destination;
  }
}
