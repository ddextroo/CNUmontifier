import 'package:image_picker/image_picker.dart';

Future<String?> pickImage(ImageSource source) async {
  final ImagePicker _picker = ImagePicker();
  final XFile? imageFile = await _picker.pickImage(source: source);
  if (imageFile == null) return null;
  return imageFile.path;
}
