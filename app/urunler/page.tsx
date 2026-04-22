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
    <section className="bg-[var(--color-surface-alt)] py-12">
      <div className="container-page">
        <header className="mb-8">
          <div className="flex items-center gap-3">
            <span className="h-px w-10 bg-[var(--color-brand)]" />
            <span className="text-xs font-bold uppercase tracking-[0.25em] text-[var(--color-brand)]">
              Katalog
            </span>
          </div>
          <h1 className="mt-3 text-4xl font-bold text-[var(--color-ink)] sm:text-5xl">
            Ürünlerimiz
          </h1>
          <p className="mt-3 text-[var(--color-ink-soft)]">
            {products.length} ürün — marka ve kategoriye göre filtreleyin.
          </p>
        </header>

        <Suspense fallback={<div className="py-20 text-center">Yükleniyor…</div>}>
          <UrunlerClient
            products={[...products]}
            brands={[...brands]}
            categories={[...categories]}
          />
        </Suspense>
      </div>
    </section>
  );
}
