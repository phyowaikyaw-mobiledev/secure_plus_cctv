import 'dart:io';
import 'package:image_picker/image_picker.dart';

List<File> xFilesToFiles(List<XFile> xfiles) {
  return xfiles.map((x) => File(x.path)).toList();
}

File xFileToFile(XFile xfile) => File(xfile.path);
