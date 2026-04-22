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
              <div className="flex items-center gap-2">
                <span className="inline-flex items-center gap-1.5 rounded-md bg-[var(--color-brand)] px-2.5 py-1 text-[11px] font-bold uppercase tracking-wider text-white shadow-sm">
                  {product.brandName}
                </span>
                <span className="inline-flex items-center gap-1 rounded-md bg-[var(--color-surface-alt)] px-2.5 py-1 text-[11px] font-semibold uppercase tracking-wider text-[var(--color-ink-soft)] ring-1 ring-[var(--color-border)]">
                  {product.categoryName}
                </span>
                <span className="inline-flex items-center gap-1 rounded-md bg-emerald-50 px-2.5 py-1 text-[11px] font-bold uppercase tracking-wider text-emerald-700 ring-1 ring-emerald-200">
                  <CheckBadgeIcon />
                  Yetkili
                </span>
              </div>
              <h1 className="mt-4 text-2xl font-black tracking-tight text-[var(--color-ink)] sm:text-3xl lg:text-4xl">
                {product.name}
              </h1>
              <div className="mt-3 flex items-center gap-3 text-sm text-[var(--color-ink-muted)]">
                <span className="inline-flex items-center gap-0.5 text-[var(--color-accent)]">
                  {[0, 1, 2, 3, 4].map((i) => (
                    <svg key={i} width="14" height="14" viewBox="0 0 24 24" fill="currentColor" aria-hidden="true">
                      <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2" />
                    </svg>
                  ))}
                </span>
                <span className="text-xs">5.0 · Premium kalite</span>
              </div>
              <div className="mt-6">
                <FormattedDescription text={product.description} />
              </div>

              <div className="mt-8">
                <h2 className="text-xs font-bold uppercase tracking-wider text-[var(--color-ink-muted)]">
                  Mevcut Hacimler
                </h2>
                <ul className="mt-3 flex flex-wrap gap-2">
                  {["1L", "4L", "5L"].map((v) => (
                    <li
                      key={v}
                      className="inline-flex items-center gap-1.5 rounded-full border border-green-200 bg-green-50 px-3 py-1.5 text-xs font-semibold text-green-800"
                    >
                      <CheckMark />
                      {v}
                    </li>
                  ))}
                </ul>
              </div>

              <ul className="mt-6 grid gap-3 sm:grid-cols-3">
                <FeatureItem
                  icon={<ShieldIcon />}
                  title="Orijinal Ürün"
                  body="Yetkili distribütör garantisi"
                />
                <FeatureItem
                  icon={<BoxIcon />}
                  title="Stokta Mevcut"
                  body="Hızlı teslimat imkanı"
                />
                <FeatureItem
                  icon={<AwardIcon />}
                  title="Kalite Belgeli"
                  body="Uluslararası standartlarda"
                />
              </ul>

              <div className="mt-8 flex flex-wrap gap-3">
                <Link
                  href="/#iletisim"
                  className="inline-flex items-center gap-2 rounded-full bg-[var(--color-brand)] px-6 py-3.5 text-sm font-bold uppercase tracking-wider text-white shadow-[var(--shadow-brand)] transition-all hover:-translate-y-0.5 hover:bg-[var(--color-brand-dark)]"
                >
                  Fiyat Teklifi Al
                  <ArrowIcon />
                </Link>
                <a
                  href={`tel:${site.phone.replace(/\s+/g, "")}`}
                  className="inline-flex items-center gap-2 rounded-full border-2 border-[var(--color-ink)] px-6 py-3.5 text-sm font-bold uppercase tracking-wider text-[var(--color-ink)] transition-colors hover:border-[var(--color-brand)] hover:text-[var(--color-brand)]"
                >
                  <PhoneIcon />
                  {site.phone}
                </a>
                <a
                  href={`https://wa.me/${site.phone.replace(/[^0-9]/g, "")}?text=${encodeURIComponent(`Merhaba, ${product.name} ürünü hakkında bilgi almak istiyorum.`)}`}
                  target="_blank"
                  rel="noopener noreferrer"
                  aria-label="WhatsApp ile yaz"
                  className="inline-flex h-12 w-12 items-center justify-center rounded-full border-2 border-emerald-600 text-emerald-600 transition-all hover:bg-emerald-600 hover:text-white"
                >
                  <WhatsAppIcon />
                </a>
              </div>
            </div>
          </div>
        </div>
      </section>

      {related.length > 0 && (
        <section className="bg-[var(--color-surface-alt)] py-16">
          <div className="container-page">
            <h2 className="text-2xl font-bold text-[var(--color-ink)]">
              Benzer Ürünler
            </h2>
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
      <div className="fixed inset-x-0 bottom-0 z-40 border-t border-[var(--color-border)] bg-white/95 p-3 backdrop-blur-md shadow-[0_-4px_16px_rgba(15,23,42,0.06)] lg:hidden">
        <div className="flex gap-2">
          <a
            href={`tel:${site.phone.replace(/\s+/g, "")}`}
            className="flex h-11 w-11 shrink-0 items-center justify-center rounded-full border-2 border-[var(--color-ink)] text-[var(--color-ink)]"
            aria-label="Ara"
          >
            <PhoneIcon />
          </a>
          <a
            href={`https://wa.me/${site.phone.replace(/[^0-9]/g, "")}?text=${encodeURIComponent(`Merhaba, ${product.name} ürünü hakkında bilgi almak istiyorum.`)}`}
            target="_blank"
            rel="noopener noreferrer"
            className="flex h-11 w-11 shrink-0 items-center justify-center rounded-full border-2 border-emerald-600 text-emerald-600"
            aria-label="WhatsApp"
          >
            <WhatsAppIcon />
          </a>
          <Link
            href="/#iletisim"
            className="flex h-11 flex-1 items-center justify-center gap-2 rounded-full bg-[var(--color-brand)] text-sm font-bold uppercase tracking-wider text-white shadow-[var(--shadow-brand)]"
          >
            Fiyat Teklifi Al
          </Link>
        </div>
      </div>
    </>
  );
}

function CheckBadgeIcon() {
  return (
    <svg
      width="12"
      height="12"
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth="3"
      strokeLinecap="round"
      strokeLinejoin="round"
      aria-hidden="true"
    >
      <polyline points="20 6 9 17 4 12" />
    </svg>
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

function WhatsAppIcon() {
  return (
    <svg
      width="18"
      height="18"
      viewBox="0 0 24 24"
      fill="currentColor"
      aria-hidden="true"
    >
      <path d="M17.47 14.38c-.3-.15-1.77-.87-2.05-.97-.27-.1-.48-.15-.68.15-.2.3-.78.97-.96 1.17-.17.2-.35.22-.65.07-.3-.15-1.26-.46-2.4-1.48-.9-.8-1.5-1.78-1.67-2.08-.18-.3-.02-.47.13-.62.13-.13.3-.35.45-.52.15-.18.2-.3.3-.5.1-.2.05-.37-.02-.52-.08-.15-.68-1.62-.92-2.22-.24-.58-.49-.5-.68-.51h-.58c-.2 0-.53.07-.8.37-.28.3-1.05 1.03-1.05 2.5s1.08 2.9 1.23 3.1c.15.2 2.1 3.2 5.08 4.5.71.3 1.26.49 1.7.63.71.23 1.36.2 1.87.12.57-.08 1.77-.72 2.02-1.42.25-.7.25-1.3.18-1.42-.08-.13-.28-.2-.58-.35zM12 2C6.48 2 2 6.48 2 12c0 1.76.46 3.41 1.26 4.85L2 22l5.35-1.23A9.95 9.95 0 0 0 12 22c5.52 0 10-4.48 10-10S17.52 2 12 2z" />
    </svg>
  );
}

function ArrowIcon() {
  return (
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
  );
}

function FeatureItem({
  icon,
  title,
  body,
}: {
  icon: React.ReactNode;
  title: string;
  body: string;
}) {
  return (
    <li className="flex items-start gap-3 rounded-lg border border-[var(--color-border)] bg-[var(--color-surface-alt)] p-3">
      <span className="flex h-9 w-9 shrink-0 items-center justify-center rounded-lg bg-[var(--color-brand)]/10 text-[var(--color-brand)]">
        {icon}
      </span>
      <div className="min-w-0">
        <div className="text-sm font-semibold text-[var(--color-ink)]">
          {title}
        </div>
        <div className="mt-0.5 text-xs text-[var(--color-ink-soft)]">
          {body}
        </div>
      </div>
    </li>
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

function CheckMark() {
  return (
    <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="3" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
      <polyline points="20 6 9 17 4 12" />
    </svg>
  );
}

function ShieldIcon() {
  return (
    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
      <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z" />
      <polyline points="9 12 11 14 15 10" />
    </svg>
  );
}

function BoxIcon() {
  return (
    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
      <path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z" />
      <polyline points="3.27 6.96 12 12.01 20.73 6.96" />
      <line x1="12" y1="22.08" x2="12" y2="12" />
    </svg>
  );
}

function AwardIcon() {
  return (
    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
      <circle cx="12" cy="8" r="7" />
      <polyline points="8.21 13.89 7 23 12 20 17 23 15.79 13.88" />
    </svg>
  );
}
