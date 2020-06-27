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
  File get absolute => file.absolute;

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
      return file.deleteSync(recursive: recursive);
    }
  
    @override
    Future<bool> exists() {
      return file.exists();
    }
  
    @override
    bool existsSync() {
      return file.existsSync();
    }
  
    @override
    bool get isAbsolute => file.isAbsolute;
  
    @override
    Future<DateTime> lastAccessed() {
      return file.lastAccessed();
    }
  
    @override
    DateTime lastAccessedSync() {
      return file.lastAccessedSync();
    }
  
    @override
    Future<DateTime> lastModified() {
      return file.lastModified();
    }
  
    @override
    DateTime lastModifiedSync() {
      return file.lastModifiedSync();
    }
  
    @override
    Future<int> length() {
      return file.length();
    }
  
    @override
    int lengthSync() {
      return lengthSync();
    }
    
    @override
    Directory get parent => file.parent;
  
    @override
    String get path => file.path;
  
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
    Future<File> rename(String newPath) {
      return file.rename(newPath);
    }
  
    @override
    File renameSync(String newPath) {
      return file.renameSync(newPath);
    }
  
    @override
    Future<String> resolveSymbolicLinks() {
      return file.resolveSymbolicLinks();
    }
  
    @override
    String resolveSymbolicLinksSync() {
      return file.resolveSymbolicLinksSync();
    }
  
    @override
    Future setLastAccessed(DateTime time) {
      return file.setLastAccessed(time);
    }
  
    @override
    void setLastAccessedSync(DateTime time) {
      return file.setLastAccessedSync(time);
    }
  
    @override
    Future setLastModified(DateTime time) {
      return file.setLastModified(time);
    }
  
    @override
    void setLastModifiedSync(DateTime time) {
      file.setLastAccessedSync(time);
    }
  
    @override
    Future<FileStat> stat() {
      return file.stat();
    }
  
    @override
    FileStat statSync() {
      return file.statSync();
    }
  
    @override
    Uri get uri => file.uri;
  
    @override
    Stream<FileSystemEvent> watch({int events = FileSystemEvent.all, bool recursive = false}) {
      return file.watch(events: events, recursive: recursive);
    }
  
  
    @override
    Future<File> writeAsString(String contents, {FileMode mode = FileMode.write, Encoding encoding = utf8, bool flush = false}) async {
    
      // Our message
      final message = utf8.encode(contents);
      return writeAsBytes(message, mode: mode, flush: flush);
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

    @override
    Future<File> writeAsBytes(List<int> bytes, {FileMode mode = FileMode.write, bool flush = false}) async {
       final cipher = CipherWithAppendedMac(aesCtr, Hmac(sha256));

      final keyNonce = Nonce.randomBytes(16);
      final secretKey = SecretKey(await _createKey(keyNonce));

      final nonce = Nonce.randomBytes(12);


      // Encrypt
      final encrypted = await cipher.encrypt(
        bytes,
        secretKey: secretKey,
        nonce: nonce,
      );

      final fileContents = <int>[];

      fileContents
        ..addAll(keyNonce.bytes)
        ..addAll(nonce.bytes)
        ..addAll(encrypted);
  
  return file.writeAsBytes(bytes, mode: mode, flush: flush);
    }
  
    @override
    void writeAsBytesSync(List<int> bytes, {FileMode mode = FileMode.write, bool flush = false}) {
      // TODO: implement writeAsBytesSync
    }

  @override
    Future<List<String>> readAsLines({Encoding encoding = utf8}) async {
      return (await readAsString(encoding: encoding)).split('\n');
    }
  
    @override
    List<String> readAsLinesSync({Encoding encoding = utf8}) {
      return readAsStringSync(encoding: encoding)
      .split('\n');
    }
    @override
    String readAsStringSync({Encoding encoding = utf8}) {
      // TODO
    }
  
  @override
    Future<RandomAccessFile> open({FileMode mode = FileMode.read}) {
      // TODO
    }
  
    @override
    Stream<List<int>> openRead([int start, int end]) {
      // TODO 
    }
  
    @override
    RandomAccessFile openSync({FileMode mode = FileMode.read}) {
      // TODO
    }
  
    @override
    IOSink openWrite({FileMode mode = FileMode.write, Encoding encoding = utf8}) {
      return file.openWrite(mode: mode, encoding: encoding);
    }
    @override
    Uint8List readAsBytesSync() {
      return file.readAsBytesSync();
    }
  
  
    @override
    Future<String> readAsString({Encoding encoding = utf8}) async {
      return utf8.decode(await readAsBytes());
    }
  
}