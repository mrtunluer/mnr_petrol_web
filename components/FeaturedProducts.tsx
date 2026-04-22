import Link from "next/link";
import FeaturedCarousel from "./FeaturedCarousel";
import { SectionHeader } from "./CategoriesGrid";
import { featuredProducts } from "@/src/data/products";

export default function FeaturedProducts() {
  const products = featuredProducts();

  return (
    <section className="bg-white py-20">
      <div className="container-page">
        <div className="flex flex-col items-start justify-between gap-4 md:flex-row md:items-end">
          <SectionHeader
            kicker="Öne Çıkanlar"
            title="Öne Çıkan Ürünler"
            subtitle="En çok tercih edilen premium ürünlerimiz."
            align="left"
          />
          <Link
            href="/urunler"
            className="text-sm font-semibold text-[var(--color-brand)] underline-offset-4 hover:underline"
          >
            Tüm ürünler →
          </Link>
        </div>

        <div className="mt-10">
          <FeaturedCarousel products={products} />
        </div>
      </div>
    </section>
  );
}
