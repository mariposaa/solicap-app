/// Admin: Forum paylaşımlarını onayla/reddet (Erasmus için)

import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/forum_post_model.dart';
import '../../services/forum_service.dart';

class AdminForumApprovalScreen extends StatefulWidget {
  const AdminForumApprovalScreen({super.key});

  @override
  State<AdminForumApprovalScreen> createState() => _AdminForumApprovalScreenState();
}

class _AdminForumApprovalScreenState extends State<AdminForumApprovalScreen> {
  final ForumService _forumService = ForumService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('✅ Forum Onayları'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<List<ForumPost>>(
        stream: _forumService.getPendingPostsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final posts = snapshot.data ?? [];

          if (posts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle_outline, size: 64, color: Colors.green.shade300),
                  const SizedBox(height: 16),
                  const Text(
                    'Onay bekleyen paylaşım yok',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tüm paylaşımlar onaylanmış',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: posts.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) => _buildPostCard(posts[index]),
          );
        },
      ),
    );
  }

  Widget _buildPostCard(ForumPost post) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Başlık
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _getCategoryName(post.category),
                    style: TextStyle(fontSize: 11, color: Colors.blue.shade800, fontWeight: FontWeight.w600),
                  ),
                ),
                const Spacer(),
                Text(
                  _formatDate(post.createdAt),
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Resim
            if (post.imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  post.imageUrl!,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Container(height: 180, color: Colors.grey.shade200, child: Icon(Icons.image, color: Colors.grey.shade400)),
                ),
              ),
            if (post.imageUrl != null) const SizedBox(height: 12),

            // Yazı
            Text(
              post.text,
              style: const TextStyle(fontSize: 14, height: 1.4),
            ),
            const SizedBox(height: 12),

            // İletişim bilgisi
            if (post.contactInfo != null && post.contactInfo!.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.alternate_email, size: 14, color: Colors.grey.shade700),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        post.contactInfo!,
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade800),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 12),

            // Paylaşan
            Text(
              'Paylaşan: ${post.displayName}',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
            const SizedBox(height: 16),

            // Aksiyon butonları
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await _forumService.approvePost(post.id);
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('✅ Paylaşım onaylandı')),
                        );
                      }
                    },
                    icon: const Icon(Icons.check, size: 18),
                    label: const Text('Onayla'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Paylaşımı Reddet'),
                          content: const Text('Bu paylaşım silinecek ve yayınlanmayacak.'),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('İptal')),
                            ElevatedButton(
                              onPressed: () => Navigator.pop(ctx, true),
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                              child: const Text('Reddet'),
                            ),
                          ],
                        ),
                      );
                      if (confirm == true) {
                        await _forumService.rejectPost(post.id);
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('🗑️ Paylaşım reddedildi')),
                          );
                        }
                      }
                    },
                    icon: const Icon(Icons.close, size: 18),
                    label: const Text('Reddet'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getCategoryName(String category) {
    switch (category) {
      case 'erasmus':
        return 'Erasmus';
      case 'burs_dayanisma':
        return 'Burs Dayanışma';
      case 'soru_cevap':
        return 'Soru-Cevap';
      case 'kariyer_staj':
        return 'Kariyer/Staj';
      default:
        return category;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inMinutes < 1) return 'şimdi';
    if (diff.inMinutes < 60) return '${diff.inMinutes}dk';
    if (diff.inHours < 24) return '${diff.inHours}sa';
    if (diff.inDays < 7) return '${diff.inDays}g';
    return '${date.day}.${date.month}.${date.year}';
  }
}
