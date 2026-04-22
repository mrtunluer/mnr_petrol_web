import Image from "next/image";
import Link from "next/link";
import { brands } from "@/src/data/brands";
import { SectionHeader } from "./CategoriesGrid";

export default function BrandsShowcase() {
  return (
    <section className="relative bg-white py-24">
      <div className="container-page">
        <SectionHeader
          kicker="Çalıştığımız Markalar"
          title="Premium Markalar"
          subtitle="Güvenilir ve kaliteli markalarla hizmetinizdeyiz."
        />

        <ul className="mt-14 grid grid-cols-2 gap-4 sm:grid-cols-3 lg:grid-cols-6">
          {brands.map((b, i) => (
            <li key={b.slug}>
              <Link
                href={`/urunler?marka=${b.slug}`}
                className="group relative flex aspect-[5/4] items-center justify-center overflow-hidden rounded-2xl bg-white p-6 ring-1 ring-[var(--color-border)] transition-all duration-300 hover:-translate-y-1 hover:shadow-[var(--shadow-card-hover)] hover:ring-[var(--color-brand)]/30"
                aria-label={`${b.name} ürünlerini gör`}
              >
                <span
                  className="pointer-events-none absolute inset-0 bg-gradient-to-br from-[var(--color-brand)]/0 to-[var(--color-brand)]/0 opacity-0 transition-opacity duration-500 group-hover:from-[var(--color-brand)]/5 group-hover:to-transparent group-hover:opacity-100"
                  aria-hidden="true"
                />
                <div className="relative h-full w-full">
                  <Image
                    src={b.logo}
                    alt={b.name}
                    fill
                    sizes="(max-width: 640px) 40vw, (max-width: 1024px) 25vw, 15vw"
                    priority={i < 3}
                    className="object-contain grayscale transition-all duration-500 group-hover:grayscale-0"
                  />
                </div>
                <span className="absolute bottom-3 left-1/2 -translate-x-1/2 text-[10px] font-semibold uppercase tracking-wider text-[var(--color-ink-muted)] opacity-0 transition-opacity group-hover:opacity-100">
                  {b.name} →
                </span>
              </Link>
            </li>
          ))}
        </ul>

        <div className="mt-12 text-center">
          <Link
            href="/urunler"
            className="inline-flex items-center gap-2 rounded-full border border-[var(--color-border)] bg-white px-6 py-3 text-sm font-semibold text-[var(--color-ink)] transition-all hover:-translate-y-0.5 hover:border-[var(--color-brand)]/30 hover:text-[var(--color-brand)] hover:shadow-md"
          >
            Tüm ürün kataloğunu gör
            <svg
              width="14"
              height="14"
              viewBox="0 0 24 24"
              fill="none"
              stroke="currentColor"
              strokeWidth="2.5"
              strokeLinecap="round"
              strokeLinejoin="round"
              aria-hidden="true"
            >
              <line x1="5" y1="12" x2="19" y2="12" />
              <polyline points="12 5 19 12 12 19" />
            </svg>
          </Link>
        </div>
      </div>
    </section>
  );
}
