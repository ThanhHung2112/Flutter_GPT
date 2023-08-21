class Global {
  static String _openaiKeys = '';
  static bool _fileUploaded = false;
  static bool _chatType = false;
  static String _currentFileName = '';
  static String _fileContent = '';
  static String _status = '';
  static String _chatHistory = '';
  static String _summaryHistory = '';
  static String _chatID = '';
  static String _summarizeID = '';
  static bool _isFirstMessage = true;
  
  static String get openaiKeys => _openaiKeys;
  static set openaiKeys(String keys) {
    _openaiKeys = keys;
  }

  static bool get fileUploaded => _fileUploaded;
  static set fileUploaded(bool upFile) {
    _fileUploaded = upFile;
  }

  static bool get chatType => _chatType;
  static set chatType(bool chatType) {
    _chatType = chatType;
  }

  static String get currentFileName => _currentFileName;
  static set currentFileName(String currentFileName) {
    _currentFileName = currentFileName;
  }

  static String get fileContent => _fileContent;
  static set fileContent(String fileContent) {
    _fileContent = fileContent;
  }

  static String get status => _status;
  static set status(String status) {
    _status = status;
  }

  static String get chatHistory => _chatHistory;
  static set chatHistory(String chatHistory) {
    _chatHistory = chatHistory;
  }

  static String get summaryHistory => _summaryHistory;
  static set summaryHistory(String summaryHistory) {
    _summaryHistory = summaryHistory;
  }

  static String get chatID => _chatID;
  static set chatID(String chatID) {
    _chatID = chatID;
  }

  static String get summarizeID => _summarizeID;
  static set summarizeID(String summarizeID) {
    _summarizeID = summarizeID;
  }

  static bool get isFirstMessage => _isFirstMessage;
  static set isFirstMessage(bool isFirstMessage) {
    _isFirstMessage = isFirstMessage;
  }
}
