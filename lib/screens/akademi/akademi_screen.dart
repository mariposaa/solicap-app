/// Akademi - Yüksek Lisans Anket Modülü
/// Anket oluştur, doldur, takip et

import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'akademi_tabs/survey_create_tab.dart';
import 'akademi_tabs/survey_fill_tab.dart';
import 'akademi_tabs/my_surveys_tab.dart';

class AkademiScreen extends StatefulWidget {
  final int initialTabIndex;

  const AkademiScreen({super.key, this.initialTabIndex = 0});

  @override
  State<AkademiScreen> createState() => _AkademiScreenState();
}

class _AkademiScreenState extends State<AkademiScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialTabIndex.clamp(0, 2);
    _tabController = TabController(length: 3, vsync: this, initialIndex: initial);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('🎓 Akademi'),
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.primaryColor,
          labelColor: AppTheme.primaryColor,
          unselectedLabelColor: AppTheme.textMuted,
          tabs: const [
            Tab(icon: Icon(Icons.add_circle_outline), text: 'Oluştur'),
            Tab(icon: Icon(Icons.assignment_outlined), text: 'Doldur'),
            Tab(icon: Icon(Icons.list_alt), text: 'Anketlerim'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          SurveyCreateTab(),
          SurveyFillTab(),
          MySurveysTab(),
        ],
      ),
    );
  }
}
