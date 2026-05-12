import Image from "next/image";
import Link from "next/link";
import { brands } from "@/src/data/brands";
import { products } from "@/src/data/products";

const FOUNDED_YEAR = 2008;
const yearsActive = new Date().getFullYear() - FOUNDED_YEAR;

export default function Hero() {
  return (
    <section className="relative isolate overflow-hidden bg-[var(--color-night)] text-white">
      <Image
        src="/hero/banner.webp"
        alt=""
        fill
        priority
        sizes="100vw"
        className="-z-10 object-cover opacity-35"
      />
      <div
        aria-hidden="true"
        className="-z-10 absolute inset-0 bg-gradient-to-b from-black/80 via-black/70 to-black/90"
      />

      <div className="container-page flex min-h-[520px] flex-col items-center justify-center py-16 text-center sm:min-h-[620px] sm:py-24 md:min-h-[680px] lg:min-h-[720px] lg:py-28">
        <h1 className="text-4xl font-black leading-[0.95] tracking-tight sm:text-6xl md:text-7xl lg:text-8xl">
          MNR <span className="text-[var(--color-brand)]">PETROL</span>
        </h1>

        <div
          role="list"
          aria-label="Faaliyet alanları"
          className="mt-6 flex flex-wrap items-center justify-center gap-x-2 gap-y-2 px-2 text-[10px] font-bold uppercase tracking-[0.16em] text-white/75 sm:gap-x-4 sm:px-4 sm:text-[11px] sm:tracking-[0.28em]"
        >
          <span role="listitem">Madeni Yağ</span>
          <span aria-hidden="true" className="h-3 w-px bg-white/25" />
          <span role="listitem">Yazılım</span>
          <span aria-hidden="true" className="h-3 w-px bg-white/25" />
          <span role="listitem">Lojistik</span>
          <span aria-hidden="true" className="h-3 w-px bg-white/25" />
          <span role="listitem">Sanayi</span>
          <span aria-hidden="true" className="h-3 w-px bg-white/25" />
          <span role="listitem">İnşaat</span>
        </div>

        <p className="mt-6 max-w-3xl text-lg leading-relaxed text-white/80 sm:text-xl md:text-2xl">
          Endüstri ve teknoloji çözümlerinde iş ortağınız
        </p>
        <p className="mt-3 hidden max-w-xl px-4 text-sm leading-relaxed text-white/60 sm:block sm:px-0">
          Akdeniz bölgesinde {yearsActive}+ yıllık tedarik tecrübesi,
          atölyeler ve nakliyeciler için iki dijital platform ve geniş
          sektörel hizmet ağı.
        </p>

        <div className="mt-10 flex flex-wrap justify-center gap-3">
          <Link
            href="/urunler"
            className="group inline-flex min-h-[48px] items-center gap-2 bg-[var(--color-brand)] px-8 py-4 text-xs font-bold uppercase tracking-[0.22em] text-white transition-colors hover:bg-[var(--color-brand-dark)] active:bg-[var(--color-brand-dark)]"
          >
            Ürünlerimizi Keşfedin
            <svg
              width="14"
              height="14"
              viewBox="0 0 24 24"
              fill="none"
              stroke="currentColor"
              strokeWidth="2.5"
              strokeLinecap="round"
              strokeLinejoin="round"
              className="transition-transform group-hover:translate-x-1"
              aria-hidden="true"
            >
              <line x1="5" y1="12" x2="19" y2="12" />
              <polyline points="12 5 19 12 12 19" />
            </svg>
          </Link>
          <Link
            href="#iletisim"
            className="inline-flex min-h-[48px] items-center gap-2 border border-white/30 bg-transparent px-8 py-4 text-xs font-bold uppercase tracking-[0.22em] text-white transition-colors hover:border-white hover:bg-white/10 active:bg-white/10"
          >
            İletişime Geç
          </Link>
        </div>

        <dl className="mt-20 flex flex-wrap items-center justify-center gap-5 sm:gap-0">
          <Stat value={`${yearsActive}+`} label="Yıllık Tecrübe" />
          <Divider />
          <Stat value={`${products.length}+`} label="Ürün Çeşidi" />
          <Divider />
          <Stat value={`${brands.length}`} label="Premium Marka" />
        </dl>
      </div>
    </section>
  );
}

function Stat({ value, label }: { value: string; label: string }) {
  return (
    <div className="min-w-[120px] text-center sm:px-8">
      <dt className="text-3xl font-black leading-none sm:text-4xl md:text-5xl">
        {value}
      </dt>
      <dd className="mt-2 text-[11px] font-semibold uppercase tracking-[0.2em] text-white/75">
        {label}
      </dd>
    </div>
  );
}

function Divider() {
  return (
    <span
      className="hidden h-12 w-px bg-white/20 sm:block"
      aria-hidden="true"
    />
  );
}
