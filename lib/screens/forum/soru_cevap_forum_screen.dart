/// Soru–Cevap Forum Ekranı
/// 200 karakter düz yazı, admin onayı yok, tarih + kelime filtreleme, yorum bölümü

import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/forum_post_model.dart';
import '../../services/forum_service.dart';
import '../../services/auth_service.dart';

class SoruCevapForumScreen extends StatefulWidget {
  const SoruCevapForumScreen({super.key});

  @override
  State<SoruCevapForumScreen> createState() => _SoruCevapForumScreenState();
}

class _SoruCevapForumScreenState extends State<SoruCevapForumScreen> {
  final ForumService _forumService = ForumService();
  final AuthService _authService = AuthService();
  static const String _category = 'soru_cevap';

  // Filtreleme
  String _searchKeyword = '';
  String _dateFilter = 'all'; // all, today, week, month

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('💬 Soru–Cevap'),
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilters,
          ),
        ],
      ),
      body: Column(
        children: [
          // Arama kutusu
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: TextField(
              onChanged: (value) => setState(() => _searchKeyword = value.trim().toLowerCase()),
              decoration: InputDecoration(
                hintText: 'Kelime ara (örn: muğla, sınav, proje...)',
                prefixIcon: const Icon(Icons.search, size: 20),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                suffixIcon: _searchKeyword.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () => setState(() => _searchKeyword = ''),
                      )
                    : null,
              ),
            ),
          ),

          // Aktif filtreler
          if (_dateFilter != 'all' || _searchKeyword.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Row(
                children: [
                  if (_dateFilter != 'all')
                    Chip(
                      label: Text(_getDateFilterLabel(), style: const TextStyle(fontSize: 11)),
                      onDeleted: () => setState(() => _dateFilter = 'all'),
                      deleteIconColor: Colors.orange.shade700,
                      backgroundColor: Colors.orange.shade100,
                      visualDensity: VisualDensity.compact,
                    ),
                  if (_searchKeyword.isNotEmpty) ...[
                    if (_dateFilter != 'all') const SizedBox(width: 8),
                    Chip(
                      label: Text('"$_searchKeyword"', style: const TextStyle(fontSize: 11)),
                      onDeleted: () => setState(() => _searchKeyword = ''),
                      deleteIconColor: Colors.orange.shade700,
                      backgroundColor: Colors.orange.shade100,
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ],
              ),
            ),

          // Paylaşımlar listesi
          Expanded(
            child: StreamBuilder<List<ForumPost>>(
              stream: _forumService.getPostsStream(_category),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                var posts = snapshot.data ?? [];

                // Filtreleme uygula
                posts = _applyFilters(posts);

                if (posts.isEmpty) {
                  return _buildEmptyState();
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: posts.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) => _buildPostCard(posts[index]),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddPostDialog,
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add),
      ),
    );
  }

  List<ForumPost> _applyFilters(List<ForumPost> posts) {
    var filtered = posts;

    // Tarih filtresi
    if (_dateFilter != 'all') {
      final now = DateTime.now();
      filtered = filtered.where((post) {
        switch (_dateFilter) {
          case 'today':
            return post.createdAt.year == now.year &&
                post.createdAt.month == now.month &&
                post.createdAt.day == now.day;
          case 'week':
            final weekAgo = now.subtract(const Duration(days: 7));
            return post.createdAt.isAfter(weekAgo);
          case 'month':
            final monthAgo = now.subtract(const Duration(days: 30));
            return post.createdAt.isAfter(monthAgo);
          default:
            return true;
        }
      }).toList();
    }

    // Kelime filtresi (sadece paylaşım metni, yorumlar dahil değil)
    if (_searchKeyword.isNotEmpty) {
      filtered = filtered.where((post) {
        return post.text.toLowerCase().contains(_searchKeyword);
      }).toList();
    }

    return filtered;
  }

  void _showFilters() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filtrele',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text('Tarih', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                _buildFilterChip('Tümü', 'all'),
                _buildFilterChip('Bugün', 'today'),
                _buildFilterChip('Bu Hafta', 'week'),
                _buildFilterChip('Bu Ay', 'month'),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Uygula'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _dateFilter == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() => _dateFilter = value);
      },
      selectedColor: Colors.orange.shade200,
      labelStyle: TextStyle(
        fontSize: 12,
        color: isSelected ? Colors.orange.shade900 : Colors.grey.shade700,
      ),
    );
  }

  String _getDateFilterLabel() {
    switch (_dateFilter) {
      case 'today':
        return 'Bugün';
      case 'week':
        return 'Bu Hafta';
      case 'month':
        return 'Bu Ay';
      default:
        return '';
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.question_answer, size: 64, color: Colors.orange.shade300),
          const SizedBox(height: 16),
          const Text(
            'Henüz soru yok',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'İlk soruyu sen sor!',
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Yazı
              Text(
                post.text,
                style: const TextStyle(fontSize: 14, height: 1.4),
              ),
              const SizedBox(height: 10),
              // Paylaşan ve tarih
              Row(
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.orange.shade100,
                    child: Text(
                      post.displayName.isNotEmpty ? post.displayName[0].toUpperCase() : '?',
                      style: TextStyle(fontSize: 10, color: Colors.orange.shade800, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    post.displayName,
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                  const Spacer(),
                  Text(
                    _formatDate(post.createdAt),
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.comment, size: 14, color: Colors.grey.shade500),
                  const SizedBox(width: 3),
                  Text(
                    '${post.commentCount}',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
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

  /// Yeni soru ekleme
  Future<void> _showAddPostDialog() async {
    final textController = TextEditingController();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
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
                'Yeni Soru',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Yazı alanı
              TextField(
                controller: textController,
                maxLength: 200,
                maxLines: 4,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Sorunuzu yazın...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  counterText: '',
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Maksimum 200 karakter',
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
                        const SnackBar(content: Text('Soru boş olamaz')),
                      );
                      return;
                    }
                    try {
                      await _forumService.addPost(
                        text: textController.text.trim(),
                        category: _category,
                        maxLength: 200,
                      );
                      if (context.mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('✅ Soru paylaşıldı!')),
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
                    backgroundColor: Colors.orange,
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
    );
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
                  // Soru
                  Text(
                    post.text,
                    style: const TextStyle(fontSize: 16, height: 1.5, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 12),

                  // Paylaşan ve tarih
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 14,
                        backgroundColor: Colors.orange.shade100,
                        child: Text(
                          post.displayName.isNotEmpty ? post.displayName[0].toUpperCase() : '?',
                          style: TextStyle(fontSize: 11, color: Colors.orange.shade800, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        post.displayName,
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 12, fontWeight: FontWeight.w600),
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
                    'Cevaplar (${post.commentCount})',
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
                          'Henüz cevap yok',
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

            // Cevap yazma alanı
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
                        hintText: 'Cevap yaz...',
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
                        : Icon(Icons.send, color: Colors.orange.shade600),
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
            backgroundColor: Colors.orange.shade100,
            child: Text(
              comment.displayName.isNotEmpty ? comment.displayName[0].toUpperCase() : '?',
              style: TextStyle(fontSize: 11, color: Colors.orange.shade700, fontWeight: FontWeight.bold),
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
