# TAG Kocaeli – geliştirme kurulumu

Bu dal, uygulamanın Türkiye/Kocaeli uyarlamasının güvenli başlangıç sürümüdür.

## Gerekli servisler

1. Yeni bir Firebase projesi oluşturun.
2. Yolcu, sürücü ve yönetim panelini ayrı Firebase uygulamaları olarak ekleyin.
3. Eski projedeki `google-services.json` ve Firebase yapılandırmalarını kullanmayın.
4. Bildirim ve Stripe gizli anahtarlarını yalnızca Cloud Functions üzerinde saklayın.
5. Harita ve rota için OpenStreetMap, Nominatim ve OSRM geliştirme servisleri kullanılır.

## Çalıştırma değişkenleri

```bash
flutter run \
  --dart-define=STRIPE_PUBLISHABLE_KEY=... \
  --dart-define=BACKEND_BASE_URL=https://...cloudfunctions.net
```

## Firebase App Check

Yolcu ve sürücü uygulamalarında App Check istemci desteği hazırdır. Debug
derlemelerinde Debug Provider, yayın derlemelerinde Android Play Integrity
kullanılır.

1. Firebase Console > **App Check** bölümünü açın.
2. `com.kocaelitag.yolcu` ve `com.kocaelitag.surucu` uygulamalarını Play
   Integrity ile kaydedin.
3. Geliştirme cihazının logunda görünen debug tokenını App Check içindeki
   **Manage debug tokens** alanına ekleyin.
4. İstek metrikleri düzgün görünmeden **Enforce** seçeneğini açmayın.
5. Gerçek cihaz testleri tamamlandıktan sonra önce Realtime Database, ardından
   diğer Firebase servisleri için zorunlu kılmayı etkinleştirin.

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
- Firebase App Check zorunlu kılma ve Cloud Functions dağıtımı
- Android uygulama kimliklerini ve mağaza imzalarını değiştirmek
