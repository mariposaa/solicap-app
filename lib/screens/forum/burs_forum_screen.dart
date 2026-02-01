/// Burs Dayanışma Forum Ekranı
/// Resim + 150 karakter yazı paylaşımı, 3 sütun grid, yorum bölümü

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../theme/app_theme.dart';
import '../../models/forum_post_model.dart';
import '../../services/forum_service.dart';
import '../../services/auth_service.dart';

class BursForumScreen extends StatefulWidget {
  const BursForumScreen({super.key});

  @override
  State<BursForumScreen> createState() => _BursForumScreenState();
}

class _BursForumScreenState extends State<BursForumScreen> {
  final ForumService _forumService = ForumService();
  final AuthService _authService = AuthService();
  static const String _category = 'burs_dayanisma';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('🎁 Burs Dayanışma'),
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
      ),
      body: StreamBuilder<List<ForumPost>>(
        stream: _forumService.getPostsStream(_category),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final posts = snapshot.data ?? [];

          if (posts.isEmpty) {
            return _buildEmptyState();
          }

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.7,
            ),
            itemCount: posts.length,
            itemBuilder: (context, index) => _buildPostCard(posts[index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddPostDialog,
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.card_giftcard, size: 64, color: Colors.green.shade300),
          const SizedBox(height: 16),
          const Text(
            'Henüz paylaşım yok',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'İlk burs paylaşımını sen yap!',
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildPostCard(ForumPost post) {
    return GestureDetector(
      onTap: () => _showPostDetail(post),
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Resim
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                color: Colors.grey.shade200,
                child: post.imageUrl != null
                    ? Image.network(
                        post.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            Icon(Icons.image, color: Colors.grey.shade400, size: 32),
                      )
                    : Center(
                        child: Icon(Icons.card_giftcard, color: Colors.green.shade300, size: 32),
                      ),
              ),
            ),
            // Yazı
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.text,
                      style: const TextStyle(fontSize: 10, height: 1.2),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Icon(Icons.comment, size: 10, color: Colors.grey.shade500),
                        const SizedBox(width: 2),
                        Text(
                          '${post.commentCount}',
                          style: TextStyle(fontSize: 9, color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Paylaşım detay sayfası (yorum bölümü ile)
  void _showPostDetail(ForumPost post) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _PostDetailSheet(post: post),
    );
  }

  /// Yeni paylaşım ekleme
  Future<void> _showAddPostDialog() async {
    final textController = TextEditingController();
    Uint8List? selectedImage;
    final picker = ImagePicker();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Yeni Paylaşım',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                // Resim seçimi
                GestureDetector(
                  onTap: () async {
                    final picked = await picker.pickImage(
                      source: ImageSource.gallery,
                      imageQuality: 70,
                      maxWidth: 800,
                    );
                    if (picked != null) {
                      final bytes = await picked.readAsBytes();
                      setSheetState(() => selectedImage = bytes);
                    }
                  },
                  child: Container(
                    height: 120,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: selectedImage != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.memory(selectedImage!, fit: BoxFit.cover),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_photo_alternate, size: 40, color: Colors.grey.shade400),
                              const SizedBox(height: 4),
                              Text('Resim Ekle (opsiyonel)', style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 16),

                // Yazı alanı
                TextField(
                  controller: textController,
                  maxLength: 150,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Burs hakkında bilgi paylaş...',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    counterText: '',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Maksimum 150 karakter',
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
                ),
                const SizedBox(height: 16),

                // Paylaş butonu
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (textController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Yazı alanı boş olamaz')),
                        );
                        return;
                      }
                      try {
                        await _forumService.addPost(
                          text: textController.text.trim(),
                          category: _category,
                          imageBytes: selectedImage,
                        );
                        if (context.mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('✅ Paylaşım eklendi')),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Hata: $e')),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Paylaş', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Paylaşım detay ve yorum sheet'i
class _PostDetailSheet extends StatefulWidget {
  final ForumPost post;
  const _PostDetailSheet({required this.post});

  @override
  State<_PostDetailSheet> createState() => _PostDetailSheetState();
}

class _PostDetailSheetState extends State<_PostDetailSheet> {
  final ForumService _forumService = ForumService();
  final AuthService _authService = AuthService();
  final TextEditingController _commentController = TextEditingController();
  bool _isSending = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    final isOwner = _authService.currentUserId == post.userId;

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // İçerik
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                children: [
                  // Resim
                  if (post.imageUrl != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        post.imageUrl!,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  const SizedBox(height: 12),

                  // Yazı
                  Text(
                    post.text,
                    style: const TextStyle(fontSize: 16, height: 1.4),
                  ),
                  const SizedBox(height: 8),

                  // Paylaşan ve tarih
                  Row(
                    children: [
                      Text(
                        post.displayName,
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                      const Spacer(),
                      Text(
                        _formatDate(post.createdAt),
                        style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
                      ),
                      if (isOwner) ...[
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () async {
                            await _forumService.deletePost(post.id);
                            if (context.mounted) Navigator.pop(context);
                          },
                          child: Icon(Icons.delete_outline, size: 18, color: Colors.red.shade400),
                        ),
                      ],
                    ],
                  ),

                  const Divider(height: 32),

                  // Yorumlar başlık
                  Text(
                    'Yorumlar (${post.commentCount})',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 12),

                  // Yorumlar listesi
                  StreamBuilder<List<ForumComment>>(
                    stream: _forumService.getCommentsStream(post.id),
                    builder: (context, snapshot) {
                      final comments = snapshot.data ?? [];
                      if (comments.isEmpty) {
                        return Text(
                          'Henüz yorum yok',
                          style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                        );
                      }
                      return Column(
                        children: comments.map((c) => _buildCommentTile(c)).toList(),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Yorum yazma alanı
            Container(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 12,
                bottom: MediaQuery.of(context).viewInsets.bottom + 12,
              ),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                border: Border(top: BorderSide(color: Colors.grey.shade200)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: InputDecoration(
                        hintText: 'Yorum yaz...',
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _isSending ? null : _sendComment,
                    icon: _isSending
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                        : Icon(Icons.send, color: Colors.green.shade600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentTile(ForumComment comment) {
    final isOwner = _authService.currentUserId == comment.userId;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: Colors.green.shade100,
            child: Text(
              comment.displayName.isNotEmpty ? comment.displayName[0].toUpperCase() : '?',
              style: TextStyle(fontSize: 12, color: Colors.green.shade700),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      comment.displayName,
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _formatDate(comment.createdAt),
                      style: TextStyle(color: Colors.grey.shade500, fontSize: 10),
                    ),
                    if (isOwner) ...[
                      const Spacer(),
                      GestureDetector(
                        onTap: () => _forumService.deleteComment(comment.id, widget.post.id),
                        child: Icon(Icons.close, size: 14, color: Colors.grey.shade400),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(comment.text, style: const TextStyle(fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _sendComment() async {
    if (_commentController.text.trim().isEmpty) return;
    setState(() => _isSending = true);
    try {
      await _forumService.addComment(
        postId: widget.post.id,
        text: _commentController.text.trim(),
      );
      _commentController.clear();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hata: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inMinutes < 1) return 'şimdi';
    if (diff.inMinutes < 60) return '${diff.inMinutes}dk';
    if (diff.inHours < 24) return '${diff.inHours}sa';
    if (diff.inDays < 7) return '${diff.inDays}g';
    return '${date.day}.${date.month}';
  }
}
