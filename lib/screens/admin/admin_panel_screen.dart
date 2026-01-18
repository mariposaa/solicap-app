import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/admin_service.dart';
import 'admin_feedback_screen.dart';
import 'admin_feature_cards_screen.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('🔐 Admin Paneli'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await AdminService.logout();
              if (mounted) Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatGrid(),
            const SizedBox(height: 24),
            _buildAdminAction(
              icon: Icons.tips_and_updates,
              title: 'Bilgilendirme Kartları',
              subtitle: 'Ana sayfa carousel kartlarını düzenle',
              color: Colors.indigo,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AdminFeatureCardsScreen()),
                );
              },
            ),
            const SizedBox(height: 12),
            _buildAdminAction(
              icon: Icons.quiz,
              title: 'Soru Havuzu',
              subtitle: 'Soruları kontrol et',
              color: Colors.orange,
              onTap: () {
                // TODO: Implement
              },
            ),
            const SizedBox(height: 12),
            _buildAdminAction(
              icon: Icons.psychology,
              title: 'AI Prompt Ayarları',
              subtitle: 'Gemini promptlarını güncelle',
              color: Colors.purple,
              onTap: () {
                // TODO: Implement
              },
            ),
            const SizedBox(height: 12),
            _buildAdminAction(
              icon: Icons.message_outlined,
              title: 'Geri Bildirimler',
              subtitle: 'Kullanıcı istek ve önerileri',
              color: Colors.teal,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AdminFeedbackScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatGrid() {
    return Row(
      children: [
        _buildStatCard('Aktif Kullanıcı', '1.2K', Icons.people, Colors.blue),
        const SizedBox(width: 12),
        _buildStatCard('Bugünkü Sorular', '450', Icons.check_circle, Colors.green),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.dividerColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 12),
            Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(label, style: const TextStyle(color: AppTheme.textMuted, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminAction({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.dividerColor),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(subtitle, style: const TextStyle(color: AppTheme.textMuted, fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppTheme.textMuted),
          ],
        ),
      ),
    );
  }
}
