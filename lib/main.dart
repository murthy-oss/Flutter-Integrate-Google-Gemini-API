import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

// API key for Gemini initialization
const apiKey = 'YOUR_API_KEY';

void main() {
  // Initialize Gemini with the API key and enable debugging
  Gemini.init(apiKey: apiKey, enableDebugging: true);
  runApp(MyApp());
}

// Main application widget
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, 
      home: ChatScreen(), 
    );
  }
}

// Stateful widget for the chat screen
class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

// State class for ChatScreen
class _ChatScreenState extends State<ChatScreen> {
  // Controller for the input field
  final TextEditingController _controller = TextEditingController(); 
  // List to store chat messages
  final List<Map<String, String>> _messages = []; 

  // Function to handle sending a message
  void _sendMessage() async {
    // Get and trim the input text
    final inputText = _controller.text.trim(); 
    // Do nothing if input is empty
    if (inputText.isEmpty) return; 

    // Add the user's message to the chat
    setState(() {
      _messages.add({'sender': 'user', 'text': inputText});
    });
    // Clear the input field
    _controller.clear(); 

    // Prepare the input for the Gemini API
    final parts = [Part.text(inputText)];
     // Get the response from Gemini
    final response = await Gemini.instance
        .prompt(parts: parts);

    // Add the bot's response to the chat
    setState(() {
      _messages.add({
        'sender': 'bot',
        'text': response?.output ?? 'No response generated', // Handle null response
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GFG Chatbot'),
        backgroundColor: Colors.green, 
        foregroundColor: Colors.white, 
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0), 
        child: Column(
          children: [
            // Expanded widget to display the chat messages
            Expanded(
              child: ListView.builder(
                // Number of messages
                itemCount: _messages.length, 
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  // Check if the message is from the user
                  final isUser = message['sender'] =='user'; 
                  return Align(
                    alignment: isUser
                        ? Alignment.centerRight
                        : Alignment.centerLeft, 
                    child: Container(
                      margin: EdgeInsets.symmetric(
                          vertical: 4, horizontal: 8), 
                      padding: EdgeInsets.all(12), 
                      decoration: BoxDecoration(
                        color: isUser
                            ? Colors.blue[100]
                            : Colors.grey[300], 
                        borderRadius:
                            BorderRadius.circular(8), 
                      ),
                      child:
                          Text(message['text'] ?? ''), 
                    ),
                  );
                },
              ),
            ),
            // Input field and send button
            Padding(
              padding:
                  const EdgeInsets.all(8.0), 
              child: Row(
                children: [
                  // Input field for typing messages
                  Expanded(
                    child: TextField(
                      // Attach the controller
                      controller: _controller, 
                      decoration: InputDecoration(
                        // Placeholder text
                        hintText: 'Type your message...', 
                        border: OutlineInputBorder(), 
                      ),
                    ),
                  ),
                  SizedBox(width: 8), 
                  // Send button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(), 
                      padding: EdgeInsets.all(12), 
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    // Call _sendMessage when pressed
                    onPressed: _sendMessage, 
                    child: Icon(
                      Icons.send, 
                      size: 30, 
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
