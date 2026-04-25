# MNR Petrol — Kurumsal Web Sitesi

Next.js 15 (App Router) + TypeScript + Tailwind CSS v4 ile hazırlanmış, statik HTML olarak export edilen kurumsal web sitesi.

> **Hızlı bakış:** 60+ sayfa SSG, ~102 kB First Load JS, 51 ürün katalog, statik export → herhangi bir shared hosting üzerinde Node.js gerektirmeden çalışır.

---

## Stack

- **Framework:** Next.js 15 App Router (`output: "export"`)
- **Dil:** TypeScript (strict)
- **Styling:** Tailwind CSS v4 (`@theme` token-based)
- **Font:** Roboto (self-host via `next/font/google`)
- **Görseller:** WebP, build-time `sharp` resize
- **Form:** FormSubmit.co (no backend)
- **Deploy:** Hostinger / GoDaddy shared hosting (Apache + `.htaccess`)

---

## Hızlı başlangıç

```bash
# Bağımlılıkları kur
npm install

# Dev server (Turbopack)
npm run dev          # http://localhost:3000

# Production build
npm run build        # → out/

# Deploy paketi (Hostinger/GoDaddy upload için zip)
npm run package      # → dist/mnr-petrol-site.zip
```

`npm run package` çıktısı (`dist/mnr-petrol-site.zip`, ~5 MB) doğrudan `public_html/` altına extract edilir.

---

## Yapı

```
app/                Routes — / · /hakkimizda · /urunler · /urun/[id] · 404 · 500
components/         Sunucu+istemci bileşenleri (Hero, Navbar, Footer, ...)
src/data/           Statik veri — products.ts (51 ürün), brands.ts, categories.ts
src/lib/            site.ts, seo.ts, form-endpoint.ts
public/             Optimize edilmiş WebP görseller + .htaccess
scripts/            optimize-images.ts, package-out.ts
```

---

## Komutlar

| Komut | Ne yapar |
|---|---|
| `npm run dev` | Turbopack dev server |
| `npm run build` | `next build` → `out/` statik export |
| `npm run package` | Build + zip → `dist/mnr-petrol-site.zip` |
| `npm run optimize-images` | Ham görseller varsa WebP'e dönüştürür (bir kerelik) |
| `npm run typecheck` | `tsc --noEmit` |

---

## Deploy

`DEPLOY.md` içinde Hostinger ve GoDaddy için adım adım rehber var. Özet:

1. `npm run package` → `dist/mnr-petrol-site.zip`
2. Hosting File Manager → `public_html/` → upload + extract
3. SSL'yi Let's Encrypt ile aktive et
4. FormSubmit.co aktivasyon mailini onayla (ilk submit sonrası gelir)

---

## SEO & Performans

- 60/60 sayfa SSG (51 ürün + 4 ana + sitemap/robots/manifest)
- Per-page `generateMetadata` + Schema.org JSON-LD (Organization · Website · LocalBusiness · Product)
- Dinamik `sitemap.xml` ve `robots.ts`
- `.htaccess`: HTTPS zorlaması, Brotli/gzip, immutable cache (`/_next/static/*`, `/products/*`)
- WebP görseller, `next/image` lazy loading
- Roboto self-host (FOUT yok)

---

## License

Private — © MNR Petrol Tarım İnş. San. Tic. Ltd. Şti.
