/// Converts text typed into a free-form state value field into the value
/// written to YAML: an int, double or bool when the text is one, otherwise
/// the trimmed text.
///
/// Without this, `21` typed by the user would be written as the string
/// `"21"`, which Google Home does not treat as a number.
Object parseStateValue(String input) {
  final text = input.trim();
  return int.tryParse(text) ??
      double.tryParse(text) ??
      switch (text.toLowerCase()) {
        'true' => true,
        'false' => false,
        _ => text,
      };
}
