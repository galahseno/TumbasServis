// ignore_for_file: prefer_initializing_formals
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

enum PhotoPickSource { camera, gallery }

sealed class PhotoPickResult {
  const PhotoPickResult();
}

final class PhotoPicked extends PhotoPickResult {
  const PhotoPicked(this.path);

  final String path;
}

final class PhotoPickCancelled extends PhotoPickResult {
  const PhotoPickCancelled();
}

final class PhotoPickPermissionDenied extends PhotoPickResult {
  const PhotoPickPermissionDenied();
}

final class PhotoPickFailed extends PhotoPickResult {
  const PhotoPickFailed();
}

typedef PhotoDirectoryResolver = Future<String> Function();

class PhotoPickerService {
  PhotoPickerService({
    required PhotoDirectoryResolver resolveStorageDirectory,
    ImagePicker? imagePicker,
  }) : _resolveStorageDirectory = resolveStorageDirectory,
       _imagePicker = imagePicker ?? ImagePicker();

  final PhotoDirectoryResolver _resolveStorageDirectory;
  final ImagePicker _imagePicker;

  static const _folderName = 'motor_photos';

  Future<PhotoPickResult> pickAndPersist({
    required PhotoPickSource source,
    required String fileNameHint,
  }) async {
    try {
      final picked = await _imagePicker.pickImage(
        source: source == PhotoPickSource.camera
            ? ImageSource.camera
            : ImageSource.gallery,
        maxWidth: 1600,
        imageQuality: 85,
      );
      if (picked == null) return const PhotoPickCancelled();

      final root = await _resolveStorageDirectory();
      final directory = Directory('$root${Platform.pathSeparator}$_folderName');
      await directory.create(recursive: true);
      final dot = picked.path.lastIndexOf('.');
      final extension = dot == -1 ? '.jpg' : picked.path.substring(dot);
      final stamp = DateTime.now().microsecondsSinceEpoch;
      final target =
          '${directory.path}${Platform.pathSeparator}$fileNameHint-$stamp$extension';
      await File(picked.path).copy(target);
      return PhotoPicked(target);
    } on PlatformException catch (e) {
      if (e.code.contains('access_denied')) {
        return const PhotoPickPermissionDenied();
      }
      return const PhotoPickFailed();
    } on Exception {
      return const PhotoPickFailed();
    }
  }

  Future<void> deletePhoto(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) await file.delete();
    } on Exception {
      // Best effort: a leftover file is harmless.
    }
  }
}
