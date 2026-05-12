import type { Metadata } from "next";
import Image from "next/image";
import Link from "next/link";
import { Suspense } from "react";
import { buildMetadata } from "@/src/lib/seo";
import { products } from "@/src/data/products";
import { brands } from "@/src/data/brands";
import { categories } from "@/src/data/categories";
import { ventures } from "@/src/data/ventures";
import UrunlerClient from "./UrunlerClient";

export const metadata: Metadata = buildMetadata({
  title: "Ürünler",
  path: "/urunler",
  description:
    "Motor yağları, antifriz, fren hidrolik, şanzıman yağları ve katkı maddeleri — Borax, Xenol, Oilport, Brava, Japan Oil ve Skynell markaları.",
});

export default function UrunlerPage() {
  return (
    <>
      {/* Yazılım teaser bar (üst) */}
      <div className="border-b border-[var(--color-border)] bg-white py-3 sm:py-4">
        <div className="container-page flex flex-wrap items-center gap-x-4 gap-y-2 sm:justify-between">
          <div className="flex items-center gap-3">
            <span className="font-mono text-[10px] font-bold uppercase tracking-[0.22em] text-[var(--color-brand)]">
              — Yazılım
            </span>
            <span className="text-xs leading-tight text-[var(--color-ink-soft)] sm:text-sm">
              Yazılım ürünlerimizi de incelemek ister misiniz?
            </span>
          </div>
          <Link
            href="/yazilim"
            className="group inline-flex items-center gap-1.5 text-[11px] font-bold uppercase tracking-[0.22em] text-[var(--color-brand)] transition-colors hover:text-[var(--color-ink)]"
          >
            Yazılım Çözümleri
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
          </Link>
        </div>
      </div>

      <section className="bg-[var(--color-surface-alt)] py-16">
        <div className="container-page">
          <div className="flex flex-col items-start justify-between gap-4 border-b border-[var(--color-border)] pb-8 md:flex-row md:items-end">
            <div>
              <div className="text-[10px] font-bold uppercase tracking-[0.3em] text-[var(--color-brand)]">
                Katalog
              </div>
              <h1 className="mt-2 text-4xl font-bold tracking-tight text-[var(--color-ink)] sm:text-5xl">
                Ürünlerimiz
              </h1>
              <p className="mt-3 max-w-xl text-sm leading-relaxed text-[var(--color-ink-soft)]">
                Altı premium madeni yağ markasının ürünleriyle otomotiv ve
                endüstriyel uygulamaların tümüne yönelik geniş ürün portföyü.
              </p>
            </div>
            <div className="text-sm text-[var(--color-ink-muted)]">
              <span className="font-mono text-xs text-[var(--color-ink-subtle)]">
                —{" "}
              </span>
              <span className="font-semibold text-[var(--color-ink)]">
                {products.length}
              </span>{" "}
              ürün listelendi
            </div>
          </div>

          <div className="mt-10">
            <Suspense
              fallback={
                <div className="py-20 text-center">
                  <div className="font-mono text-xs text-[var(--color-ink-subtle)]">
                    — Yükleniyor
                  </div>
                </div>
              }
            >
              <UrunlerClient
                products={[...products]}
                brands={[...brands]}
                categories={[...categories]}
              />
            </Suspense>
          </div>
        </div>
      </section>

      {/* Yazılım promo bandı */}
      <section className="border-t border-[var(--color-border)] bg-white py-12 sm:py-14">
        <div className="container-page">
          <div className="flex flex-col gap-6 md:flex-row md:items-center md:justify-between md:gap-10">
            <div className="md:max-w-md">
              <div className="text-[10px] font-bold uppercase tracking-[0.3em] text-[var(--color-brand)]">
                Yazılım Çözümlerimiz
              </div>
              <h2 className="mt-2 text-xl font-bold tracking-tight text-[var(--color-ink)] sm:text-2xl">
                Grup bünyesindeki dijital platformlar
              </h2>
              <p className="mt-2 text-sm leading-relaxed text-[var(--color-ink-soft)]">
                Atölyeler ve nakliyeciler için geliştirdiğimiz iki dijital
                platform.
              </p>
              <Link
                href="/yazilim"
                className="group mt-4 inline-flex items-center gap-2 text-[11px] font-bold uppercase tracking-[0.22em] text-[var(--color-brand)] transition-colors hover:text-[var(--color-ink)]"
              >
                Detaylı incele
                <svg
                  width="14"
                  height="14"
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
              </Link>
            </div>

            <ul className="grid grid-cols-1 gap-3 sm:grid-cols-2 md:flex-1 md:max-w-xl">
              {ventures.map((v) => (
                <li key={v.slug}>
                  <a
                    href={v.href}
                    target="_blank"
                    rel="noopener noreferrer"
                    aria-label={`${v.name} platformuna git (yeni sekmede açılır)`}
                    className="group flex items-center gap-3 border border-[var(--color-border)] bg-white p-3 transition-all hover:border-[var(--color-ink)] hover:shadow-card-hover sm:p-4"
                  >
                    <span
                      className={`relative inline-flex h-10 w-12 shrink-0 items-center justify-center overflow-hidden rounded ring-1 ring-[var(--color-border)] ${v.logoBg}`}
                    >
                      <Image
                        src={v.logo}
                        alt={v.name}
                        fill
                        sizes="48px"
                        className="object-contain p-1"
                      />
                    </span>
                    <div className="flex min-w-0 flex-1 flex-col leading-tight">
                      <span className="text-sm font-semibold text-[var(--color-ink)] transition-colors group-hover:text-[var(--color-brand)]">
                        {v.name}
                      </span>
                      <span className="text-[11px] text-[var(--color-ink-muted)]">
                        {v.sector}
                      </span>
                    </div>
                    <svg
                      width="12"
                      height="12"
                      viewBox="0 0 24 24"
                      fill="none"
                      stroke="currentColor"
                      strokeWidth="2"
                      strokeLinecap="round"
                      strokeLinejoin="round"
                      className="shrink-0 text-[var(--color-ink-muted)] transition-colors group-hover:text-[var(--color-brand)]"
                      aria-hidden="true"
                    >
                      <path d="M7 17L17 7" />
                      <path d="M7 7h10v10" />
                    </svg>
                  </a>
                </li>
              ))}
            </ul>
          </div>
        </div>
      </section>
    </>
  );
}
