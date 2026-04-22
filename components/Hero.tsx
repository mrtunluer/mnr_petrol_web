import Image from "next/image";
import Link from "next/link";

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

      <div className="container-page flex min-h-[620px] flex-col items-center justify-center py-24 text-center md:min-h-[680px] lg:min-h-[720px] lg:py-28">
        <h1 className="text-5xl font-black leading-[0.95] tracking-tight sm:text-6xl md:text-7xl lg:text-8xl">
          MNR <span className="text-[var(--color-brand)]">PETROL</span>
        </h1>

        <p className="mt-6 max-w-3xl text-lg leading-relaxed text-white/80 sm:text-xl md:text-2xl">
          Yüksek Performanslı Motor Yağları ve Endüstriyel Ürünler
        </p>
        <p className="mt-3 max-w-xl text-sm text-white/60">
          15+ yıllık tecrübe ile 6 premium markanın yetkili bayiliği —
          Borax, Oilport, Xenol, Brava, Japan Oil, Skynell
        </p>

        <div className="mt-10 flex flex-wrap justify-center gap-3">
          <Link
            href="/urunler"
            className="group relative inline-flex items-center gap-2 overflow-hidden rounded-full bg-[var(--color-brand)] px-8 py-4 text-sm font-bold uppercase tracking-wider shadow-[var(--shadow-brand)] transition-all hover:shadow-[0_15px_40px_rgba(215,25,32,0.4)]"
          >
            <span className="absolute inset-0 bg-gradient-to-r from-transparent via-white/20 to-transparent opacity-0 transition-opacity group-hover:opacity-100" />
            <span className="relative">Ürünlerimizi Keşfedin</span>
            <svg
              width="18"
              height="18"
              viewBox="0 0 24 24"
              fill="none"
              stroke="currentColor"
              strokeWidth="2.5"
              strokeLinecap="round"
              strokeLinejoin="round"
              className="relative transition-transform group-hover:translate-x-1"
              aria-hidden="true"
            >
              <line x1="5" y1="12" x2="19" y2="12" />
              <polyline points="12 5 19 12 12 19" />
            </svg>
          </Link>
          <Link
            href="#iletisim"
            className="inline-flex items-center gap-2 rounded-full border border-white/25 bg-white/5 px-8 py-4 text-sm font-bold uppercase tracking-wider text-white backdrop-blur-sm transition-all hover:border-white/60 hover:bg-white/10"
          >
            <svg
              width="16"
              height="16"
              viewBox="0 0 24 24"
              fill="none"
              stroke="currentColor"
              strokeWidth="2"
              strokeLinecap="round"
              strokeLinejoin="round"
              aria-hidden="true"
            >
              <path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z" />
            </svg>
            İletişime Geç
          </Link>
        </div>

        <dl className="mt-20 flex flex-wrap items-center justify-center gap-5 sm:gap-0">
          <Stat value="15+" label="Yıllık Tecrübe" />
          <Divider />
          <Stat value="1000+" label="Mutlu Müşteri" />
          <Divider />
          <Stat value="5" label="Premium Marka" />
          <Divider />
          <Stat value="7/24" label="Destek" />
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
