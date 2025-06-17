String? validateString(String? value, String? name) {
  if (value == null || value.isEmpty) {
    return "$name ห้ามว่าง";
  }

  return null;
}

String? validateInt(String? value, String? name) {
  if (value == null || value.isEmpty) {
    return "$name ห้ามว่าง";
  }
  if (int.tryParse(value) == null) {
    return "$name กรอกเฉพาะตัวเลขเท่านั้น";
  }

  return null;
}

String? validateDouble(String? value, String? name) {
  if (value == null || value.isEmpty) {
    return "$name ห้ามว่าง";
  }

  final parsed = double.tryParse(value);
  if (parsed == null) {
    return "$name กกรอกเฉพาะตัวเลขหรือทศนิยมเท่านั้น";
  }

  return null;
}

String? validateDrowdown(String? value, String? name) {
  if (value == null || value.isEmpty) {
    return "$name ห่ามว่าง";
  }

  return null;
}
