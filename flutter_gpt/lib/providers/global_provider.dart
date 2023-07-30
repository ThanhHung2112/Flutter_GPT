class Global {
  static String _openaiKeys = ''; // Initialize it with an empty string or default value
  static bool _fileUploaded = false; 
  static bool _chatType = false; // Initialize it with an empty string or default value

  static String get openaiKeys => _openaiKeys;
  static bool get fileUploaded => _fileUploaded;
  static bool get chatType => _chatType;


  static set openaiKeys(String keys) {
    _openaiKeys = keys;
  }
  static set fileUploaded(bool upFile) {
    _fileUploaded = upFile;
  }
  static set chatType(bool chatType) {
    _chatType = chatType;
  }
}
