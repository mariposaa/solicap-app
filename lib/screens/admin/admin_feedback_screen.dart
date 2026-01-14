import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/feedback_service.dart';
import '../../models/feedback_model.dart';
import 'package:intl/intl.dart';

class AdminFeedbackScreen extends StatefulWidget {
  const AdminFeedbackScreen({super.key});

  @override
  State<AdminFeedbackScreen> createState() => _AdminFeedbackScreenState();
}

class _AdminFeedbackScreenState extends State<AdminFeedbackScreen> {
  final FeedbackService _feedbackService = FeedbackService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('📝 Geri Bildirim Listesi'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<List<UserFeedback>>(
        stream: _feedbackService.getFeedbacks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));
          }

          final feedbacks = snapshot.data ?? [];

          if (feedbacks.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox, size: 64, color: AppTheme.textMuted),
                  SizedBox(height: 16),
                  Text('Henüz bildirim yok.', style: TextStyle(color: AppTheme.textMuted)),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: feedbacks.length,
            itemBuilder: (context, index) {
              final feedback = feedbacks[index];
              final dateStr = DateFormat('dd.MM.yyyy HH:mm').format(feedback.timestamp);

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: feedback.isRead 
                      ? BorderSide.none 
                      : const BorderSide(color: AppTheme.primaryColor, width: 1),
                ),
                elevation: feedback.isRead ? 1 : 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                                radius: 14,
                                child: const Icon(Icons.person, size: 16, color: AppTheme.primaryColor),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                feedback.userName,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                            ],
                          ),
                          Text(
                            dateStr,
                            style: const TextStyle(color: AppTheme.textMuted, fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.backgroundColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          feedback.content,
                          style: const TextStyle(fontSize: 14, height: 1.5),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (!feedback.isRead)
                            TextButton.icon(
                              onPressed: () => _feedbackService.markAsRead(feedback.id),
                              icon: const Icon(Icons.check, size: 18),
                              label: const Text('Okundu'),
                              style: TextButton.styleFrom(foregroundColor: AppTheme.primaryColor),
                            ),
                          const SizedBox(width: 8),
                          IconButton(
                            onPressed: () => _showDeleteConfirm(feedback.id),
                            icon: const Icon(Icons.delete_outline, size: 20, color: Colors.red),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showDeleteConfirm(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Silinsin mi?'),
        content: const Text('Bu bildirimi silmek istediğine emin misin?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('İptal')),
          ElevatedButton(
            onPressed: () {
              _feedbackService.deleteFeedback(id);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Sil'),
          ),
        ],
      ),
    );
  }
}
