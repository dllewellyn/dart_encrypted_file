import 'package:encrypted_files/encrypted_files.dart';
import 'dart:io';

void main() async {
  
  EncryptedFile(File('temp/abc.encrypted'), 'password')
  .writeAsString('test');

print(await EncryptedFile(File('temp/abc.encrypted'), 'password')
.readAsString());
  
}
