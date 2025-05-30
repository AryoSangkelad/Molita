import 'package:flutter/material.dart';

Widget buildMessage(Map<String, dynamic> message) {
  final isUser = message['role'] == 'user';
  final time = message['time'] as DateTime;
  print(message['content']);
  return Align(
    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isUser ? Colors.green[100] : Colors.blue[50],
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser)
            Row(
              children: [
                Icon(Icons.smart_toy, size: 16, color: Colors.blue[700]),
                SizedBox(width: 6),
                Text(
                  'Molibot',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900],
                  ),
                ),
              ],
            ),
          SizedBox(height: 4),
          _buildFormattedText(message['content'], isUser),
          SizedBox(height: 8),
          Text(
            "${time.hour}:${time.minute.toString().padLeft(2, '0')}",
            style: TextStyle(fontSize: 10, color: Colors.grey[600]),
          ),
        ],
      ),
    ),
  );
}

Widget _buildFormattedText(String text, bool isUser) {
  final lines = text.trim().split('\n');
  final widgets = <Widget>[];

  final boldRegex = RegExp(r'\*\*(.+?)\*\*');

  for (final line in lines) {
    if (line.trim().isEmpty) {
      widgets.add(SizedBox(height: 6)); // Spasi antar paragraf
      continue;
    }

    final spans = <TextSpan>[];
    int lastEnd = 0;

    for (final match in boldRegex.allMatches(line)) {
      if (match.start > lastEnd) {
        spans.add(
          TextSpan(
            text: line.substring(lastEnd, match.start),
            style: TextStyle(
              color: isUser ? Colors.grey[800] : Colors.grey[900],
              height: 1.5,
              fontFamilyFallback: ['NotoColorEmoji', 'Segoe UI Emoji'],
            ),
          ),
        );
      }

      spans.add(
        TextSpan(
          text: match.group(1),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isUser ? Colors.grey[800] : Colors.grey[900],
            height: 1.5,
          ),
        ),
      );
      lastEnd = match.end;
    }

    if (lastEnd < line.length) {
      spans.add(
        TextSpan(
          text: line.substring(lastEnd),
          style: TextStyle(
            color: isUser ? Colors.grey[800] : Colors.grey[900],
            height: 1.5,
          ),
        ),
      );
    }

    widgets.add(
      RichText(text: TextSpan(children: spans), textAlign: TextAlign.left),
    );
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: widgets,
  );
}
