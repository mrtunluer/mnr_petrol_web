# Deploy Rehberi — MNR Petrol

Next.js 15 App Router projesi **statik HTML olarak export ediliyor** (`output: 'export'`). Üretilen `out/` klasörü herhangi bir shared hosting (Hostinger / GoDaddy) üzerinde native PHP gibi çalışır. Node.js, API, database gerekmez.

---

## 1. Projeyi Derle ve Paketle

```bash
# Node 20 veya 22 gerekli (nvm use 22)
npm install
npm run optimize-images   # bir kerelik — assets/images/* → public/*.webp
npm run build             # out/ klasörünü üretir
npm run package           # dist/mnr-petrol-site.zip hazırlar
```

Sonunda:
- `out/` = deploy edilebilir statik site (~15 MB)
- `dist/mnr-petrol-site.zip` = tek dosya, File Manager'a upload için

İçeride olanlar:
- `index.html`, `hakkimizda/index.html`, `urunler/index.html` — her sayfa prerender edilmiş
- `urun/<product-id>/index.html` — 51 ürün sayfası
- `_next/static/*` — hashed JS/CSS (1 yıl cache)
- `products/`, `brands/`, `categories/`, `hero/` — WebP görseller
- `sitemap.xml`, `robots.txt`, `manifest.webmanifest`, `favicon.png`
- `.htaccess` — HTTPS yönlendirmesi, gzip, cache header'ları, güvenlik

---

## 2. Hostinger (Shared hosting — Premium / Business / Cloud)

### 2.1 Domain'i bağla (ilk kez)

1. Hostinger hPanel → **Domains** → "Add domain" → mnrpetrol.com
2. Eğer domain başka bir register'da (GoDaddy vb.) kayıtlıysa, Hostinger'ın verdiği **2 adet nameserver**'ı ($alt: ns1.dns-parking.com, ns2.dns-parking.com) domain sağlayıcıda "Nameservers" alanına yaz. Yayılma 1–24 saat.

### 2.2 Dosyaları yükle

**Yöntem A — File Manager (en kolay):**
1. hPanel → **Files → File Manager**
2. `public_html/` klasörüne gir
3. Eski Flutter build varsa tümünü sil (sağ tık → Delete)
4. `dist/mnr-petrol-site.zip`'i sürükle-bırak ile upload et
5. Yüklenen zip'e sağ tık → **Extract** → `public_html/` içine çıkar
6. Zip dosyasını sil

**Yöntem B — Git otomatik deploy (Business+ planı varsa):**
1. hPanel → **Advanced → Git** → Create repository
2. GitHub URL + ana branch (main veya nextjs-rewrite)
3. Build komutu: `npm run build`
4. Publish directory: `out`
5. Her push sonrası otomatik deploy

**Yöntem C — FTP (klasik):**
1. hPanel → **Files → FTP Accounts** → şifreyi not al
2. FileZilla ile `ftp.mnrpetrol.com` host'una bağlan
3. `public_html/` klasörüne `out/` içeriğini (dotfiles dahil, `.htaccess` önemli!) upload et
4. FileZilla Transfer ayarlarında "Force showing hidden files" açık olmalı

### 2.3 SSL

1. hPanel → **Security → SSL**
2. `mnrpetrol.com` ve `www.mnrpetrol.com` için "Install SSL" (Let's Encrypt, ücretsiz)
3. "Force HTTPS" seçeneğini aç (.htaccess zaten zorluyor ama panel flag'i de ekstra garanti)

### 2.4 Hızlı doğrulama

- https://mnrpetrol.com/ → Ana sayfa açılıyor mu?
- https://mnrpetrol.com/urunler/ → Ürün listesi (trailing slash önemli)
- https://mnrpetrol.com/urun/borax-full-synthetic-molygen-green-0w30/ → Bir ürün detayı
- https://mnrpetrol.com/sitemap.xml → XML dönüyor mu?
- Google PageSpeed Insights: mobilde 90+ olmalı

---

## 3. GoDaddy (Shared / cPanel)

GoDaddy shared hosting Node.js DESTEKLEMEZ ama bu proje statik export olduğu için sorun yok.

### 3.1 Domain + Hosting

1. GoDaddy hesabına gir → **My Products**
2. Domain ve Web Hosting aynı hesapta bağlı olmalı. Değilse: domain'in nameservers'ı GoDaddy hosting'e yönlendiril.
3. **Web Hosting → cPanel**'e tıkla

### 3.2 Dosyaları yükle

1. cPanel → **File Manager**
2. `public_html/` klasörüne gir
3. Eskiyse temizle
4. Sağ üstte **Upload** → `dist/mnr-petrol-site.zip`
5. Upload bitince File Manager'a dön → zip'e sağ tık → **Extract**
6. "Extract here" onayla → zip dosyasını sil

### 3.3 SSL (Let's Encrypt)

1. cPanel → **SSL/TLS Status** veya **AutoSSL**
2. `mnrpetrol.com` yanındaki "Run AutoSSL" butonuna tıkla
3. 5 dakika sonra yeşil kilit görünmelidir

### 3.4 `.htaccess` kontrolü

File Manager → sağ üst "Settings" → "Show hidden files" aç → `.htaccess` görünür olmalı. Yoksa `out/.htaccess` dosyasını ayrıca yükle. GoDaddy mod_rewrite, mod_deflate, mod_expires destekler.

### 3.5 Test

Hostinger'dakiyle aynı URL'leri dene.

---

## 4. Ortak Konular

### 4.1 E-posta Adresi — ÖNEMLİ

İletişim formu `src/lib/form-endpoint.ts` içindeki FormSubmit.co endpoint'ine POST yapıyor:

```ts
export const FORM_ENDPOINT = "https://formsubmit.co/ajax/ugurunluer@gmail.com";
```

**İlk form gönderimi öncesi zorunlu adım**: FormSubmit.co mail onayı. İlk POST yapıldığında FormSubmit `ugurunluer@gmail.com` adresine aktivasyon maili gönderir. Linke tıklandıktan sonra gerçek mesajlar iletilir.

Başka bir adrese yönlendirmek istenirse sadece bu dosyayı değiştir + yeniden build + yeniden upload.

### 4.2 Sonraki güncellemeler

Kod ya da ürün listesi değiştiğinde:

```bash
npm run build
npm run package
```

Sonra `public_html/` içeriğini sil → yeni `mnr-petrol-site.zip`'i upload + extract. 5 dakikalık işlem.

Alternatif: `out/` klasöründeki değişen dosyaları FileZilla ile upload et (sadece diff).

### 4.3 Cache temizleme

Güncellemelerin hemen görünmesi için:
- Tarayıcı: Ctrl+Shift+R (hard reload)
- CloudFlare kullanılıyorsa: Dashboard → Caching → Purge Everything
- Hostinger CDN: hPanel → Advanced → Cache Manager → Clear

### 4.4 Site haritası

`https://mnrpetrol.com/sitemap.xml` otomatik 51 ürün + 4 ana sayfa + tüm kategori/marka filter URL'lerini listeler. Google Search Console'a submit edilmeli:
1. https://search.google.com/search-console → Property ekle
2. Sitemaps → "sitemap.xml" ekle → Submit

### 4.5 Google Analytics / Tag Manager

`app/layout.tsx` içine GA4 snippet eklenebilir (şu anda yok). Eklenmek istenirse müşteri GA4 ID'si gerekli.

---

## 5. Sorun giderme

| Belirti | Muhtemel sebep | Çözüm |
|---|---|---|
| 404 Not Found tüm sayfalarda | `.htaccess` yok | File Manager'da hidden files'ı aç, `.htaccess` dosyasını `out/`'tan upload et |
| CSS/JS yüklenmiyor | Path problemi | Root'u `public_html/` olduğundan emin ol (alt dizin olmamalı) |
| İletişim formu "Bağlantı hatası" | FormSubmit onayı yapılmamış | ugurunluer@gmail.com'a gelen FormSubmit activation linkine tıkla |
| Resimler kırık | WebP MIME type tanımsız | `.htaccess` içindeki `AddType image/webp .webp` satırı çalışmalı (yeni Apache sürümleri zaten destekler) |
| SSL kırmızı kilit | Let's Encrypt henüz yayılmamış | 15 dakika bekle + hard reload |

---

## 6. Önerilen hosting planları (Nisan 2026)

| Plan | Uygun mu | Aylık (promo) | Neden |
|---|---|---|---|
| **Hostinger Premium** | ✅ Evet (statik site) | $2.99 | 100 GB, 1 site, NVMe SSD, yeterli |
| **Hostinger Business** | ✅ Evet (tavsiye) | $3.99 | Daily backup, CDN, daha hızlı |
| **Hostinger Cloud Startup** | ✅ Evet (büyük trafik) | $7.99 | 4 CPU, 4 GB RAM |
| **GoDaddy Economy** | ⚠️ Çalışır ama yavaş | $5.99 | Shared, kaynak limitli |
| **GoDaddy Deluxe** | ✅ Evet | $7.99 | Unlimited sites, güvenilir |
| **GoDaddy Ultimate** | ✅ Evet | $12.99 | Bu proje için gereksiz over-kill |

Şimdilik **Hostinger Business** fiyat/performans olarak en mantıklı. GoDaddy'de zaten domain varsa Deluxe yeterli.

---

## 7. Kontrol listesi (ilk deploy için)

- [ ] `npm install` hatasız
- [ ] `npm run optimize-images` çalıştı, `public/products/` doldu
- [ ] `npm run build` hatasız, `out/` üretildi
- [ ] `npm run package` → `dist/mnr-petrol-site.zip` oluştu
- [ ] Hosting'e zip upload + extract
- [ ] `.htaccess` görünür ve aktif
- [ ] https:// ile anasayfa açılıyor
- [ ] `/urunler/` açılıyor (trailing slash)
- [ ] Rastgele bir ürün detay sayfası açılıyor
- [ ] İletişim formu gönderiliyor (FormSubmit onayı sonrası gerçek mail geliyor)
- [ ] Mobil görünüm sorunsuz
- [ ] Sitemap `/sitemap.xml` erişilebilir
- [ ] Google Search Console'a domain eklendi
