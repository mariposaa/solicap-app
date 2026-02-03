/// SOLICAP - Hizmet Şartları / Gizlilik Politikası ekranı
/// iOS uygulama mağazası gereksinimi için

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class LegalContentScreen extends StatelessWidget {
  final String title;
  final String content;

  const LegalContentScreen({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(title, style: const TextStyle(color: AppTheme.textPrimary)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: SelectableText(
            content,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ),
      ),
    );
  }
}

/// Hizmet Şartları metni (SOLICAP - AI destekli öğrenci asistanı)
String get termsOfServiceContent => '''
HİZMET ŞARTLARI

Son güncelleme: Şubat 2025

1. KAPSAM
Bu Hizmet Şartları, SOLICAP mobil uygulamasının ("Uygulama") kullanımına ilişkindir. Uygulamayı indirerek veya kullanarak bu şartları kabul etmiş sayılırsınız.

2. HİZMETİN TANIMI
SOLICAP, eğitim amaçlı bir mobil uygulamadır. Kullanıcılara soru çözme, konu anlatımı, tekrar planlama ve benzeri eğitim destek hizmetleri sunar. Hizmetler yapay zeka destekli olabilir ve sürekli iyileştirilebilir.

3. KULLANIM KOŞULLARI
• Uygulama yalnızca yasal ve eğitim amaçlı kullanılmalıdır.
• Kullanıcı, verdiği bilgilerin doğru ve güncel olmasından sorumludur.
• Hizmetin kötüye kullanımı, yetkisiz erişim veya otomatik sistemlerle toplu işlem yapılması yasaktır.
• Reşit olmayan kullanıcıların uygulamayı veli veya vasi bilgisi dahilinde kullanması önerilir.

4. FİKRİ MÜLKİYET
Uygulama, içerik ve markalar SOLICAP'a aittir. İzinsiz kopyalama, dağıtma veya ticari kullanım yasaktır.

5. SINIRLAMA
Uygulama "olduğu gibi" sunulmaktadır. Eğitim amaçlı yardım sağlanır; ancak sonuçların doğruluğu veya sınav başarısı garanti edilmez. Yasal sorumluluk mümkün olduğunca yasalarla sınırlıdır.

6. FESİH
Bu şartları ihlal eden kullanıcıların erişimi önceden bildirim yapılmaksızın sonlandırılabilir.

7. DEĞİŞİKLİKLER
Hizmet Şartları güncellenebilir. Önemli değişiklikler uygulama içinde duyurulacaktır. Kullanıma devam etmek güncel şartları kabul anlamına gelir.

8. İLETİŞİM
Sorularınız için uygulama içi geri bildirim veya destek kanallarını kullanabilirsiniz.
''';

/// Gizlilik Politikası metni
String get privacyPolicyContent => '''
GİZLİLİK POLİTİKASI

Son güncelleme: Şubat 2025

1. TOPLANAN BİLGİLER
SOLICAP aşağıdaki türde bilgileri toplayabilir:
• Hesap bilgileri: Cihaz tanımlayıcı, oluşturduğunuz kullanıcı adı ve profil bilgileri (sınıf, hedef sınav, öğrenme stili vb.).
• Kullanım verileri: Çözülen sorular, başarı oranları, uygulama içi tercihler.
• Teknik veriler: Cihaz türü, işletim sistemi, uygulama sürümü (hata giderme ve iyileştirme için).

2. BİLGİLERİN KULLANIMI
• Hizmeti kişiselleştirmek ve geliştirmek.
• Soru çözümü, konu anlatımı ve tekrar önerileri sunmak.
• Liderlik tablosu, yarışmalar ve ödüllerle ilgili işlemleri yürütmek.
• Yasal yükümlülükler ve güvenlik amacıyla (kullanım politikalarına uyum).

3. VERİ GÜVENLİĞİ
Verileriniz şifreli bağlantılar ve güvenli altyapı (Firebase vb.) kullanılarak işlenir. Yetkisiz erişime karşı önlemler alınmaktadır.

4. ÜÇÜNCÜ TARAF PAYLAŞIMI
• Analitik ve hata takibi için anonim/agrege veriler kullanılabilir.
• Reklam ortakları (ör. reklam izleme ödülleri) kendi gizlilik politikalarına tabidir.
• Yasal zorunluluk dışında kişisel verileriniz üçüncü taraflara satılmaz.

5. SAKLAMA SÜRESİ
Hesabınız aktif olduğu sürece veriler saklanır. Hesap silme talebinde ilgili kişisel veriler silinir veya anonimleştirilir; yasal saklama zorunlulukları saklıdır.

6. HAKLARINIZ
• Verilerinize erişim, düzeltme ve silme talebinde bulunabilirsiniz.
• Uygulama içinden "Hesabımı Sil" ile hesabınızı silebilirsiniz.
• KVKK kapsamında başvurularınızı iletebilirsiniz.

7. ÇOCUKLARIN GİZLİLİĞİ
Uygulama eğitim amaçlıdır. Reşit olmayan kullanıcılar için veli/vasi farkındalığı önerilir; gerekirse ebeveyn onayı ile kullanım desteklenir.

8. DEĞİŞİKLİKLER
Bu politika güncellenebilir. Önemli değişiklikler uygulama içinde veya e-posta ile duyurulacaktır.

9. İLETİŞİM
Gizlilik ile ilgili talepleriniz için uygulama içi destek veya iletişim kanallarını kullanabilirsiniz.
''';
