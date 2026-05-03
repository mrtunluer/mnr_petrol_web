import type { Metadata } from "next";
import Link from "next/link";

export const metadata: Metadata = {
  title: "Sayfa Bulunamadı | MNR Petrol",
  robots: { index: false, follow: false },
};

export default function NotFound() {
  return (
    <section className="bg-[var(--color-surface-alt)] py-24">
      <div className="container-page">
        <div className="grid gap-10 lg:grid-cols-12 lg:items-center">
          <div className="lg:col-span-5">
            <div className="font-mono text-xs text-[var(--color-ink-subtle)]">
              — 404
            </div>
            <div className="mt-2 text-[10px] font-bold uppercase tracking-[0.3em] text-[var(--color-brand)]">
              Sayfa Bulunamadı
            </div>
            <h1 className="mt-3 text-5xl font-semibold tracking-tight text-[var(--color-ink)] sm:text-6xl">
              Aradığınız sayfa yok
            </h1>
            <p className="mt-4 max-w-md text-sm leading-relaxed text-[var(--color-ink-soft)]">
              Bağlantı taşınmış veya geçici olarak erişilemiyor olabilir.
              Aradığınız ürün veya bilgi için ana kataloğa göz atabilirsiniz.
            </p>
            <div className="mt-8 flex flex-wrap gap-3">
              <Link
                href="/"
                className="inline-flex items-center gap-2 bg-[var(--color-ink)] px-6 py-3 text-xs font-bold uppercase tracking-[0.22em] text-white transition-colors hover:bg-[var(--color-brand)]"
              >
                Ana sayfa
              </Link>
              <Link
                href="/urunler"
                className="inline-flex items-center gap-2 border-b border-[var(--color-ink)] pb-1 text-sm font-semibold text-[var(--color-ink)] transition-colors hover:border-[var(--color-brand)] hover:text-[var(--color-brand)]"
              >
                Ürün kataloğuna git →
              </Link>
            </div>
          </div>

          <div className="lg:col-span-7">
            <div className="grid grid-cols-2 gap-3 sm:grid-cols-3">
              <Quick label="Motor Yağları" href="/urunler?kategori=motor" />
              <Quick label="Motorsiklet" href="/urunler?kategori=motorsiklet" />
              <Quick label="Şanzıman" href="/urunler?kategori=sanziman" />
              <Quick label="Hidrolik" href="/urunler?kategori=hidrolik" />
              <Quick label="Antifriz" href="/urunler?kategori=antifriz" />
              <Quick label="Sarf Malzeme" href="/urunler?kategori=sarf" />
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}

function Quick({ label, href }: { label: string; href: string }) {
  return (
    <Link
      href={href}
      className="group flex items-center justify-between rounded-lg border border-[var(--color-border)] bg-white p-4 text-sm transition-all hover:-translate-y-0.5 hover:border-[var(--color-ink)]"
    >
      <span className="font-semibold text-[var(--color-ink)] group-hover:text-[var(--color-brand)]">
        {label}
      </span>
      <svg
        width="12"
        height="12"
        viewBox="0 0 24 24"
        fill="none"
        stroke="currentColor"
        strokeWidth="2"
        strokeLinecap="round"
        strokeLinejoin="round"
        className="text-[var(--color-ink-muted)] transition-transform group-hover:translate-x-1 group-hover:text-[var(--color-brand)]"
        aria-hidden="true"
      >
        <line x1="5" y1="12" x2="19" y2="12" />
        <polyline points="12 5 19 12 12 19" />
      </svg>
    </Link>
  );
}
