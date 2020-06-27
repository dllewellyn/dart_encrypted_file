import 'dart:convert';
import 'dart:io';

import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';


class Awesome {
  bool get isAwesome => true;
}

void createFile() { 
  File('temp/abc').createSync();

}

class EncryptedFile extends FileSystemEntity implements File {

  final File file;
  final String password;

  EncryptedFile(this.file, this.password);

  @override
  File get absolute => throw UnimplementedError();

  @override
  Future<File> copy(String newPath) {
      return file.copy(newPath);
    }
  
    @override
    File copySync(String newPath) {
      return file.copySync(newPath);
    }
  
    @override
    Future<File> create({bool recursive = false}) {
      return file.create(recursive: recursive);
    }
  
    @override
    void createSync({bool recursive = false}) {
      return file.createSync(recursive: recursive);
    }
  
    @override
    Future<FileSystemEntity> delete({bool recursive = false}) {
      return file.delete(recursive: recursive);
    }
  
    @override
    void deleteSync({bool recursive = false}) {
      // TODO: implement deleteSync
    }
  
    @override
    Future<bool> exists() {
      // TODO: implement exists
      throw UnimplementedError();
    }
  
    @override
    bool existsSync() {
      // TODO: implement existsSync
      throw UnimplementedError();
    }
  
    @override
    // TODO: implement isAbsolute
    bool get isAbsolute => throw UnimplementedError();
  
    @override
    Future<DateTime> lastAccessed() {
      // TODO: implement lastAccessed
      throw UnimplementedError();
    }
  
    @override
    DateTime lastAccessedSync() {
      // TODO: implement lastAccessedSync
      throw UnimplementedError();
    }
  
    @override
    Future<DateTime> lastModified() {
      // TODO: implement lastModified
      throw UnimplementedError();
    }
  
    @override
    DateTime lastModifiedSync() {
      // TODO: implement lastModifiedSync
      throw UnimplementedError();
    }
  
    @override
    Future<int> length() {
      // TODO: implement length
      throw UnimplementedError();
    }
  
    @override
    int lengthSync() {
      // TODO: implement lengthSync
      throw UnimplementedError();
    }
  
    @override
    Future<RandomAccessFile> open({FileMode mode = FileMode.read}) {
      return file.open(mode: mode);
    }
  
    @override
    Stream<List<int>> openRead([int start, int end]) {
      // TODO: implement openRead
      throw UnimplementedError();
    }
  
    @override
    RandomAccessFile openSync({FileMode mode = FileMode.read}) {
      // TODO: implement openSync
      throw UnimplementedError();
    }
  
    @override
    IOSink openWrite({FileMode mode = FileMode.write, Encoding encoding = utf8}) {
      return file.openWrite(mode: mode, encoding: encoding);
    }
  
    @override
    // TODO: implement parent
    Directory get parent => throw UnimplementedError();
  
    @override
    // TODO: implement path
    String get path => throw UnimplementedError();
  
    @override
    Future<Uint8List> readAsBytes() async {

      final bytes  = await file.readAsBytes();
      final cipher = CipherWithAppendedMac(aesCtr, Hmac(sha256));
      final keyNonce = Nonce(bytes.sublist(0, 16));
      
      final secretKey = SecretKey(await _createKey(keyNonce));
      final nonce = Nonce(bytes.sublist(16,28));
      final message = bytes.sublist(28, bytes.length);
    
      // Encrypt
      final decrypted = await cipher.decrypt(
        message,
        secretKey: secretKey,
        nonce: nonce,
      );

      return decrypted;
    }
  
    @override
    Uint8List readAsBytesSync() {
      // TODO: implement readAsBytesSync
      throw UnimplementedError();
    }
  
    @override
    Future<List<String>> readAsLines({Encoding encoding = utf8}) {
      // TODO: implement readAsLines
      throw UnimplementedError();
    }
  
    @override
    List<String> readAsLinesSync({Encoding encoding = utf8}) {
      // TODO: implement readAsLinesSync
      throw UnimplementedError();
    }
  
    @override
    Future<String> readAsString({Encoding encoding = utf8}) async {
      return utf8.decode(await readAsBytes());
    }
  
    @override
    String readAsStringSync({Encoding encoding = utf8}) {
      // TODO: implement readAsStringSync
      throw UnimplementedError();
    }
  
    @override
    Future<File> rename(String newPath) {
      // TODO: implement rename
      throw UnimplementedError();
    }
  
    @override
    File renameSync(String newPath) {
      // TODO: implement renameSync
      throw UnimplementedError();
    }
  
    @override
    Future<String> resolveSymbolicLinks() {
      // TODO: implement resolveSymbolicLinks
      throw UnimplementedError();
    }
  
    @override
    String resolveSymbolicLinksSync() {
      // TODO: implement resolveSymbolicLinksSync
      throw UnimplementedError();
    }
  
    @override
    Future setLastAccessed(DateTime time) {
      // TODO: implement setLastAccessed
      throw UnimplementedError();
    }
  
    @override
    void setLastAccessedSync(DateTime time) {
      // TODO: implement setLastAccessedSync
    }
  
    @override
    Future setLastModified(DateTime time) {
      // TODO: implement setLastModified
      throw UnimplementedError();
    }
  
    @override
    void setLastModifiedSync(DateTime time) {
      // TODO: implement setLastModifiedSync
    }
  
    @override
    Future<FileStat> stat() {
      // TODO: implement stat
      throw UnimplementedError();
    }
  
    @override
    FileStat statSync() {
      // TODO: implement statSync
      throw UnimplementedError();
    }
  
    @override
    // TODO: implement uri
    Uri get uri => throw UnimplementedError();
  
    @override
    Stream<FileSystemEvent> watch({int events = FileSystemEvent.all, bool recursive = false}) {
      // TODO: implement watch
      throw UnimplementedError();
    }
  
    @override
    Future<File> writeAsBytes(List<int> bytes, {FileMode mode = FileMode.write, bool flush = false}) {
      // TODO: implement writeAsBytes
      throw UnimplementedError();
    }
  
    @override
    void writeAsBytesSync(List<int> bytes, {FileMode mode = FileMode.write, bool flush = false}) {
      // TODO: implement writeAsBytesSync
    }
  
    @override
    Future<File> writeAsString(String contents, {FileMode mode = FileMode.write, Encoding encoding = utf8, bool flush = false}) async {
      final cipher = CipherWithAppendedMac(aesCtr, Hmac(sha256));

      final keyNonce = Nonce.randomBytes(16);
      final secretKey = SecretKey(await _createKey(keyNonce));

      final nonce = Nonce.randomBytes(12);

      // Our message
      final message = utf8.encode(contents);

      // Encrypt
      final encrypted = await cipher.encrypt(
        message,
        secretKey: secretKey,
        nonce: nonce,
      );

      print("Enc ${nonce}");
      final fileContents = <int>[];

      fileContents
        ..addAll(keyNonce.bytes)
        ..addAll(nonce.bytes)
        ..addAll(encrypted);
  
      return file.writeAsBytes(fileContents, mode: mode, flush: flush);
    }
  
    @override
    void writeAsStringSync(String contents, {FileMode mode = FileMode.write, Encoding encoding = utf8, bool flush = false}) {
     file.writeAsStringSync(contents, mode: mode, encoding: encoding, flush: flush);
  }

  Future<Uint8List> _createKey(Nonce nonce) async {
      final pbkdf2 = Pbkdf2(
        macAlgorithm: Hmac(sha256),
        iterations: 100000,
        bits: 128,
      );

      return await pbkdf2.deriveBits(
        utf8.encode(password),
        nonce: nonce
      );
  }

}