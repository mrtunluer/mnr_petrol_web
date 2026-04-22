import FeaturedCarousel from "./FeaturedCarousel";
import SectionHeader from "./SectionHeader";
import { featuredProducts } from "@/src/data/products";

export default function FeaturedProducts() {
  const products = featuredProducts();

  return (
    <section className="bg-white py-24">
      <div className="container-page">
        <SectionHeader
          kicker="Öne Çıkanlar"
          title="Seçkin Ürünler"
          description="Tam sentetik teknoloji ve Molygen katkı sisteminin öne çıkardığı referans ürünlerimiz."
          action={{ label: "Tüm ürünler", href: "/urunler" }}
        />

        <div className="mt-12">
          <FeaturedCarousel products={products} />
        </div>
      </div>
    </section>
  );
}
