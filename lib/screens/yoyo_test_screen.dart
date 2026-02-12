/// SOLICAP - YoYo Test Ders Seçim Ekranı
/// Öğrenci TYT/AYT seçer, ders seçer ve hız antrenmanına başlar

import 'package:flutter/material.dart';
import '../data/yoyo_test_data.dart';
import '../data/yoyo_ayt_data.dart';
import '../models/yoyo_test_models.dart';
import '../services/points_service.dart';
import 'yoyo_test_battle_screen.dart';

class YoYoTestScreen extends StatefulWidget {
  const YoYoTestScreen({super.key});

  @override
  State<YoYoTestScreen> createState() => _YoYoTestScreenState();
}

class _YoYoTestScreenState extends State<YoYoTestScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabCtrl;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
    _tabCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  /// 💎 Elmas kontrolü yapıp sınava başlat
  Future<void> _startTest(BuildContext context, YoYoSubject subject) async {
    final pointsService = PointsService();
    final success = await pointsService.checkAndSpendPoints(
      context,
      'yoyo_test',
      description: 'YoYo Test - ${subject.name}',
    );

    if (!success) return; // Yetersiz elmas veya iptal

    if (!context.mounted) return;
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => YoYoTestBattleScreen(subject: subject),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.9, end: 1.0).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              ),
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  /// Seçili tab'e göre ders listesini döndür
  List<YoYoSubject> get _currentSubjects =>
      _tabCtrl.index == 0 ? yoyoSubjects : yoyoAytSubjects;

  /// Seçili tab'e göre açıklamaları döndür
  List<String> get _currentDescriptions => _tabCtrl.index == 0
      ? const [
          'Temel Kavramlar • Geometri • Fonksiyonlar • Olasılık',
          'Fizik • Kimya • Biyoloji • Ekosistem',
          'Sözcükte Anlam • Dil Bilgisi • Paragraf • Yazım',
          'Tarih • Coğrafya • Vatandaşlık • Anayasa',
        ]
      : const [
          'Türev • İntegral • Limit • Karmaşık Sayılar',
          'Fizik • Kimya • Biyoloji (AYT düzey)',
          'Divan • Halk • Tanzimat • Cumhuriyet Edebiyatı',
          'Tarih • Coğrafya • Felsefe',
        ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      body: Stack(
        children: [
          // Arka plan
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF0A0E21),
                  Color(0xFF1A1A2E),
                  Color(0xFF0F3460),
                ],
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Geri butonu
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.arrow_back, color: Colors.white, size: 22),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Başlık
                  const Text('🏃', style: TextStyle(fontSize: 50)),
                  const SizedBox(height: 12),
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Color(0xFF00E5FF), Color(0xFF00B0FF), Color(0xFF00E5FF)],
                    ).createShader(bounds),
                    child: const Text(
                      'YOYO TEST',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Hız Antrenmanı - Sınava karşı refleks kazan!',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 13,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 24),

                  // ─── TYT / AYT Tab Bar ───
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.cyanAccent.withOpacity(0.15)),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: TabBar(
                      controller: _tabCtrl,
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF00B0FF), Color(0xFF00E5FF)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.cyanAccent.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Colors.transparent,
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.white54,
                      labelStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                      unselectedLabelStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 2,
                      ),
                      tabs: const [
                        Tab(text: 'TYT'),
                        Tab(text: 'AYT'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 22),

                  // Nasıl çalışır kutusu
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.cyanAccent.withOpacity(0.2)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text('📋', style: TextStyle(fontSize: 18)),
                            const SizedBox(width: 8),
                            Text(
                              'Nasıl Çalışır?',
                              style: TextStyle(
                                color: Colors.cyanAccent.withOpacity(0.9),
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        _buildInfoRow('🎯', '7 seviye, her seviyede 6 soru (2 kolay, 2 orta, 2 zor)'),
                        _buildInfoRow('⏱️', 'Süre: 7dk → 6.5dk → ... → 4dk (her seviyede daralır)'),
                        _buildInfoRow('🎲', 'Sorular her seferinde rastgele gelir'),
                        _buildInfoRow('💀', '3 yanlış = Elenirsin! Baştan başla.'),
                        _buildInfoRow('❌', 'Süre dolunca da elenirsin!'),
                        _buildInfoRow('💎', 'Giriş: 10 elmas | Seviye ödülü: 3 elmas + 5 puan'),
                        _buildInfoRow('📊', 'Sonunda performans analizi'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Ders seçim başlığı
                  Row(
                    children: [
                      Container(
                        width: 4,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.cyanAccent,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${_tabCtrl.index == 0 ? 'TYT' : 'AYT'} DERS SEÇ',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Ders kartları
                  ...List.generate(_currentSubjects.length, (i) {
                    return _buildSubjectCard(context, _currentSubjects[i], i);
                  }),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String emoji, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectCard(BuildContext context, YoYoSubject subject, int index) {
    final gradients = [
      const [Color(0xFF0D47A1), Color(0xFF1565C0)], // Matematik
      const [Color(0xFF1B5E20), Color(0xFF2E7D32)], // Fen
      const [Color(0xFFBF360C), Color(0xFFE64A19)], // Türkçe / Edebiyat
      const [Color(0xFF4A148C), Color(0xFF7B1FA2)], // Sosyal
    ];
    final glows = [
      Colors.blueAccent,
      Colors.greenAccent,
      Colors.deepOrangeAccent,
      Colors.purpleAccent,
    ];
    final descriptions = _currentDescriptions;
    const topicCount = '20 kolay • 20 orta • 20 zor';

    return GestureDetector(
      onTap: () => _startTest(context, subject),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradients[index % gradients.length],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: glows[index % glows.length].withOpacity(0.25),
              blurRadius: 18,
              offset: const Offset(0, 5),
            ),
          ],
          border: Border.all(color: glows[index % glows.length].withOpacity(0.3)),
        ),
        child: Row(
          children: [
            // Emoji
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Text(
                  subject.emoji,
                  style: const TextStyle(fontSize: 28),
                ),
              ),
            ),
            const SizedBox(width: 14),

            // Ders bilgisi
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subject.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    descriptions[index % descriptions.length],
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    topicCount,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),

            // Başla butonu + elmas
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: glows[index % glows.length].withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: glows[index % glows.length].withOpacity(0.5)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.play_arrow_rounded, color: Colors.white, size: 18),
                      SizedBox(width: 2),
                      Text(
                        'BAŞLA',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.diamond, color: Colors.amber.withOpacity(0.8), size: 12),
                    const SizedBox(width: 2),
                    Text(
                      '10',
                      style: TextStyle(
                        color: Colors.amber.withOpacity(0.8),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
