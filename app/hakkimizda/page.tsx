import type { Metadata } from "next";
import Image from "next/image";
import Link from "next/link";
import { brands } from "@/src/data/brands";
import { products } from "@/src/data/products";
import { buildMetadata } from "@/src/lib/seo";
import { site } from "@/src/lib/site";

export const metadata: Metadata = buildMetadata({
  title: "Hakkımızda",
  path: "/hakkimizda",
  description:
    "MNR Petrol Tarım İnş. San. Tic. Ltd. Şti. — 2008'den bu yana Akdeniz bölgesinde madeni yağ tedariğinde güvenilir çözüm ortağı.",
});

const FOUNDED_YEAR = 2008;
const yearsActive = new Date().getFullYear() - FOUNDED_YEAR;
const skuCount = products.length;
const brandCount = brands.length;

const stats = [
  { label: "Deneyim", value: `${yearsActive}+`, suffix: "Yıl" },
  { label: "Marka", value: `${brandCount}`, suffix: "Tedarikçi" },
  { label: "Ürün", value: `${skuCount}+`, suffix: "SKU" },
  { label: "Bölge", value: "Akdeniz", suffix: "Servis Alanı" },
] as const;

export default function HakkimizdaPage() {
  return (
    <>
      {/* 01 Intro + Stats */}
      <section className="bg-white py-20">
        <div className="container-page grid gap-12 lg:grid-cols-12">
          <div className="lg:col-span-5">
            <div className="font-mono text-xs text-[var(--color-ink-subtle)]">
              — 01
            </div>
            <div className="mt-2 text-[10px] font-bold uppercase tracking-[0.3em] text-[var(--color-brand)]">
              Hakkımızda
            </div>
            <h1 className="mt-3 text-4xl font-semibold tracking-tight text-[var(--color-ink)] sm:text-5xl">
              {site.legalName}
            </h1>
            <p className="mt-2 text-sm font-semibold uppercase tracking-[0.2em] text-[var(--color-ink-muted)]">
              {site.tagline}
            </p>

            <p className="mt-6 font-mono text-[11px] text-[var(--color-ink-subtle)]">
              — Kuruluş {FOUNDED_YEAR}
            </p>
          </div>

          <div className="lg:col-span-7">
            <div className="space-y-6 text-base leading-relaxed text-[var(--color-ink-soft)]">
              <p>
                {FOUNDED_YEAR} yılında kurulan firmamız, Akdeniz bölgesinde
                otomotiv ve endüstriyel sektörlerin madeni yağ ihtiyacını
                karşılayan güvenilir çözüm ortağınızdır. Yılların
                deneyimiyle, kaliteli ürünler ve profesyonel hizmet
                anlayışımızla müşterilerimize değer katıyoruz.
              </p>
              <p>
                Madeni yağ tedariği temel faaliyet alanımız olmakla birlikte;
                yazılım, lojistik, sanayi ve inşaat sektörlerinde de hizmet
                sunan çok sektörlü bir kurumsal grubuz. Grup bünyesindeki{" "}
                <a
                  href="https://tamirdefteri.com"
                  target="_blank"
                  rel="noopener noreferrer"
                  className="font-semibold text-[var(--color-ink)] underline decoration-[var(--color-brand)] decoration-2 underline-offset-2 transition-colors hover:text-[var(--color-brand)]"
                >
                  Tamir Defteri
                </a>{" "}
                ve{" "}
                <a
                  href="https://yukunolsun.com"
                  target="_blank"
                  rel="noopener noreferrer"
                  className="font-semibold text-[var(--color-ink)] underline decoration-[var(--color-brand)] decoration-2 underline-offset-2 transition-colors hover:text-[var(--color-brand)]"
                >
                  YükünOlsun
                </a>{" "}
                dijital platformlarıyla otomotiv ve nakliye ekosisteminin
                dijital dönüşümüne katkı sunuyoruz.
              </p>
            </div>
          </div>
        </div>

        <div className="container-page mt-16">
          <dl className="grid grid-cols-2 gap-x-4 gap-y-6 border-y border-[var(--color-border)] py-8 sm:grid-cols-4 sm:gap-0 sm:divide-x sm:divide-[var(--color-border)]">
            {stats.map((s, i) => (
              <div
                key={s.label}
                className={`sm:px-6 ${i === 0 ? "sm:pl-0" : ""} ${
                  i === stats.length - 1 ? "sm:pr-0" : ""
                }`}
              >
                <dt className="font-mono text-[10px] uppercase tracking-[0.18em] text-[var(--color-ink-subtle)]">
                  — {s.label}
                </dt>
                <dd className="mt-2 flex items-baseline gap-2">
                  <span className="text-3xl font-semibold text-[var(--color-ink)] sm:text-4xl">
                    {s.value}
                  </span>
                  <span className="text-[11px] font-medium uppercase tracking-[0.16em] text-[var(--color-ink-muted)]">
                    {s.suffix}
                  </span>
                </dd>
              </div>
            ))}
          </dl>
        </div>
      </section>

      {/* 02 Brands */}
      <section className="border-t border-[var(--color-border)] bg-[var(--color-surface-alt)] py-24">
        <div className="container-page">
          <div className="flex flex-col items-start justify-between gap-4 border-b border-[var(--color-border)] pb-8 md:flex-row md:items-end">
            <div>
              <div className="font-mono text-xs text-[var(--color-ink-subtle)]">
                — 02
              </div>
              <div className="mt-2 text-[10px] font-bold uppercase tracking-[0.3em] text-[var(--color-brand)]">
                Tedarik Portföyü
              </div>
              <h2 className="mt-3 text-3xl font-semibold tracking-tight text-[var(--color-ink)] sm:text-4xl">
                Çalıştığımız markalar
              </h2>
            </div>
            <p className="max-w-md text-sm leading-relaxed text-[var(--color-ink-soft)]">
              {brandCount} ulusal ve uluslararası madeni yağ markasıyla
              otomotiv ve endüstriyel sektörlerin yağlama ihtiyaçlarını
              karşılıyoruz.
            </p>
          </div>

          <ul className="grid grid-cols-2 gap-px bg-[var(--color-border)] sm:grid-cols-3 lg:grid-cols-6">
            {brands.map((b) => (
              <li key={b.slug} className="bg-white">
                <Link
                  href={`/urunler?marka=${b.slug}`}
                  className="group flex aspect-[4/3] flex-col items-center justify-center gap-3 p-6 transition-colors hover:bg-[var(--color-surface-alt)]"
                >
                  <div className="relative h-12 w-full max-w-[120px]">
                    <Image
                      src={b.logo}
                      alt={b.name}
                      fill
                      sizes="120px"
                      className="object-contain transition-transform duration-200 group-hover:scale-105"
                    />
                  </div>
                  <span className="text-[11px] font-medium uppercase tracking-[0.18em] text-[var(--color-ink-muted)] transition-colors group-hover:text-[var(--color-brand)]">
                    {b.name}
                  </span>
                </Link>
              </li>
            ))}
          </ul>
        </div>
      </section>

      {/* 03 CTA + Location */}
      <section className="border-t border-[var(--color-border)] bg-[var(--color-night)] py-20 text-white">
        <div className="container-page">
          <div className="grid gap-8 border-b border-white/10 pb-12 md:grid-cols-[1fr_auto] md:items-end md:pb-16">
            <div>
              <div className="font-mono text-xs text-white/50">— 03</div>
              <div className="mt-2 text-[10px] font-bold uppercase tracking-[0.3em] text-[var(--color-brand)]">
                İletişim
              </div>
              <h2 className="mt-3 text-3xl font-semibold tracking-tight text-white sm:text-4xl">
                Birlikte çalışalım
              </h2>
              <p className="mt-3 max-w-xl text-sm text-white/70">
                İhtiyacınız olan ürün için teklif ya da özel çözüm için bize
                ulaşın.
              </p>
            </div>
            <div className="flex flex-wrap gap-3">
              <Link
                href="/urunler"
                className="inline-flex items-center gap-2 bg-[var(--color-brand)] px-6 py-3 text-xs font-bold uppercase tracking-[0.22em] text-white transition-colors hover:bg-[var(--color-brand-dark)]"
              >
                Ürünleri İncele
              </Link>
              <Link
                href="/#iletisim"
                className="inline-flex items-center gap-2 border border-white/30 px-6 py-3 text-xs font-bold uppercase tracking-[0.22em] transition-colors hover:border-white hover:bg-white/10"
              >
                İletişime Geç
              </Link>
            </div>
          </div>

          <dl className="grid grid-cols-1 gap-8 pt-12 sm:grid-cols-3 sm:gap-0 sm:divide-x sm:divide-white/10">
            <div className="sm:pr-8">
              <dt className="font-mono text-[10px] uppercase tracking-[0.18em] text-white/50">
                — Merkez
              </dt>
              <dd className="mt-2 text-sm leading-relaxed text-white">
                {site.address.street}
                <br />
                {site.address.district} / {site.address.city}
                <br />
                <a
                  href={site.mapUrl}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="mt-2 inline-flex items-center gap-1.5 text-xs font-semibold uppercase tracking-[0.18em] text-[var(--color-brand)] transition-colors hover:text-white"
                >
                  Yol Tarifi
                  <svg
                    width="10"
                    height="10"
                    viewBox="0 0 24 24"
                    fill="none"
                    stroke="currentColor"
                    strokeWidth="2.5"
                    strokeLinecap="round"
                    strokeLinejoin="round"
                    aria-hidden="true"
                  >
                    <path d="M7 17L17 7" />
                    <path d="M7 7h10v10" />
                  </svg>
                </a>
              </dd>
            </div>
            <div className="sm:px-8">
              <dt className="font-mono text-[10px] uppercase tracking-[0.18em] text-white/50">
                — Çalışma Saatleri
              </dt>
              <dd className="mt-2 text-sm leading-relaxed text-white">
                Pzt – Cmt
                <br />
                09:00 – 18:00
                <br />
                <span className="mt-2 inline-block text-xs text-white/50">
                  Pazar kapalı
                </span>
              </dd>
            </div>
            <div className="sm:pl-8">
              <dt className="font-mono text-[10px] uppercase tracking-[0.18em] text-white/50">
                — Telefon
              </dt>
              <dd className="mt-2 text-sm leading-relaxed text-white">
                <a
                  href={`tel:${site.phone.replace(/\s+/g, "")}`}
                  className="font-semibold transition-colors hover:text-[var(--color-brand)]"
                >
                  {site.phone}
                </a>
                <br />
                <span className="text-xs text-white/50">
                  Akdeniz Bölgesi
                </span>
              </dd>
            </div>
          </dl>
        </div>
      </section>
    </>
  );
}

