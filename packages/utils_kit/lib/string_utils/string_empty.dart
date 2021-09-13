bool isEmpty(String? text) {
  if (text == null) return true;
  return text.isEmpty;
}

bool isNotEmpty(String? text) {
  return !isEmpty(text);
}