import Image from "next/image";
import Link from "next/link";
import { brands } from "@/src/data/brands";
import { productsByBrand } from "@/src/data/products";
import SectionHeader from "./SectionHeader";

export default function BrandsShowcase() {
  return (
    <section className="bg-white py-20">
      <div className="container-page">
        <SectionHeader
          kicker="Çalıştığımız Markalar"
          title="Premium Markalar"
          description="Altı premium madeni yağ markasının Türkiye yetkili distribütörü olarak, orijinal ürün garantisiyle hizmet veriyoruz."
          action={{ label: "Tüm kataloğu gör", href: "/urunler" }}
        />

        <ul className="mt-10 grid grid-cols-2 gap-3 sm:grid-cols-3 lg:grid-cols-6">
          {brands.map((b, i) => {
            const count = productsByBrand(b.slug).length;
            return (
              <li key={b.slug}>
                <Link
                  href={`/urunler?marka=${b.slug}`}
                  className="group flex h-full flex-col overflow-hidden rounded-lg border border-[var(--color-border)] bg-white transition-all duration-300 hover:-translate-y-0.5 hover:border-[var(--color-ink)]"
                >
                  <div className="flex h-24 items-center justify-center bg-[var(--color-surface-alt)] px-4">
                    <div className="relative h-10 w-full">
                      <Image
                        src={b.logo}
                        alt={b.name}
                        fill
                        sizes="(max-width: 640px) 40vw, (max-width: 1024px) 30vw, 14vw"
                        priority={i < 3}
                        className="object-contain"
                      />
                    </div>
                  </div>
                  <div className="border-t border-[var(--color-border)] px-3 py-3">
                    <div className="flex items-center gap-2">
                      <span className="font-mono text-[10px] font-medium text-[var(--color-ink-subtle)]">
                        — {String(i + 1).padStart(2, "0")}
                      </span>
                      <span className="text-[9px] font-semibold uppercase tracking-[0.2em] text-[var(--color-ink-muted)]">
                        Marka
                      </span>
                    </div>
                    <h3 className="mt-1.5 text-sm font-semibold leading-tight text-[var(--color-ink)] transition-colors group-hover:text-[var(--color-brand)]">
                      {b.name}
                    </h3>
                    <div className="mt-2 flex items-center justify-between border-t border-[var(--color-border-soft)] pt-2">
                      <span className="text-[10px] text-[var(--color-ink-muted)]">
                        {count} ürün
                      </span>
                      <svg
                        width="10"
                        height="10"
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
