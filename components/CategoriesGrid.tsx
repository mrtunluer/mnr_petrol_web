import Image from "next/image";
import Link from "next/link";
import { categories } from "@/src/data/categories";
import { productsByCategory } from "@/src/data/products";

export default function CategoriesGrid() {
  return (
    <section className="bg-[var(--color-surface-alt)] py-14 sm:py-20 lg:py-24">
      <div className="container-page">
        <div className="flex flex-col items-start justify-between gap-4 md:flex-row md:items-end">
          <div>
            <div className="text-[10px] font-bold uppercase tracking-[0.3em] text-[var(--color-brand)]">
              Ürün Grupları
            </div>
            <h2 className="mt-2 text-3xl font-bold tracking-tight text-[var(--color-ink)] sm:text-4xl">
              Kategorilerimiz
            </h2>
            <p className="mt-3 max-w-xl text-sm leading-relaxed text-[var(--color-ink-soft)]">
              Otomotiv ve endüstriyel sektörlere yönelik altı ana üründe
              geniş spesifikasyon yelpazesi.
            </p>
          </div>
          <Link
            href="/urunler"
            className="group inline-flex items-center gap-2 border-b border-[var(--color-ink)] pb-1 text-xs font-semibold uppercase tracking-[0.22em] text-[var(--color-ink)] transition-colors hover:text-[var(--color-brand)] hover:border-[var(--color-brand)]"
          >
            Tüm kategorileri gör
            <svg
              width="12"
              height="12"
              viewBox="0 0 24 24"
              fill="none"
              stroke="currentColor"
              strokeWidth="2"
              strokeLinecap="round"
              strokeLinejoin="round"
              className="transition-transform group-hover:translate-x-0.5"
              aria-hidden="true"
            >
              <line x1="5" y1="12" x2="19" y2="12" />
              <polyline points="12 5 19 12 12 19" />
            </svg>
          </Link>
        </div>

        {/* Mobile: minimal compact list (< md) */}
        <ul className="mt-8 divide-y divide-[var(--color-border)] border-y border-[var(--color-border)] bg-white md:hidden">
          {categories.map((c) => {
            const count = c.subCategories
              ? c.subCategories.reduce(
                  (sum, sc) => sum + productsByCategory(sc.slug).length,
                  0,
                )
              : productsByCategory(c.slug).length;
            return (
              <li key={c.slug}>
                <Link
                  href={`/urunler?kategori=${c.slug}`}
                  className="group flex min-h-[64px] items-center gap-4 px-3 py-3 transition-colors active:bg-[var(--color-surface-alt)]"
                >
                  <span className="relative h-11 w-11 shrink-0 overflow-hidden rounded-md bg-[var(--color-surface-alt)] ring-1 ring-[var(--color-border)]">
                    <Image
                      src={c.icon}
                      alt=""
                      fill
                      sizes="44px"
                      className="object-cover"
                    />
                  </span>
                  <span className="flex min-w-0 flex-1 flex-col leading-tight">
                    <span className="truncate text-sm font-semibold text-[var(--color-ink)] group-hover:text-[var(--color-brand)]">
                      {c.name}
                    </span>
                    <span className="mt-0.5 text-[11px] font-medium uppercase tracking-[0.14em] text-[var(--color-ink-muted)]">
                      {count} ürün
                    </span>
                  </span>
                  <svg
                    width="14"
                    height="14"
                    viewBox="0 0 24 24"
                    fill="none"
                    stroke="currentColor"
                    strokeWidth="2"
                    strokeLinecap="round"
                    strokeLinejoin="round"
                    className="shrink-0 text-[var(--color-ink-subtle)] transition-colors group-hover:text-[var(--color-brand)]"
                    aria-hidden="true"
                  >
                    <polyline points="9 18 15 12 9 6" />
                  </svg>
                </Link>
              </li>
            );
          })}
        </ul>

        {/* Desktop: visual card grid (md+) */}
        <ul className="mt-12 hidden gap-5 md:grid md:grid-cols-2 lg:grid-cols-3">
          {categories.map((c, i) => {
            const count = c.subCategories
              ? c.subCategories.reduce(
                  (sum, sc) => sum + productsByCategory(sc.slug).length,
                  0,
                )
              : productsByCategory(c.slug).length;
            return (
              <li key={c.slug}>
                <Link
                  href={`/urunler?kategori=${c.slug}`}
                  className="group block overflow-hidden rounded-lg border border-[var(--color-border)] bg-white transition-all duration-300 hover:-translate-y-0.5 hover:border-[var(--color-ink)]"
                >
                  <div className="relative aspect-[5/3] overflow-hidden bg-[var(--color-surface-alt)]">
                    <Image
                      src={c.icon}
                      alt={c.name}
                      fill
                      sizes="(max-width: 1024px) 50vw, 33vw"
                      priority={i < 3}
                      className="object-cover transition-transform duration-700 group-hover:scale-[1.04]"
                    />
                  </div>
                  <div className="border-t border-[var(--color-border)] p-6">
                    <div className="flex items-center gap-3">
                      <span className="font-mono text-xs font-medium text-[var(--color-ink-subtle)]">
                        — {String(i + 1).padStart(2, "0")}
                      </span>
                      <span className="text-[10px] font-semibold uppercase tracking-[0.22em] text-[var(--color-ink-muted)]">
                        Kategori
                      </span>
                    </div>
                    <h3 className="mt-3 text-xl font-semibold leading-tight text-[var(--color-ink)] transition-colors group-hover:text-[var(--color-brand)]">
                      {c.name}
                    </h3>
                    <div className="mt-5 flex items-center justify-between border-t border-[var(--color-border-soft)] pt-4">
                      <span className="text-xs text-[var(--color-ink-muted)]">
                        {count} ürün
                      </span>
                      <span className="inline-flex items-center gap-1.5 text-xs font-semibold uppercase tracking-wider text-[var(--color-ink)] transition-colors group-hover:text-[var(--color-brand)]">
                        İncele
                        <svg
                          width="12"
                          height="12"
                          viewBox="0 0 24 24"
                          fill="none"
                          stroke="currentColor"
                          strokeWidth="2"
                          strokeLinecap="round"
                          strokeLinejoin="round"
                          className="transition-transform group-hover:translate-x-1"
                          aria-hidden="true"
                        >
                          <line x1="5" y1="12" x2="19" y2="12" />
                          <polyline points="12 5 19 12 12 19" />
                        </svg>
                      </span>
                    </div>
                  </div>
                </Link>
              </li>
            );
          })}
        </ul>
      </div>
    </section>
  );
}

