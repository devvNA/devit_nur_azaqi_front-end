class Validator {
  static String? required(
    dynamic value, {
    String? fieldName,
  }) {
    if (value == null) {
      return "$fieldName belum diisi";
    }

    if (value is String || value == null) {
      if (value.toString() == "null") return "$fieldName belum diisi";
      if (value.isEmpty) return "$fieldName belum diisi";
    }

    if (value is List) {
      if (value.isEmpty) return "$fieldName belum diisi";
    }
    return null;
  }

  static String? number(String? value) {
    if (value!.isEmpty) return "form ini wajib diisi";

    final bool isNumber = RegExp(r"^[0-9]+$").hasMatch(value);
    if (!isNumber) {
      return "This field is not in a valid number format";
    }
    return null;
  }

  static String? atLeastOneitem(List<Map<String, dynamic>> items) {
    var checkedItems = items.where((i) => i["checked"] == true).toList();
    if (checkedItems.isEmpty) {
      return "you must choose at least one item";
    }
    return null;
  }
}
