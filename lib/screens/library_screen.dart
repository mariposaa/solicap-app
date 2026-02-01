/// SOLICAP - Kütüphane Ekranı
/// 4.–12. sınıf müfredatı + KPSS genel kültür, AI yanıt (max 250 karakter).
/// Sekmeler: Kütüphane | Kayıtlı Notlarım | Arkadaşın Olacak. Günlük 1 giriş 30 💎.

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:audioplayers/audioplayers.dart';
import '../theme/app_theme.dart';
import '../services/points_service.dart';
import '../services/gemini_service.dart';
import '../services/auth_service.dart';
import '../services/library_buddy_service.dart';
import '../services/library_saved_service.dart';
import '../services/library_message_template_service.dart';
import '../models/library_buddy_model.dart';
import '../models/library_saved_answer_model.dart';
import '../models/library_buddy_message_model.dart';
import '../models/library_message_template_model.dart';
import 'library/library_buddy_form_screen.dart';
import 'library/library_buddy_chat_screen.dart';

const String _keyLastLibraryEntryDate = 'last_library_entry_date';
const String _keyLibraryAmbiance = 'library_ambiance';

/// Kütüphane ambiansı: sıcak renk paleti + lamba ışığı
class LibraryTheme {
  static const Color backgroundColor = Color(0xFFF5F0E8);   // Krem / eski kâğıt
  static const Color surfaceColor = Color(0xFFFDFBF7);      // Hafif bej
  static const Color accentColor = Color(0xFFB8860B);       // Koyu altın / amber
  static const Color accentLight = Color(0xFFD4A84B);       // Açık amber
  static const Color textPrimary = Color(0xFF3E3229);      // Koyu kahve
  static const Color textSecondary = Color(0xFF6B5D52);     // Kahverengi gri
  static const Color dividerColor = Color(0xFFE8E0D5);      // Açık bej çizgi
}

/// Ambians ses seçenekleri (assets/audio/ içinde rain.mp3, fireplace.mp3)
enum LibraryAmbiance { silent, rain, fireplace }

extension LibraryAmbianceExt on LibraryAmbiance {
  String get label {
    switch (this) {
      case LibraryAmbiance.silent: return 'Sessiz';
      case LibraryAmbiance.rain: return 'Yağmur';
      case LibraryAmbiance.fireplace: return 'Şömine';
    }
  }
  String? get assetPath {
    switch (this) {
      case LibraryAmbiance.silent: return null;
      case LibraryAmbiance.rain: return 'audio/rain.mp3';
      case LibraryAmbiance.fireplace: return 'audio/fireplace.mp3';
    }
  }
  IconData get icon {
    switch (this) {
      case LibraryAmbiance.silent: return Icons.volume_off_rounded;
      case LibraryAmbiance.rain: return Icons.water_drop_rounded;
      case LibraryAmbiance.fireplace: return Icons.local_fire_department_rounded;
    }
  }
}

/// "Son X dakika/saat önce aktif" veya "Şu an aktif" metni
String _formatLastActive(DateTime? lastSeen) {
  if (lastSeen == null) return 'Aktiflik bilinmiyor';
  final diff = DateTime.now().difference(lastSeen);
  if (diff.inMinutes < 2) return 'Şu an aktif';
  if (diff.inMinutes < 60) return 'Son ${diff.inMinutes} dk önce aktif';
  if (diff.inHours < 24) return 'Son ${diff.inHours} saat önce aktif';
  return 'Son ${diff.inDays} gün önce aktif';
}

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> with SingleTickerProviderStateMixin {
  final PointsService _pointsService = PointsService();
  final GeminiService _geminiService = GeminiService();
  final AuthService _authService = AuthService();
  final LibraryBuddyService _libraryBuddyService = LibraryBuddyService();
  final LibrarySavedService _librarySavedService = LibrarySavedService();
  final LibraryMessageTemplateService _templateService = LibraryMessageTemplateService();
  final TextEditingController _questionController = TextEditingController();
  final ScrollController _messagesScrollController = ScrollController();

  late TabController _tabController;

  bool _entryChecked = false;
  bool _entryAllowed = false;
  String? _entryError;
  bool _isLoadingAnswer = false;
  String? _lastQuestion;
  String? _lastAnswer;
  bool _savingAnswer = false;
  LibraryBuddyMatch? _selectedMatch; // Seçili arkadaş (Arkadaşın Olacak sekmesi için)
  bool _sendingMessage = false;
  LibraryAmbiance _libraryAmbiance = LibraryAmbiance.silent;
  AudioPlayer? _ambiancePlayer;

  static const List<String> _suggestions = [
    'Cumhuriyet ne zaman ilan edildi?',
    'Mitoz bölünme nedir?',
    'Türev nedir?',
    'Fotosentez denklemi',
    'Osmanlı kuruluş tarihi',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _checkEntry();
    _loadAmbiance();
  }

  @override
  void dispose() {
    _stopAmbiance();
    _ambiancePlayer?.dispose();
    _tabController.dispose();
    _questionController.dispose();
    _messagesScrollController.dispose();
    super.dispose();
  }

  Future<void> _loadAmbiance() async {
    final prefs = await SharedPreferences.getInstance();
    final idx = prefs.getInt(_keyLibraryAmbiance);
    if (idx != null && idx >= 0 && idx < LibraryAmbiance.values.length) {
      setState(() => _libraryAmbiance = LibraryAmbiance.values[idx]);
      if (_entryAllowed) _playAmbiance(LibraryAmbiance.values[idx]);
    }
  }

  Future<void> _setAmbiance(LibraryAmbiance value) async {
    _stopAmbiance();
    setState(() => _libraryAmbiance = value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyLibraryAmbiance, value.index);
    if (_entryAllowed) _playAmbiance(value);
  }

  Future<void> _playAmbiance(LibraryAmbiance value) async {
    if (kIsWeb) return; // Web'de tarayıcı format kısıtı nedeniyle ses devre dışı; sadece mobilde çalışır
    final path = value.assetPath;
    if (path == null) return;
    try {
      _ambiancePlayer ??= AudioPlayer();
      await _ambiancePlayer!.setReleaseMode(ReleaseMode.loop);
      await _ambiancePlayer!.setSource(AssetSource(path));
      await _ambiancePlayer!.resume();
    } on PlatformException catch (_) {
      // Dosya yoksa veya oynatılamazsa sessiz kal
    } catch (_) {
      // Format / codec hatası (örn. web) veya diğer hatalar – sessiz kal
    }
  }

  Future<void> _stopAmbiance() async {
    try {
      await _ambiancePlayer?.stop();
    } catch (_) {}
  }

  Future<void> _checkEntry() async {
    if (_authService.currentUserId == null) {
      setState(() {
        _entryChecked = true;
        _entryAllowed = false;
        _entryError = 'Giriş yapmalısınız.';
      });
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final today = _todayString();
    final lastDate = prefs.getString(_keyLastLibraryEntryDate);

    if (lastDate == today) {
      setState(() {
        _entryChecked = true;
        _entryAllowed = true;
      });
      if (mounted) _playAmbiance(_libraryAmbiance);
      return;
    }

    final hasEnough = await _pointsService.hasEnoughPoints('library_entry');
    if (!hasEnough) {
      setState(() {
        _entryChecked = true;
        _entryAllowed = false;
        _entryError = 'Kütüphaneye girmek için 30 💎 gerekli.';
      });
      return;
    }

    try {
      await _pointsService.spendPoints('library_entry', description: 'Kütüphane girişi');
      await prefs.setString(_keyLastLibraryEntryDate, today);
      if (mounted) {
        setState(() {
          _entryChecked = true;
          _entryAllowed = true;
        });
        _playAmbiance(_libraryAmbiance);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _entryChecked = true;
          _entryAllowed = false;
          _entryError = 'Ödeme işlemi başarısız.';
        });
      }
    }
  }

  String _todayString() {
    final n = DateTime.now();
    return '${n.year}-${n.month.toString().padLeft(2, '0')}-${n.day.toString().padLeft(2, '0')}';
  }

  Future<void> _askQuestion() async {
    final q = _questionController.text.trim();
    if (q.isEmpty) return;
    if (_isLoadingAnswer) return;

    setState(() {
      _isLoadingAnswer = true;
      _lastAnswer = null;
    });

    try {
      final answer = await _geminiService.answerLibraryQuestion(q);
      if (mounted) {
        setState(() {
          _isLoadingAnswer = false;
          _lastQuestion = q;
          _lastAnswer = answer;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingAnswer = false;
          _lastAnswer = 'Yanıt alınamadı. Lütfen tekrar dene.';
        });
      }
    }
  }

  Future<void> _saveCurrentAnswer() async {
    if (_lastQuestion == null || _lastAnswer == null) return;
    if (_savingAnswer) return;
    setState(() => _savingAnswer = true);
    try {
      final ok = await _librarySavedService.saveAnswer(question: _lastQuestion!, answer: _lastAnswer!);
      if (mounted) {
        setState(() => _savingAnswer = false);
        if (ok) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Yanıt kaydedildi.'), behavior: SnackBarBehavior.floating),
          );
          _tabController.animateTo(1);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Kaydedilemedi.'), behavior: SnackBarBehavior.floating),
          );
        }
      }
    } catch (e) {
      if (mounted) setState(() => _savingAnswer = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_entryChecked) {
      return Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text('📚 Kütüphane', style: TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.bold)),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (!_entryAllowed) {
      return Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text('📚 Kütüphane', style: TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.bold)),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lock_outline, size: 64, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text(
                  _entryError ?? 'Kütüphaneye giremezsiniz.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppTheme.textSecondary, fontSize: 16),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Geri'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: LibraryTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('📚 Kütüphane', style: TextStyle(color: LibraryTheme.textPrimary, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: LibraryTheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          // Ambians seçici (Yağmur / Şömine / Sessiz)
          PopupMenuButton<LibraryAmbiance>(
            icon: Icon(_libraryAmbiance.icon, color: LibraryTheme.textPrimary, size: 22),
            tooltip: 'Ambians',
            onSelected: _setAmbiance,
            color: LibraryTheme.surfaceColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            itemBuilder: (context) => LibraryAmbiance.values.map((a) {
              return PopupMenuItem<LibraryAmbiance>(
                value: a,
                child: Row(
                  children: [
                    Icon(a.icon, size: 20, color: LibraryTheme.accentColor),
                    const SizedBox(width: 12),
                    Text(a.label, style: const TextStyle(color: LibraryTheme.textPrimary)),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(width: 8),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: LibraryTheme.accentColor,
          unselectedLabelColor: LibraryTheme.textSecondary,
          indicatorColor: LibraryTheme.accentColor,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Kütüphane'),
            Tab(text: 'Kayıtlı Notlarım'),
            Tab(text: 'Arkadaşın Olacak'),
          ],
        ),
      ),
      body: Stack(
        children: [
          // Lamba / pencere ışığı (sıcak amber gradient)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 180,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    LibraryTheme.accentLight.withOpacity(0.25),
                    LibraryTheme.accentColor.withOpacity(0.08),
                    LibraryTheme.backgroundColor,
                  ],
                ),
              ),
            ),
          ),
          TabBarView(
            controller: _tabController,
            children: [
              _buildKutuphaneTab(),
              _buildKayitliNotlarimTab(),
              _buildArkadasinOlacakTab(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKutuphaneTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '4.–12. sınıf müfredatı + KPSS genel kültür. Sadece eğitim konularında yanıt verilir (en fazla 250 karakter).',
            style: TextStyle(color: LibraryTheme.textSecondary, fontSize: 13, height: 1.4),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _questionController,
            decoration: InputDecoration(
              hintText: 'Sorunuzu yazın...',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: LibraryTheme.surfaceColor,
              suffixIcon: IconButton(
                icon: _isLoadingAnswer
                    ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.send_rounded, color: LibraryTheme.accentColor),
                onPressed: _isLoadingAnswer ? null : _askQuestion,
              ),
            ),
            maxLines: 2,
            onSubmitted: (_) => _askQuestion(),
          ),
          const SizedBox(height: 12),
          const Text('Öneriler:', style: TextStyle(color: LibraryTheme.textPrimary, fontWeight: FontWeight.w600, fontSize: 13)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _suggestions.map((s) => ActionChip(
              label: Text(s, style: const TextStyle(fontSize: 12)),
              onPressed: () {
                _questionController.text = s;
                _askQuestion();
              },
              backgroundColor: LibraryTheme.accentColor.withOpacity(0.1),
              side: BorderSide(color: LibraryTheme.accentColor.withOpacity(0.3)),
            )).toList(),
          ),
          if (_lastAnswer != null) ...[
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: LibraryTheme.accentColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: LibraryTheme.accentColor.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.menu_book_rounded, color: LibraryTheme.accentColor, size: 20),
                      const SizedBox(width: 8),
                      const Text('Yanıt', style: TextStyle(fontWeight: FontWeight.w600, color: LibraryTheme.textPrimary)),
                      const Spacer(),
                      TextButton.icon(
                        onPressed: _savingAnswer ? null : _saveCurrentAnswer,
                        icon: _savingAnswer
                            ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                            : const Icon(Icons.bookmark_add_outlined, size: 18),
                        label: Text(_savingAnswer ? 'Kaydediliyor...' : 'Kaydet'),
                        style: TextButton.styleFrom(foregroundColor: LibraryTheme.accentColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _lastAnswer!,
                    style: const TextStyle(color: LibraryTheme.textSecondary, fontSize: 15, height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildKayitliNotlarimTab() {
    return StreamBuilder<List<LibrarySavedAnswer>>(
      stream: _librarySavedService.getSavedStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final list = snapshot.data ?? [];
        if (list.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bookmark_border_rounded, size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    'Henüz kayıtlı not yok.',
                    style: TextStyle(color: LibraryTheme.textSecondary, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Kütüphane sekmesinde bir soru sorup yanıtı "Kaydet" ile ekleyebilirsin.',
                    style: TextStyle(color: LibraryTheme.textSecondary, fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          itemCount: list.length,
          itemBuilder: (context, index) {
            final item = list[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              color: LibraryTheme.surfaceColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onLongPress: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Notu sil'),
                      content: const Text('Bu kayıtlı notu silmek istiyor musun?'),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('İptal')),
                        TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Sil', style: TextStyle(color: Colors.red))),
                      ],
                    ),
                  );
                  if (confirm == true && mounted) {
                    await _librarySavedService.deleteSaved(item.id);
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Not silindi.'), behavior: SnackBarBehavior.floating),
                      );
                    }
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.help_outline_rounded, size: 18, color: LibraryTheme.accentColor),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              item.question,
                              style: const TextStyle(color: LibraryTheme.textPrimary, fontWeight: FontWeight.w600, fontSize: 14),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item.answer,
                        style: const TextStyle(color: LibraryTheme.textSecondary, fontSize: 14, height: 1.45),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        DateFormat('dd.MM.yyyy HH:mm').format(item.createdAt),
                        style: TextStyle(color: LibraryTheme.textSecondary, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildArkadasinOlacakTab() {
    final userId = _authService.currentUserId;
    if (userId == null) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text('Giriş yapmalısınız.', style: TextStyle(color: LibraryTheme.textSecondary)),
        ),
      );
    }

    return FutureBuilder<LibraryBuddyPoolEntry?>(
      future: _libraryBuddyService.getMyPoolEntry(),
      builder: (context, poolSnapshot) {
        final isInPool = poolSnapshot.data != null;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sol: Mesaj alanı (mesajlar + şablonlar) veya placeholder
            Expanded(
              flex: 2,
              child: _selectedMatch == null
                  ? _buildNoFriendSelected(isInPool)
                  : _buildChatArea(userId),
            ),
            // Sağ: Arkadaş listesi
            SizedBox(
              width: 280,
              child: _buildFriendsColumn(userId, isInPool),
            ),
          ],
        );
      },
    );
  }

  /// Sol taraf: Arkadaş seçilmediğinde placeholder
  Widget _buildNoFriendSelected(bool isInPool) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              isInPool
                  ? 'Sağdaki listeden bir arkadaş seç ve sohbet et.'
                  : 'Önce kriterlerini seç, eşleşen arkadaşları göreceksin.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: LibraryTheme.textSecondary, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }

  /// Sol taraf: Seçili arkadaş var - mesajlar + şablonlar
  Widget _buildChatArea(String myUserId) {
    return Column(
      children: [
        // Üst: Seçili arkadaş bilgisi
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: LibraryTheme.surfaceColor,
            border: Border(bottom: BorderSide(color: LibraryTheme.dividerColor)),
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: LibraryTheme.accentColor.withOpacity(0.2),
                radius: 18,
                child: Text(
                  _selectedMatch!.otherDisplayName(myUserId).isNotEmpty
                      ? _selectedMatch!.otherDisplayName(myUserId)[0].toUpperCase()
                      : '?',
                  style: TextStyle(color: LibraryTheme.accentColor, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _selectedMatch!.otherDisplayName(myUserId),
                      style: const TextStyle(color: LibraryTheme.textPrimary, fontWeight: FontWeight.w600, fontSize: 15),
                    ),
                    Text(
                      _formatLastActive(_selectedMatch!.otherLastSeenAt(myUserId)),
                      style: TextStyle(color: LibraryTheme.accentColor.withOpacity(0.9), fontSize: 11),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: LibraryTheme.textSecondary),
                onPressed: () => setState(() => _selectedMatch = null),
                tooltip: 'Kapat',
              ),
            ],
          ),
        ),
        // Orta: Mesajlar
        Expanded(child: _buildMessagesArea(myUserId)),
        // Alt: Şablonlar
        _buildTemplatesArea(),
      ],
    );
  }

  /// Mesajlar alanı (üst kısım)
  Widget _buildMessagesArea(String myUserId) {
    return StreamBuilder<List<LibraryBuddyMessage>>(
      stream: _libraryBuddyService.getMessagesStream(_selectedMatch!.id),
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
                'Henüz mesaj yok. Aşağıdaki şablonlardan birini seç.',
                textAlign: TextAlign.center,
                style: TextStyle(color: LibraryTheme.textSecondary, fontSize: 14),
              ),
            ),
          );
        }
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_messagesScrollController.hasClients) {
            _messagesScrollController.jumpTo(_messagesScrollController.position.maxScrollExtent);
          }
        });
        return ListView.builder(
          controller: _messagesScrollController,
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
                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.5),
                decoration: BoxDecoration(
                  color: isMe ? LibraryTheme.accentColor.withOpacity(0.15) : LibraryTheme.surfaceColor,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(16),
                    topRight: const Radius.circular(16),
                    bottomLeft: Radius.circular(isMe ? 16 : 4),
                    bottomRight: Radius.circular(isMe ? 4 : 16),
                  ),
                  border: Border.all(color: LibraryTheme.dividerColor.withOpacity(0.5)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      msg.text,
                      style: const TextStyle(color: LibraryTheme.textPrimary, fontSize: 14, height: 1.35),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('HH:mm').format(msg.createdAt),
                      style: TextStyle(color: LibraryTheme.textSecondary, fontSize: 11),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  /// Şablonlar alanı (alt kısım)
  Widget _buildTemplatesArea() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: LibraryTheme.surfaceColor,
        border: Border(top: BorderSide(color: LibraryTheme.dividerColor)),
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
                  label: Text(
                    t.label.length > 25 ? '${t.label.substring(0, 22)}...' : t.label,
                    style: const TextStyle(fontSize: 13),
                  ),
                  onPressed: _sendingMessage ? null : () => _onTemplateTapInline(t),
                  backgroundColor: LibraryTheme.accentColor.withOpacity(0.1),
                  side: BorderSide(color: LibraryTheme.accentColor.withOpacity(0.3)),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }

  /// Şablon tıklandığında mesaj gönder (inline, chat screen gibi)
  void _onTemplateTapInline(LibraryMessageTemplate template) async {
    if (_selectedMatch == null) return;
    if (template.type == 'number_choice' && template.numberOptions != null && template.numberOptions!.isNotEmpty) {
      final value = await showDialog<int>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(template.label),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: template.numberOptions!
                .map((n) => ListTile(
                      title: Text('$n'),
                      onTap: () => Navigator.pop(ctx, n),
                    ))
                .toList(),
          ),
        ),
      );
      if (value != null && mounted) {
        _sendMessageInline(template.buildText(value));
      }
    } else {
      _sendMessageInline(template.buildText());
    }
  }

  Future<void> _sendMessageInline(String text) async {
    if (_selectedMatch == null || text.isEmpty || _sendingMessage) return;
    setState(() => _sendingMessage = true);
    try {
      // Eski mesajları temizle, mesaj gönder
      await _libraryBuddyService.deleteMessagesOlderThan(_selectedMatch!.id);
      final ok = await _libraryBuddyService.sendMessage(_selectedMatch!.id, text);
      if (mounted) {
        setState(() => _sendingMessage = false);
        if (!ok) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gönderilemedi.'), behavior: SnackBarBehavior.floating),
          );
        }
      }
    } catch (_) {
      if (mounted) setState(() => _sendingMessage = false);
    }
  }

  /// Sağ: Arkadaş listesi kolonu
  Widget _buildFriendsColumn(String userId, bool isInPool) {
    return Container(
      decoration: BoxDecoration(
        color: LibraryTheme.surfaceColor,
        border: Border(left: BorderSide(color: LibraryTheme.dividerColor)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Üst: Kriterlerimi Seç butonu (sadece havuzda değilse)
          if (!isInPool)
            Padding(
              padding: const EdgeInsets.all(12),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LibraryBuddyFormScreen()),
                    );
                    setState(() {}); // Kriter seçildikten sonra refresh için
                  },
                  icon: const Icon(Icons.tune, size: 18),
                  label: const Text('Kriterlerimi Seç', style: TextStyle(fontSize: 13)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: LibraryTheme.accentColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ),
          // Başlık
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
            child: Text(
              'Eşleşen Arkadaşlar',
              style: TextStyle(color: LibraryTheme.textPrimary, fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ),
          const Divider(height: 1),
          // Liste
          Expanded(
            child: StreamBuilder<List<LibraryBuddyMatch>>(
              stream: _libraryBuddyService.getMyMatchesStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2)));
                }
                final list = snapshot.data ?? [];
                if (list.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      isInPool
                          ? 'Henüz eşleşme yok. Eşleşince burada görünecek.'
                          : 'Kriterlerini seç, eşleşme bul.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: LibraryTheme.textSecondary, fontSize: 12),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final m = list[index];
                    final otherName = m.otherDisplayName(userId);
                    final lastActive = _formatLastActive(m.otherLastSeenAt(userId));
                    final isSelected = _selectedMatch?.id == m.id;
                    return ListTile(
                      selected: isSelected,
                      selectedTileColor: LibraryTheme.accentColor.withOpacity(0.1),
                      leading: CircleAvatar(
                        backgroundColor: LibraryTheme.accentColor.withOpacity(0.2),
                        radius: 18,
                        child: Text(
                          otherName.isNotEmpty ? otherName[0].toUpperCase() : '?',
                          style: TextStyle(color: LibraryTheme.accentColor, fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ),
                      title: Text(
                        otherName,
                        style: const TextStyle(color: LibraryTheme.textPrimary, fontWeight: FontWeight.w600, fontSize: 13),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            m.criteria.join(", "),
                            style: TextStyle(color: LibraryTheme.textSecondary, fontSize: 11),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            lastActive,
                            style: TextStyle(color: LibraryTheme.accentColor.withOpacity(0.9), fontSize: 10),
                          ),
                        ],
                      ),
                      onTap: () async {
                        setState(() => _selectedMatch = m);
                        // Açılışta cleanup + lastSeen güncelle
                        await _libraryBuddyService.deleteMessagesOlderThan(m.id);
                        await _libraryBuddyService.updateMatchLastSeen(m.id);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
