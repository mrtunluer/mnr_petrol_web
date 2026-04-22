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
      className="group flex h-full flex-col overflow-hidden rounded-lg border border-[var(--color-border)] bg-white transition-all duration-300 hover:-translate-y-0.5 hover:border-[var(--color-ink)]"
    >
      <div className="relative aspect-square overflow-hidden bg-[var(--color-surface-alt)]">
        <Image
          src={product.image}
          alt={product.name}
          fill
          sizes={sizes}
          priority={priority}
          className="object-contain p-6 transition-transform duration-500 ease-out group-hover:scale-[1.05]"
        />
        {product.featured && (
          <span className="absolute left-3 top-3 inline-flex items-center rounded-sm bg-[var(--color-ink)] px-2 py-0.5 text-[9px] font-bold uppercase tracking-[0.18em] text-white">
            Öne Çıkan
          </span>
        )}
      </div>

      <div className="flex flex-1 flex-col p-5">
        <div className="flex items-center gap-2.5">
          <span className="font-mono text-[11px] font-medium text-[var(--color-ink-subtle)]">
            —
          </span>
          <span className="text-[10px] font-semibold uppercase tracking-[0.2em] text-[var(--color-ink-muted)]">
            {product.brandName}
          </span>
        </div>
        <h3 className="mt-3 line-clamp-2 text-sm font-semibold leading-snug text-[var(--color-ink)] transition-colors group-hover:text-[var(--color-brand)]">
          {product.name}
        </h3>
        <div className="mt-auto flex items-center justify-between border-t border-[var(--color-border-soft)] pt-3.5">
          <span className="text-[11px] text-[var(--color-ink-muted)]">
            {product.categoryName}
          </span>
          <span className="inline-flex items-center gap-1 text-[11px] font-semibold uppercase tracking-wider text-[var(--color-ink)] transition-colors group-hover:text-[var(--color-brand)]">
            İncele
            <svg
              width="10"
              height="10"
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
          </span>
        </div>
      </div>
    </Link>
  );
}
