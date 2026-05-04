# Navbar Mobile UX & Accessibility Refactor

## Hedef

Mobil hamburger menüsünün kritik UX/a11y eksiklerini, mevcut görsel akışı ve marka renklerini koruyarak tek bir tutarlı geçişte düzeltmek.

## Plan

### A. Yapısal — Sticky/Scroll Mekaniği
- [x] Mobil paneli `<header>` içinden çıkar; `position: fixed top-16 inset-x-0` olarak portal-benzeri kardeş element yap
- [x] Panele `max-h-[calc(100dvh-4rem)] overflow-y-auto overscroll-contain` ekle (uzun menüde içeride scroll)
- [x] Backdrop ekle: yarı saydam, tıklayınca kapanır, `fixed inset-0 z-40`
- [x] Menü açıkken `document.body.style.overflow = "hidden"` (cleanup ile)
- [x] Açılış/kapanış: backdrop opacity + panel translateY transition (motion-reduce saygılı)

### B. Klavye + Erişilebilirlik
- [x] Escape tuşu menüyü kapatsın (global keydown listener)
- [x] Trigger butonuna `aria-controls={MOBILE_PANEL_ID}` ekle, panele `id` ver
- [x] Trigger `aria-label` dinamik: "Menüyü aç" ↔ "Menüyü kapat"
- [x] Mobil paneli `<nav aria-label="Mobil menü">` ile sar
- [x] Panele `aria-hidden={!mobileOpen}` ve kapalıyken `pointer-events-none`
- [x] MobileCollapseItem chevron butonuna `aria-controls` referansı
- [x] Menü kapanınca focus tekrar trigger butonuna dönsün (`useRef`)
- [x] `prefers-reduced-motion` saygısı (`motion-reduce:transition-none`)

### C. Tap-Hedefleri (WCAG 2.5.5)
- [x] Primary linkler `min-h-[48px]`
- [x] Collapse item başlığı tüm satır genişliğinde tıklanabilir (dead-zone yok)
- [x] Chevron toggle butonu `min-h-[44px] min-w-[44px]`
- [x] Alt menü linkleri `min-h-[44px]`
- [x] Sub-sub kategori linkleri `min-h-[40px]` (alt seviye, biraz daha küçük tolere edilebilir)

### D. UX Tutarlılığı
- [x] "Markalar" başlığını da clickable yap (alt menüyü toggle eder — `/markalar` yok, tutarlılık için başlık+chevron aynı işi yapar)
- [x] Mobil panelde aktif sayfa state'i göster (`isActive` mobil linklere de uygulansın)
- [x] Mobil "Ürünler" alt menüsünde kategori ikonu (desktop dropdown ile tutarlı)
- [x] Mobil "Markalar" alt menüsünde marka logosu (desktop dropdown ile tutarlı)
- [x] Primary linkler arasına ince ayraç (`border-b border-[var(--color-border-soft)]`)
- [x] Hamburger butonuna hover/active background (tap feedback)

### E. Desktop Dropdown (iPad/Touch md+)
- [x] `BrandsDropdown` ve `ProductsDropdown` state-based open + onMouseEnter/Leave + onClick toggle
- [x] Click-outside ile kapanma
- [x] Escape ile kapanma
- [x] Chevron'da rotate animasyonu (motion-reduce saygılı)
- [x] `aria-haspopup="true"` ve `aria-expanded={open}` ekle
- [x] Ürünler için Link (text → /urunler) + ayrı button (chevron → toggle) — touch'ta dropdown açılır, navigate de yapılabilir

### F. Doğrulama
- [x] `npm run typecheck` temiz
- [x] `npm run build` temiz (61 sayfa export, 0 hata/uyarı)
- [x] `npm run dev` smoke test: `/`, `/urunler`, `/hakkimizda` 200 OK
- [x] Rendered HTML doğrulaması: tüm `aria-controls` ↔ `id` eşleşmesi, `aria-expanded`, `aria-haspopup`, `aria-label`, `inert` doğru çıktı
- [ ] Manuel test (kullanıcı tarafından): 320/375/414/768px gerçek cihaz UX'i — özellikle iPhone SE'de "Ürünler+Markalar" ikisi açıkken scroll davranışı
- [ ] Manuel test (kullanıcı tarafından): iPad portrait Markalar/Ürünler dropdown'larının chevron'a tıklayarak açılması

## Review (post-implementation)

### Yapılan Değişiklikler

**`components/Navbar.tsx` — tek dosyada toplu refactor:**

1. **Sticky taşma sorunu çözüldü**: Mobil panel artık `position: fixed top-16` olarak header'dan ayrı, kendi içinde `overflow-y: auto`. iPhone SE'de bile en alttaki menü öğesine erişilebiliyor.
2. **Backdrop + body scroll lock**: Açıkken arka plan kararıyor, sayfa scroll'u kilitleniyor, dışarıya tıklayınca kapanıyor.
3. **Klavye + Esc**: Menü Esc ile kapanıyor, kapanınca focus trigger butonuna geri dönüyor.
4. **Tap-hedefleri 44-48px**: Tüm interactive öğeler WCAG 2.5.5 minimumunu karşılıyor; collapse item başlığı tüm satır genişliğinde tıklanıyor.
5. **iPad/touch dropdown sorunu çözüldü**: `BrandsDropdown` ve `ProductsDropdown` artık hem hover hem click ile açılıyor. Click-outside + Esc ile kapanıyor.
6. **a11y bütünlüğü**: `aria-controls`/`aria-expanded`/`aria-haspopup`/`aria-hidden`, dinamik label, `<nav aria-label>` semantic'i, focus return, `prefers-reduced-motion` desteği.
7. **UX tutarlılığı**: Mobilde aktif sayfa rengi, marka logosu, kategori ikonu, primary linkler arası ayraç.

### Akış Korundu mu?

- Layout / renk / tipografi: değişmedi
- Header yüksekliği (h-16): değişmedi
- Mevcut linkler / yönlendirme: değişmedi
- Submenu açma davranışı (chevron): aynı, ek olarak başlık da clickable oldu
- Desktop hover dropdown davranışı: korundu, üstüne click toggle eklendi

### Adversarial Review Sonrası Yapılan Ek Düzeltmeler

İlk implementasyon sonrası kendi kodumu eleştirel gözle inceledim, gerçek/polish sorunları tespit edip düzelttim:

1. **`onMouseEnter` + tap çakışması (gerçek bug)** — iOS Safari/Android Chrome tap'inde mouse event'leri simüle ettiği için `onMouseEnter` `click`'ten önce tetikleniyordu. Net sonuç: touch'ta tap chevron → açılır → kapanır (anında). Çözüm: `onPointerEnter`/`onPointerLeave` + `e.pointerType === "mouse"` filtresi. Touch'ta hover handler'ları sessiz kalıyor, click toggle düzgün çalışıyor.

2. **`group-hover` Tailwind v4 hover-media wrap'ı yapmıyor** — Bu projede `:is(:where(.group):hover *)` raw selector olarak compile ediliyor, yani iOS sticky `:hover` ile çakışıyor. Bu yüzden `group-hover`'a güvenmek yerine JS state + pointer-filtreli hover'a geçtim.

3. **Aktif "Ürünler" chevron rengi gri kalıyordu** — Link kırmızı ama chevron button gri. `active` prop'u chevron button'a da iletildi.

4. **iOS body scroll lock güçlendirildi** — Sadece `overflow: hidden` yetmiyordu; `overscroll-behavior: contain` da eklendi (rubber-band scroll'a karşı belt-and-suspenders).

5. **Z-index regresyonu — ürün detay sticky bottom-bar (`z-40`) çakışması** — `app/urun/[id]/page.tsx:228`'deki "Hemen ara/Sipariş" CTA bar'ı `z-40`. Mobil menü backdrop+panel'im de `z-40` idi → source order'da bottom-bar Navbar'dan sonra → bottom-bar mobil menü panelin altından görünüyor ve tıklanabiliyordu. Mobil menü backdrop+panel `z-[45]`'e çıkarıldı: header `z-50` (hamburger erişilebilir) > menu `z-[45]` > bottom-bar `z-40` > cookie `z-30`.

### Bilinçli Trade-off

- **CookieBanner `z-30` mobil menü açıkken backdrop arkasında gizleniyor.** Cookie'yi `z-50`'ye çıkarıp menü ile birlikte göstermek mümkün ama UX olarak kötü — kullanıcı menüye odaklanmışken cookie banner dikkat dağıtır. Persistent zaten — menü kapanınca tekrar görünür. Mevcut hâli tercih edildi.

### Bilinçli Kapsam Dışı

- Search bar (mobil menüde arama) — ayrı bir feature, bu refactor scope'unda değil
- Focus trap (Tab içinde kalma) — backdrop+body lock zaten yeterli izolasyon sağlıyor; full trap library yüklemeden eklenecekse manuel implementasyon karmaşıklaşıyor, gerekirse ayrı bir PR'da
- Sub-sub kategori (Sarf Malzemeler altı) için iPad'de click-toggle: alt menü zaten 2 öğe (Fren, Katkı) ve `/urunler?kategori=sarf` ana sayfasında filter ile erişilebilir; ek state karmaşıklığına değmez
