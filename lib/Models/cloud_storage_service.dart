import 'dart:io';
import 'dart:math';

import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CloudStorageService {
  static CloudStorageService instance = CloudStorageService();

  FirebaseStorage _storage;
  Reference _baseRef;

  String _profileImages = "profile_images/";
  String _audioFiles = "audio_files/";
  String _messages = "messages";
  String _images = "images";

  CloudStorageService() {
    _storage = FirebaseStorage.instance;
    _baseRef = _storage.ref();
  }

  Future<TaskSnapshot> uploadUserImage(String _uid, File _image) {
    try {
      return _baseRef
          .child(_profileImages)
          .child(_uid)
          .putFile(_image);
    } catch (e) {
      print(e);
    }
  }

  Future<TaskSnapshot> uploadImage(File _image) {
    Random random = new Random();
    int randomNumber = random.nextInt(1000000);
    String value = randomNumber.toString();
    try {
      return _baseRef
          .child(value)
          .putFile(_image);
    } catch (e) {
      print(e);
    }
  }


  /*Future<StorageTaskSnapshot> uploadAudioFile(String fileName, File audiofile) {
    try {
      return _baseRef
          .child(_audioFiles)
          .child(fileName)
          .putFile(audiofile)
          .onComplete;
    } catch (e) {
      print(e);
    }
  }*/

 /* Future<StorageTaskSnapshot> uploadMediaMessage(String _uid, File _file) {
    var _timestamp = DateTime.now();
    var _fileName = basename(_file.path);
    _fileName += "_${_timestamp.toString()}";
    try {
      return _baseRef
          .child(_messages)
          .child(_uid)
          .child(_images)
          .child(_fileName)
          .putFile(_file)
          .onComplete;
    } catch (e) {
      print(e);
    }
  }*/
}