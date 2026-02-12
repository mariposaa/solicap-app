/// SOLICAP - Math RPG Yaş Grubu Seçim Ekranı
/// Oyuncu yaş grubunu seçer ve savaşa girer

import 'package:flutter/material.dart';
import '../data/math_rpg_data.dart';
import '../models/math_rpg_models.dart';
import 'math_rpg_battle_screen.dart';

class MathRPGScreen extends StatelessWidget {
  const MathRPGScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      body: Stack(
        children: [
          // Arka plan gradyan
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF0D0D1A),
                  Color(0xFF1A1A2E),
                  Color(0xFF16213E),
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
                  const Text(
                    '⚔️',
                    style: TextStyle(fontSize: 50),
                  ),
                  const SizedBox(height: 12),
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Color(0xFFFFD700), Color(0xFFFF8C00), Color(0xFFFFD700)],
                    ).createShader(bounds),
                    child: const Text(
                      'MATH RPG',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Canavarları yen, matematik öğren!',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 36),

                  // Seviye başlığı
                  Row(
                    children: [
                      Container(
                        width: 4,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'SEVİYE SEÇ',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Yaş grubu kartları
                  _buildLevelCard(
                    context: context,
                    level: mathRPGLevels[0],
                    description: 'Toplama • Çıkarma • Çarpma • Bölme',
                    gradientColors: const [Color(0xFF1B5E20), Color(0xFF388E3C)],
                    glowColor: Colors.greenAccent,
                    monsterPreview: '🟢 🦇 🕷️ 👺 💀 👹',
                    difficultyStars: 1,
                  ),
                  _buildLevelCard(
                    context: context,
                    level: mathRPGLevels[1],
                    description: 'Kesirler • Yüzdeler • Denklemler • Geometri',
                    gradientColors: const [Color(0xFF1A237E), Color(0xFF283593)],
                    glowColor: Colors.blueAccent,
                    monsterPreview: '🧟 🐺 🤕 👻 🗿 🐉',
                    difficultyStars: 3,
                  ),
                  _buildLevelCard(
                    context: context,
                    level: mathRPGLevels[2],
                    description: 'Fonksiyonlar • Trigonometri • Logaritma • Türev',
                    gradientColors: const [Color(0xFF4A148C), Color(0xFF6A1B9A)],
                    glowColor: Colors.purpleAccent,
                    monsterPreview: '👤 🔥 🥶 ⚔️ 🧙‍♂️ 👿',
                    difficultyStars: 5,
                  ),

                  const SizedBox(height: 24),

                  // Bilgi kutusu
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: Row(
                      children: [
                        const Text('💡', style: TextStyle(fontSize: 20)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Soruları hızlı çöz → Kritik vuruş!\nKombo yap → Ekstra hasar!',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 12,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelCard({
    required BuildContext context,
    required MathRPGLevel level,
    required String description,
    required List<Color> gradientColors,
    required Color glowColor,
    required String monsterPreview,
    required int difficultyStars,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => MathRPGBattleScreen(level: level),
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
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: glowColor.withOpacity(0.25),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
          border: Border.all(color: glowColor.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Üst satır: seviye adı + yaş + zorluk
            Row(
              children: [
                // Seviye adı
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        level.levelName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${level.ageGroup} yaş',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Zorluk yıldızları
                Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(5, (i) {
                        return Icon(
                          i < difficultyStars ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 16,
                        );
                      }),
                    ),
                    const SizedBox(height: 6),
                    // Oyna butonu
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: glowColor.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: glowColor.withOpacity(0.5)),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.play_arrow_rounded, color: Colors.white, size: 18),
                          SizedBox(width: 4),
                          Text(
                            'OYNA',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Açıklama
            Text(
              description,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 12,
              ),
            ),

            const SizedBox(height: 12),

            // Canavar önizleme
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Text(
                    '👾',
                    style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.5)),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      monsterPreview,
                      style: const TextStyle(fontSize: 16, letterSpacing: 2),
                    ),
                  ),
                  Text(
                    '${level.monsters.length} canavar',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.4),
                      fontSize: 10,
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
