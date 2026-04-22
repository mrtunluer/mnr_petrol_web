import Hero from "@/components/Hero";
import TrustStrip from "@/components/TrustStrip";
import CategoriesGrid from "@/components/CategoriesGrid";
import FeaturedProducts from "@/components/FeaturedProducts";
import BrandsShowcase from "@/components/BrandsShowcase";
import ContactSection from "@/components/ContactSection";

export default function HomePage() {
  return (
    <>
      <Hero />
      <TrustStrip />
      <CategoriesGrid />
      <FeaturedProducts />
      <BrandsShowcase />
      <ContactSection />
    </>
  );
}
