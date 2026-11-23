import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../../data/models/evidence.dart';

enum EvidenceSource { camera, gallery, file }

/// Copies the picked file into app documents. Images are already constrained
/// by the picker (1600px / quality 85); PDFs are copied as-is.
abstract final class EvidenceService {
  static Future<Evidence?> pick({
    required String recordId,
    required EvidenceSource source,
    EvidenceKind kind = EvidenceKind.bill,
  }) async {
    String? sourcePath;
    String? displayName;
    var isPdf = false;

    if (source == EvidenceSource.file) {
      final picked = await FilePicker.pickFile(
        type: FileType.custom,
        allowedExtensions: const ['pdf', 'jpg', 'jpeg', 'png'],
      );
      if (picked == null || picked.path == null) return null;
      sourcePath = picked.path;
      displayName = picked.name;
      isPdf = (picked.extension ?? '').toLowerCase() == 'pdf';
    } else {
      final picked = await ImagePicker().pickImage(
        source: source == EvidenceSource.camera
            ? ImageSource.camera
            : ImageSource.gallery,
        maxWidth: 1600,
        maxHeight: 1600,
        imageQuality: 85,
      );
      if (picked == null) return null;
      sourcePath = picked.path;
      displayName = picked.name;
    }
    if (sourcePath == null) return null;

    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(docs.path, 'evidence', recordId));
    await dir.create(recursive: true);
    final id = const Uuid().v4();
    final extension = isPdf ? 'pdf' : 'jpg';
    final destination = p.join(dir.path, '$id.$extension');
    await File(sourcePath).copy(destination);
    final size = await File(destination).length();

    return Evidence(
      id: id,
      recordId: recordId,
      kind: isPdf ? EvidenceKind.pdf : kind,
      filePath: destination,
      thumbPath: destination,
      mime: isPdf ? 'application/pdf' : 'image/jpeg',
      sizeBytes: size,
      label: displayName,
      createdAt: DateTime.now(),
    );
  }

  static Future<void> deleteFiles(Iterable<Evidence> evidence) async {
    for (final item in evidence) {
      if (item.isAsset) continue;
      try {
        await File(item.filePath).delete();
      } on FileSystemException {
        // Already gone; the database row is removed by cascade.
      }
    }
  }
}
