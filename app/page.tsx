import Hero from "@/components/Hero";
import CategoriesGrid from "@/components/CategoriesGrid";
import FeaturedProducts from "@/components/FeaturedProducts";
import BrandsShowcase from "@/components/BrandsShowcase";
import ActivitiesGrid from "@/components/ActivitiesGrid";
import VenturesSection from "@/components/VenturesSection";
import ContactSection from "@/components/ContactSection";

export default function HomePage() {
  return (
    <>
      <Hero />
      <CategoriesGrid />
      <FeaturedProducts />
      <BrandsShowcase />
      <ActivitiesGrid />
      <VenturesSection />
      <ContactSection />
    </>
  );
}
