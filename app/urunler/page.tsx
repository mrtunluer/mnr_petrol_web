import type { Metadata } from "next";
import { Suspense } from "react";
import { buildMetadata } from "@/src/lib/seo";
import { products } from "@/src/data/products";
import { brands } from "@/src/data/brands";
import { categories } from "@/src/data/categories";
import UrunlerClient from "./UrunlerClient";

export const metadata: Metadata = buildMetadata({
  title: "Ürünler",
  path: "/urunler",
  description:
    "Motor yağları, antifriz, fren hidrolik, şanzıman yağları ve katkı maddeleri — Borax, Xenol, Oilport, Brava, Japan Oil ve Skynell markaları.",
});

export default function UrunlerPage() {
  return (
    <section className="bg-[var(--color-surface-alt)] py-16">
      <div className="container-page">
        <div className="flex flex-col items-start justify-between gap-4 border-b border-[var(--color-border)] pb-8 md:flex-row md:items-end">
          <div>
            <div className="text-[10px] font-bold uppercase tracking-[0.3em] text-[var(--color-brand)]">
              Katalog
            </div>
            <h1 className="mt-2 text-4xl font-semibold tracking-tight text-[var(--color-ink)] sm:text-5xl">
              Ürünlerimiz
            </h1>
            <p className="mt-3 max-w-xl text-sm leading-relaxed text-[var(--color-ink-soft)]">
              Altı premium markanın resmi distribütörü olarak, otomotiv ve
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
  );
}
