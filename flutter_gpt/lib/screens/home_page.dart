import '../services/ai_handler.dart';
import 'package:flutter/material.dart';
import '../services/is_validation.dart';
import 'package:gpt_flutter/screens/chat_screen.dart';
import 'package:gpt_flutter/screens/summarize_page.dart';
import 'package:gpt_flutter/providers/global_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gpt_flutter/providers/active_theme_provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _textEditingController = TextEditingController();
  bool _isObscured = true;
  String _chatbotResponse = '';
  String _openaikey = Global.openaiKeys;
  
  
  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    const String imageAssetPath = ThemeMode == Themes.dark
        ? 'assets/images/bot.png'
        : 'assets/images/bot.png';
      
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text('Chatbot & Summarize',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800)),
            SizedBox(height: 16),
            Image.asset(
              'assets/images/bot.png',
              height: 200,
              width: 200,
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: _textEditingController,
                
                obscureText: _isObscured,
                decoration: InputDecoration(
                  hintText: 'Enter your openaikeys...',
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.onPrimary),
                      borderRadius: BorderRadius.circular(20.0)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                  suffixIcon: IconButton(
                    onPressed: _togglePasswordVisibility,
                    icon: Icon(
                      _isObscured ? Icons.visibility : Icons.visibility_off,
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () => _onChatbotPressed(context),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset(
                            'assets/images/robot.png',
                            height: 28,
                            width: 30,
                          ),
                          SizedBox(width: 18),
                          Text(
                            'Chatbot',
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                      style: ButtonStyle(
                        fixedSize: MaterialStateProperty.all(
                          Size(180, 50),
                        ),
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            // Đặt màu nút dựa vào trạng thái của nó.
                            if (states.contains(MaterialState.pressed)) {
                              return Colors.blue; // Màu khi nút được nhấn
                            }
                            return Theme.of(context)
                                .colorScheme
                                .secondary; // Màu khi nút không được nhấn
                          },
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _onSummarizePressed,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset(
                            'assets/images/licensing.png',
                            height: 28,
                            width: 30,
                          ),
                          SizedBox(width: 18),
                          Text(
                            'Summarize',
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                      style: ButtonStyle(
                        fixedSize: MaterialStateProperty.all(
                          Size(180, 50),
                        ),
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            // Đặt màu nút dựa vào trạng thái của nó.
                            if (states.contains(MaterialState.pressed)) {
                              return Colors.blue; // Màu khi nút được nhấn
                            }
                            return Theme.of(context)
                                .colorScheme
                                .secondary; // Màu khi nút không được nhấn
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Text(
              _chatbotResponse,
              style: TextStyle(
                fontSize: 15,
                color: Colors.red.shade600,
              ),
            ),
          ]),
        ),
      ),
    );
  }

  void _onChatbotPressed(BuildContext context) async {
    // String _openaikey = "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";//_textEditingController.text;
    _openaikey = _textEditingController.text;

    bool isValidKey = await isKeyValid(_openaikey);

    if (_openaikey.isEmpty) {
      setState(() {
        _chatbotResponse = "Please give the openai keys.";
      });
    } else if (!isValidKey) {
      setState(() {
        _chatbotResponse = "Key not work";
      });
    } else {
      setState(() {
        _chatbotResponse = "";
      });

      Global.openaiKeys = _openaikey;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ChatScreen(isChatbot: true)),
      );
    }
  }

  Future<void> _onSummarizePressed() async {
    _openaikey = _textEditingController.text;

    //String _openaikey = "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";
    bool isValidKey = await isKeyValid(_openaikey);

    if (_openaikey.isEmpty) {
      setState(() {
        _chatbotResponse = "Please give the openai keys.";
      });
    } else if (!isValidKey) {
      setState(() {
        _chatbotResponse = _openaikey;
      });
    } else {
      setState(() {
        _chatbotResponse = "";
      });

      Global.openaiKeys = _openaikey;

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SummarizeDoc()),
      );
    }
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }
}
