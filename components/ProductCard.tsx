import Image from "next/image";
import Link from "next/link";
import type { Product } from "@/src/data/products";

type Props = {
  product: Product;
  priority?: boolean;
  sizes?: string;
};

export default function ProductCard({
  product,
  priority = false,
  sizes = "(max-width: 640px) 50vw, (max-width: 1024px) 33vw, 25vw",
}: Props) {
  return (
    <Link
      href={`/urun/${product.id}`}
      className="group relative flex flex-col overflow-hidden rounded-2xl bg-white ring-1 ring-[var(--color-border)] transition-all duration-300 hover:-translate-y-1 hover:shadow-[var(--shadow-card-hover)] hover:ring-[var(--color-brand)]/30"
    >
      <div className="relative aspect-square overflow-hidden bg-gradient-to-b from-[var(--color-surface-alt)] to-white">
        <span className="pointer-events-none absolute inset-0 bg-[radial-gradient(circle_at_50%_100%,rgba(215,25,32,0.05),transparent_60%)] opacity-0 transition-opacity duration-500 group-hover:opacity-100" />
        <Image
          src={product.image}
          alt={product.name}
          fill
          sizes={sizes}
          priority={priority}
          className="object-contain p-5 transition-transform duration-500 ease-out group-hover:scale-[1.08]"
        />

        <div className="absolute left-3 top-3 flex flex-col gap-1.5">
          <span className="inline-flex items-center rounded-md bg-[var(--color-brand)] px-2 py-0.5 text-[10px] font-bold uppercase tracking-wider text-white shadow-sm">
            {product.brandName}
          </span>
          {product.featured && (
            <span className="inline-flex items-center gap-1 rounded-md bg-[var(--color-accent)]/15 px-2 py-0.5 text-[10px] font-bold uppercase tracking-wider text-[var(--color-accent)] ring-1 ring-[var(--color-accent)]/30">
              <StarSolid />
              Öne Çıkan
            </span>
          )}
        </div>

        <span className="absolute right-3 top-3 inline-flex items-center gap-1 rounded-full bg-white/90 px-2 py-0.5 text-[10px] font-semibold text-[var(--color-ink)] shadow-sm ring-1 ring-[var(--color-border)] backdrop-blur-sm">
          <CheckBadge />
          Yetkili Satıcı
        </span>

        <div className="pointer-events-none absolute inset-x-0 bottom-0 translate-y-full bg-gradient-to-t from-black/80 via-black/50 to-transparent p-4 text-white opacity-0 transition-all duration-300 group-hover:translate-y-0 group-hover:opacity-100">
          <span className="inline-flex items-center gap-1.5 text-xs font-semibold uppercase tracking-wider">
            Ürünü İncele
            <ArrowIcon />
          </span>
        </div>
      </div>

      <div className="flex flex-1 flex-col gap-1.5 p-4">
        <div className="flex items-center justify-between">
          <span className="text-[10px] font-semibold uppercase tracking-[0.12em] text-[var(--color-ink-muted)]">
            {product.categoryName}
          </span>
          <Rating />
        </div>
        <h3 className="line-clamp-2 text-sm font-semibold leading-snug text-[var(--color-ink)] transition-colors group-hover:text-[var(--color-brand)]">
          {product.name}
        </h3>
      </div>
    </Link>
  );
}

function Rating() {
  return (
    <span
      className="inline-flex items-center gap-0.5"
      aria-label="5 yıldızlı ürün"
    >
      {[0, 1, 2, 3, 4].map((i) => (
        <svg
          key={i}
          width="10"
          height="10"
          viewBox="0 0 24 24"
          fill="currentColor"
          className="text-[var(--color-accent)]"
          aria-hidden="true"
        >
          <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2" />
        </svg>
      ))}
    </span>
  );
}

function StarSolid() {
  return (
    <svg width="10" height="10" viewBox="0 0 24 24" fill="currentColor" aria-hidden="true">
      <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2" />
    </svg>
  );
}

function CheckBadge() {
  return (
    <svg
      width="10"
      height="10"
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth="3"
      strokeLinecap="round"
      strokeLinejoin="round"
      className="text-emerald-600"
      aria-hidden="true"
    >
      <polyline points="20 6 9 17 4 12" />
    </svg>
  );
}

function ArrowIcon() {
  return (
    <svg
      width="12"
      height="12"
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
