class Global {
  static String _openaiKeys = '';
  static bool _fileUploaded = false;
  static bool _chatType = false;
  static String _currentFileName = '';
  static String _fileContent = '';
  static String _status = '';

  static String get openaiKeys => _openaiKeys;
  static bool get fileUploaded => _fileUploaded;
  static bool get chatType => _chatType;
  static String get currentFileName => _currentFileName;
  static String get fileContent => _fileContent;
  static String get status => _status;

  static set openaiKeys(String keys) {
    _openaiKeys = keys;
  }

  static set fileUploaded(bool upFile) {
    _fileUploaded = upFile;
  }

  static set chatType(bool chatType) {
    _chatType = chatType;
  }

  static set currentFileName(String currentFileName) {
    _currentFileName = currentFileName;
  }

  static set fileContent(String fileContent) {
    _fileContent = fileContent;
  }

  static set status(String status) {
    _status = status;
  }
}
