class Global {
  static String _openaiKeys = ''; // Initialize it with an empty string or default value
  static bool _fileUploaded = false; 
  //
  static String get openaiKeys => _openaiKeys;

  static bool get fileUploaded => _fileUploaded;

  static set openaiKeys(String keys) {
    _openaiKeys = keys;
  }
  static set fileUploaded(bool upFile) {
    _fileUploaded = upFile;
  }
}
