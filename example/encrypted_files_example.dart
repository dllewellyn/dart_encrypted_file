import 'package:encrypted_files/encrypted_files.dart';
import 'dart:io';

void main() async {
  var awesome = Awesome();
  print('awesome: ${awesome.isAwesome}');
  EncryptedFile(File('temp/abc.encrypted'), 'password')
  .writeAsString('test');

print(await EncryptedFile(File('temp/abc.encrypted'), 'password')
.readAsString());
  
}
