import 'package:flutter/material.dart';
import 'package:molita_flutter/viewmodels/orang_tua/chatbot_viewmodel.dart';
import 'package:provider/provider.dart';
import 'widgets/build_message_widget.dart';

class ChatBotView extends StatelessWidget {
  const ChatBotView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChatBotViewModel(),
      child: Consumer<ChatBotViewModel>(
        builder: (context, viewModel, _) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Molibot",
                    style: TextStyle(
                      color: Colors.blue[800],
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(Icons.circle, size: 8, color: Colors.green[600]),
                      SizedBox(width: 6),
                      Text(
                        "Online",
                        style: TextStyle(
                          color: Colors.green[700],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.settings, color: Colors.grey[600]),
                  onPressed:
                      () => showDialog(
                        context: context,
                        builder:
                            (context) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 24,
                              title: Text(
                                "Pengaturan",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueGrey[900],
                                ),
                              ),
                              content: Text(
                                "Apakah Anda ingin menghapus semua riwayat percakapan?",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[700],
                                  height: 1.4,
                                ),
                              ),
                              actionsPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              actions: [
                                TextButton(
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    foregroundColor: Colors.blue[700],
                                  ),
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Text(
                                    "Batal",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.redAccent[400],
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () {
                                    viewModel.clearMessages();
                                    Navigator.of(context).pop();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "Riwayat percakapan berhasil dihapus",
                                          style: TextStyle(fontSize: 14),
                                        ),
                                        duration: Duration(seconds: 2),
                                        behavior: SnackBarBehavior.floating,
                                        margin: EdgeInsets.symmetric(
                                          vertical: 60,
                                          horizontal: 20,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        backgroundColor: Colors.grey[900]
                                            ?.withOpacity(0.9),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "Hapus",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                      ),
                ),
              ],
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child:
                        viewModel.isLoading || viewModel.messages.isNotEmpty
                            ? ListView.builder(
                              itemCount: viewModel.messages.length,
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 8,
                              ),
                              itemBuilder: (context, index) {
                                return buildMessage({
                                  'role': viewModel.messages[index].role,
                                  'content': viewModel.messages[index].content,
                                  'time': viewModel.messages[index].time,
                                });
                              },
                            )
                            : Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.chat_bubble_outline,
                                      size: 58,
                                      color: Colors.grey[300],
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      "Ayo konsultasi dengan Molibot!\nTanyakan tentang tumbuh kembang anak, imunisasi, atau gizi si Kecil.",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                  ),
                  if (viewModel.isLoading)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          SizedBox(width: 8),
                          Text("Molibot sedang mengetik..."),
                        ],
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: viewModel.controller,
                              decoration: InputDecoration(
                                hintText: 'Ketik pesan...',
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 14,
                                  horizontal: 14,
                                ),
                                hintStyle: TextStyle(color: Colors.grey[500]),
                              ),
                              onSubmitted: (text) {
                                if (text.isNotEmpty && !viewModel.isLoading) {
                                  viewModel.sendMessage(text);
                                  viewModel.controller.clear();
                                }
                              },
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.send, color: Colors.blue[800]),
                            onPressed: () {
                              final text = viewModel.controller.text.trim();
                              if (text.isNotEmpty && !viewModel.isLoading) {
                                viewModel.sendMessage(text);
                                viewModel.controller.clear();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
