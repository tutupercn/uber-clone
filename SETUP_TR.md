# TAG Kocaeli – geliştirme kurulumu

Bu dal, uygulamanın Türkiye/Kocaeli uyarlamasının güvenli başlangıç sürümüdür.

## Gerekli servisler

1. Yeni bir Firebase projesi oluşturun.
2. Yolcu, sürücü ve yönetim panelini ayrı Firebase uygulamaları olarak ekleyin.
3. Eski projedeki `google-services.json` ve Firebase yapılandırmalarını kullanmayın.
4. Google Maps API anahtarını Android/iOS uygulama kimlikleriyle sınırlandırın.
5. Bildirim ve Stripe gizli anahtarlarını yalnızca Cloud Functions üzerinde saklayın.

## Çalıştırma değişkenleri

```bash
flutter run \
  --dart-define=GOOGLE_MAPS_API_KEY=... \
  --dart-define=STRIPE_PUBLISHABLE_KEY=... \
  --dart-define=BACKEND_BASE_URL=https://...cloudfunctions.net
```

## İlk sürüm kapsamı

- Yolcu ve sürücü için Türkiye (+90) varsayılanı
- Çayırova merkezli başlangıç haritası
- TAG Kocaeli marka yapılandırması
- Bildirim ve ödeme işlemlerinin güvenli sunucu uçlarına taşınması
- Yönetim paneli için yeni renk ve başlık

## Sıradaki işler

- Yeni Firebase yapılandırmalarını bağlamak
- Tüm ekranları Türkçeleştirmek
- T.C. kimlik, ehliyet ve ruhsat doğrulama alanları
- Teklif, karşı teklif ve komisyon akışını test etmek
- Firebase güvenlik kuralları ve Cloud Functions
- Android uygulama kimliklerini ve mağaza imzalarını değiştirmek
