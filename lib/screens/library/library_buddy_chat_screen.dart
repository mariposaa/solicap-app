/// SOLICAP - Kütüphane Arkadaşın Olacak mesaj ekranı
/// Sadece şablon mesajlar; 10 dk sonra mesajlar silinir.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../theme/app_theme.dart';
import '../../models/library_buddy_message_model.dart';
import '../../models/library_message_template_model.dart';
import '../../services/library_buddy_service.dart';
import '../../services/auth_service.dart';
import '../../services/library_message_template_service.dart';

class LibraryBuddyChatScreen extends StatefulWidget {
  final String matchId;
  final String otherUserId;
  final String otherDisplayName;

  const LibraryBuddyChatScreen({
    super.key,
    required this.matchId,
    required this.otherUserId,
    required this.otherDisplayName,
  });

  @override
  State<LibraryBuddyChatScreen> createState() => _LibraryBuddyChatScreenState();
}

class _LibraryBuddyChatScreenState extends State<LibraryBuddyChatScreen> {
  final LibraryBuddyService _buddyService = LibraryBuddyService();
  final AuthService _authService = AuthService();
  final LibraryMessageTemplateService _templateService = LibraryMessageTemplateService();
  final ScrollController _scrollController = ScrollController();
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    _onOpenChat();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Açılışta: 10 dk eski mesajları sil, lastSeen güncelle
  Future<void> _onOpenChat() async {
    await _buddyService.deleteMessagesOlderThan(widget.matchId);
    await _buddyService.updateMatchLastSeen(widget.matchId);
  }

  Future<void> _sendText(String text) async {
    if (text.isEmpty || _sending) return;
    setState(() => _sending = true);
    try {
      final ok = await _buddyService.sendMessage(widget.matchId, text);
      if (mounted) {
        setState(() => _sending = false);
        if (ok) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_scrollController.hasClients) {
              _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
              );
            }
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gönderilemedi.'), behavior: SnackBarBehavior.floating),
          );
        }
      }
    } catch (_) {
      if (mounted) setState(() => _sending = false);
    }
  }

  void _onTemplateTap(LibraryMessageTemplate template) {
    if (template.type == 'number_choice' && template.numberOptions != null && template.numberOptions!.isNotEmpty) {
      showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(template.label),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: template.numberOptions!
                .map((n) => ListTile(
                      title: Text('$n'),
                      onTap: () {
                        Navigator.pop(ctx);
                        _sendText(template.buildText(n));
                      },
                    ))
                .toList(),
          ),
        ),
      );
    } else {
      _sendText(template.buildText());
    }
  }

  @override
  Widget build(BuildContext context) {
    final myUserId = _authService.currentUserId ?? '';

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          widget.otherDisplayName.isNotEmpty ? widget.otherDisplayName : 'Arkadaş',
          style: const TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Mesaj listesi
          Expanded(
            child: StreamBuilder<List<LibraryBuddyMessage>>(
              stream: _buddyService.getMessagesStream(widget.matchId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final messages = snapshot.data ?? [];
                if (messages.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        'Henüz mesaj yok. Aşağıdaki şablonlardan birini seçerek gönder.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppTheme.textMuted, fontSize: 14),
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final isMe = msg.senderId == myUserId;
                    return Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
                        decoration: BoxDecoration(
                          color: isMe ? AppTheme.secondaryColor.withOpacity(0.15) : AppTheme.surfaceColor,
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(16),
                            topRight: const Radius.circular(16),
                            bottomLeft: Radius.circular(isMe ? 16 : 4),
                            bottomRight: Radius.circular(isMe ? 4 : 16),
                          ),
                          border: Border.all(color: AppTheme.dividerColor.withOpacity(0.5)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              msg.text,
                              style: const TextStyle(color: AppTheme.textPrimary, fontSize: 15, height: 1.35),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              DateFormat('HH:mm').format(msg.createdAt),
                              style: TextStyle(color: AppTheme.textMuted, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          // Şablonlar
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor,
              border: Border(top: BorderSide(color: AppTheme.dividerColor)),
            ),
            child: SafeArea(
              child: StreamBuilder<List<LibraryMessageTemplate>>(
                stream: _templateService.getTemplatesStream(),
                builder: (context, snapshot) {
                  final templates = snapshot.data ?? defaultLibraryMessageTemplates;
                  return Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: templates.map((t) {
                      return ActionChip(
                        label: Text(t.label.length > 25 ? '${t.label.substring(0, 22)}...' : t.label, style: const TextStyle(fontSize: 13)),
                        onPressed: _sending ? null : () => _onTemplateTap(t),
                        backgroundColor: AppTheme.secondaryColor.withOpacity(0.1),
                        side: BorderSide(color: AppTheme.secondaryColor.withOpacity(0.3)),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
