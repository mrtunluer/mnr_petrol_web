import Image from "next/image";
import Link from "next/link";
import { categories } from "@/src/data/categories";
import { productsByCategory } from "@/src/data/products";

export default function CategoriesGrid() {
  return (
    <section className="bg-[var(--color-surface-alt)] py-24">
      <div className="container-page">
        <div className="flex flex-col items-start justify-between gap-4 md:flex-row md:items-end">
          <div>
            <div className="text-[10px] font-bold uppercase tracking-[0.3em] text-[var(--color-brand)]">
              Ürün Grupları
            </div>
            <h2 className="mt-2 text-3xl font-semibold tracking-tight text-[var(--color-ink)] sm:text-4xl">
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

        <ul className="mt-12 grid grid-cols-1 gap-5 sm:grid-cols-2 lg:grid-cols-3">
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
                      sizes="(max-width: 640px) 100vw, (max-width: 1024px) 50vw, 33vw"
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

