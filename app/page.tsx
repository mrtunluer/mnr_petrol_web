import Hero from "@/components/Hero";
import TrustStrip from "@/components/TrustStrip";
import CategoriesGrid from "@/components/CategoriesGrid";
import FeaturedProducts from "@/components/FeaturedProducts";
import BrandsShowcase from "@/components/BrandsShowcase";
import VenturesSection from "@/components/VenturesSection";
import ActivitiesGrid from "@/components/ActivitiesGrid";
import ContactSection from "@/components/ContactSection";

export default function HomePage() {
  return (
    <>
      <Hero />
      <TrustStrip />
      <CategoriesGrid />
      <FeaturedProducts />
      <VenturesSection />
      <BrandsShowcase />
      <ActivitiesGrid />
      <ContactSection />
    </>
  );
}
