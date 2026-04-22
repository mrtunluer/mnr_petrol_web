import type { Metadata } from "next";
import Link from "next/link";
import { notFound } from "next/navigation";
import { buildMetadata } from "@/src/lib/seo";
import { site } from "@/src/lib/site";
import {
  productById,
  products,
  productsByBrand,
  productsByCategory,
} from "@/src/data/products";
import ProductCard from "@/components/ProductCard";
import ImageZoom from "@/components/ImageZoom";
import FormattedDescription from "@/components/FormattedDescription";

type Props = { params: Promise<{ id: string }> };

export function generateStaticParams(): { id: string }[] {
  return products.map((p) => ({ id: p.id }));
}

export async function generateMetadata({ params }: Props): Promise<Metadata> {
  const { id } = await params;
  const product = productById(id);
  if (!product) return buildMetadata({ title: "Ürün bulunamadı" });

  return buildMetadata({
    title: `${product.name} — ${product.brandName}`,
    description: product.description.slice(0, 170),
    path: `/urun/${product.id}`,
    image: product.image,
  });
}

export default async function UrunDetayPage({ params }: Props) {
  const { id } = await params;
  const product = productById(id);
  if (!product) notFound();

  const related = [
    ...productsByCategory(product.category).filter((p) => p.id !== product.id),
    ...productsByBrand(product.brand).filter((p) => p.id !== product.id),
  ]
    .filter((p, i, arr) => arr.findIndex((x) => x.id === p.id) === i)
    .slice(0, 4);

  const jsonLd = {
    "@context": "https://schema.org",
    "@type": "Product",
    name: product.name,
    image: `${site.url}${product.image}`,
    description: product.description,
    brand: { "@type": "Brand", name: product.brandName },
    category: product.categoryName,
    offers: {
      "@type": "Offer",
      availability: "https://schema.org/InStock",
      priceCurrency: "TRY",
      seller: { "@type": "Organization", name: site.name },
    },
  };

  return (
    <>
      <section className="bg-white py-10">
        <div className="container-page">
          <nav aria-label="Kırıntı yolu" className="mb-6">
            <ol className="flex flex-wrap items-center gap-1.5 rounded-lg border border-[var(--color-border)] bg-white px-4 py-2.5 text-sm">
              <li>
                <Link
                  href="/"
                  aria-label="Ana Sayfa"
                  className="inline-flex items-center text-[var(--color-ink-muted)] transition-colors hover:text-[var(--color-brand)]"
                >
                  <HomeIcon />
                </Link>
              </li>
              <li className="text-[var(--color-border)]">›</li>
              <li>
                <Link
                  href="/urunler"
                  className="text-[var(--color-ink-muted)] transition-colors hover:text-[var(--color-brand)]"
                >
                  Ürünler
                </Link>
              </li>
              <li className="text-[var(--color-border)]">›</li>
              <li>
                <Link
                  href={`/urunler?marka=${product.brand}`}
                  className="text-[var(--color-ink-muted)] transition-colors hover:text-[var(--color-brand)]"
                >
                  {product.brandName}
                </Link>
              </li>
              <li className="text-[var(--color-border)]">›</li>
              <li
                aria-current="page"
                className="max-w-[60vw] truncate font-bold text-[var(--color-brand)]"
              >
                {product.name}
              </li>
            </ol>
          </nav>

          <div className="grid gap-10 lg:grid-cols-2">
            <div>
              <ImageZoom src={product.image} alt={product.name} />
            </div>
            <div>
              <div className="flex flex-wrap items-center gap-2">
                <span className="font-mono text-xs font-medium text-[var(--color-ink-subtle)]">
                  — {product.brandName}
                </span>
                <span className="text-[10px] font-semibold uppercase tracking-[0.22em] text-[var(--color-ink-muted)]">
                  {product.categoryName}
                </span>
              </div>
              <h1 className="mt-4 text-2xl font-semibold tracking-tight text-[var(--color-ink)] sm:text-3xl lg:text-4xl">
                {product.name}
              </h1>
              <div className="mt-6">
                <FormattedDescription text={product.description} />
              </div>



              <div className="mt-8">
                <a
                  href={`tel:${site.phone.replace(/\s+/g, "")}`}
                  className="inline-flex items-center gap-3 bg-[var(--color-brand)] px-6 py-3.5 text-xs font-bold uppercase tracking-[0.22em] text-white transition-colors hover:bg-[var(--color-brand-dark)]"
                >
                  <PhoneIcon />
                  {site.phone}
                </a>
              </div>
            </div>
          </div>
        </div>
      </section>

      {related.length > 0 && (
        <section className="border-t border-[var(--color-border)] bg-[var(--color-surface-alt)] py-16">
          <div className="container-page">
            <div className="flex flex-col items-start justify-between gap-4 border-b border-[var(--color-border)] pb-6 md:flex-row md:items-end">
              <div>
                <div className="text-[10px] font-bold uppercase tracking-[0.3em] text-[var(--color-brand)]">
                  İlgili Katalog
                </div>
                <h2 className="mt-2 text-2xl font-semibold tracking-tight text-[var(--color-ink)] sm:text-3xl">
                  Benzer ürünler
                </h2>
              </div>
              <Link
                href={`/urunler?marka=${product.brand}`}
                className="group inline-flex items-center gap-2 border-b border-[var(--color-ink)] pb-1 text-sm font-semibold text-[var(--color-ink)] transition-colors hover:border-[var(--color-brand)] hover:text-[var(--color-brand)]"
              >
                {product.brandName} kataloğu
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
            <ul className="mt-8 grid grid-cols-2 gap-4 sm:grid-cols-3 lg:grid-cols-4">
              {related.map((p) => (
                <li key={p.id}>
                  <ProductCard product={p} />
                </li>
              ))}
            </ul>
          </div>
        </section>
      )}

      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{ __html: JSON.stringify(jsonLd) }}
      />

      {/* Sticky mobile CTA bar */}
      <div className="fixed inset-x-0 bottom-0 z-40 border-t border-[var(--color-border)] bg-white/95 p-3 backdrop-blur-md lg:hidden">
        <a
          href={`tel:${site.phone.replace(/\s+/g, "")}`}
          className="flex h-11 w-full items-center justify-center gap-2 bg-[var(--color-brand)] text-xs font-bold uppercase tracking-[0.22em] text-white"
        >
          <PhoneIcon />
          {site.phone}
        </a>
      </div>
    </>
  );
}

function PhoneIcon() {
  return (
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
  );
}

function HomeIcon() {
  return (
    <svg
      width="14"
      height="14"
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth="2"
      strokeLinecap="round"
      strokeLinejoin="round"
      aria-hidden="true"
    >
      <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z" />
      <polyline points="9 22 9 12 15 12 15 22" />
    </svg>
  );
}

