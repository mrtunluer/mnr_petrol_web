import Image from "next/image";
import Link from "next/link";
import { categories } from "@/src/data/categories";

export default function CategoriesGrid() {
  return (
    <section className="relative bg-[var(--color-surface-alt)] pt-28 pb-24">
      <div className="container-page">
        <SectionHeader
          kicker="Ürün Grupları"
          title="Kategorilerimiz"
          subtitle="Geniş ürün yelpazemiz ile her türlü ihtiyacınıza çözüm sunuyoruz."
        />

        <ul className="mt-14 grid grid-cols-1 gap-6 sm:grid-cols-2 lg:grid-cols-3">
          {categories.map((c, i) => (
            <li key={c.slug}>
              <Link
                href={`/urunler?kategori=${c.slug}`}
                className="group relative block aspect-[5/4] overflow-hidden rounded-2xl bg-[var(--color-ink)] shadow-[var(--shadow-card)] ring-1 ring-black/5 transition-all duration-500 hover:-translate-y-1 hover:shadow-[var(--shadow-card-hover)]"
              >
                <Image
                  src={c.icon}
                  alt={c.name}
                  fill
                  sizes="(max-width: 640px) 100vw, (max-width: 1024px) 50vw, 33vw"
                  priority={i < 3}
                  className="object-cover opacity-80 transition-all duration-700 group-hover:scale-110 group-hover:opacity-70"
                />
                <div className="absolute inset-0 bg-gradient-to-t from-black/90 via-black/40 to-transparent" />
                <div className="absolute inset-0 bg-gradient-to-tr from-[var(--color-brand)]/0 to-[var(--color-brand)]/0 opacity-0 transition-opacity duration-500 group-hover:from-[var(--color-brand)]/40 group-hover:opacity-100" />

                <div className="absolute inset-x-0 bottom-0 p-6">
                  <div className="flex items-end justify-between gap-3">
                    <div>
                      <div className="text-[10px] font-semibold uppercase tracking-[0.25em] text-white/70">
                        Kategori {String(i + 1).padStart(2, "0")}
                      </div>
                      <h3 className="mt-1 text-xl font-bold text-white sm:text-2xl">
                        {c.name}
                      </h3>
                    </div>
                    <span className="flex h-11 w-11 shrink-0 items-center justify-center rounded-full bg-[var(--color-brand)] text-white transition-all duration-300 group-hover:translate-x-1 group-hover:scale-110">
                      <ArrowIcon />
                    </span>
                  </div>
                </div>
              </Link>
            </li>
          ))}
        </ul>
      </div>
    </section>
  );
}

export function SectionHeader({
  kicker,
  title,
  subtitle,
  align = "center",
}: {
  kicker?: string;
  title: string;
  subtitle?: string;
  align?: "center" | "left";
}) {
  return (
    <div
      className={
        align === "center" ? "mx-auto max-w-2xl text-center" : "max-w-2xl"
      }
    >
      {kicker && (
        <div
          className={`flex items-center gap-3 ${
            align === "center" ? "justify-center" : ""
          }`}
        >
          <span className="h-px w-10 bg-[var(--color-brand)]" />
          <span className="text-[11px] font-bold uppercase tracking-[0.28em] text-[var(--color-brand)]">
            {kicker}
          </span>
          <span className="h-px w-10 bg-[var(--color-brand)]" />
        </div>
      )}
      <h2 className="mt-4 text-3xl font-bold text-[var(--color-ink)] sm:text-4xl lg:text-[2.75rem]">
        {title}
      </h2>
      {subtitle && (
        <p className="mt-4 text-base leading-relaxed text-[var(--color-ink-soft)]">
          {subtitle}
        </p>
      )}
    </div>
  );
}

function ArrowIcon() {
  return (
    <svg
      width="16"
      height="16"
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
  );
}
