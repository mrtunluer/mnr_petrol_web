export type Brand = {
  slug: string;
  name: string;
  logo: string;
};

export const brands: readonly Brand[] = [
  { slug: "borax", name: "Borax", logo: "/brands/borax.webp" },
  { slug: "japanoil", name: "Japan Oil", logo: "/brands/japanoil.webp" },
  { slug: "xenol", name: "Xenol", logo: "/brands/xenol.webp" },
  { slug: "oilport", name: "Oilport", logo: "/brands/oilport.webp" },
  { slug: "brava", name: "Brava", logo: "/brands/brava.webp" },
  { slug: "skynell", name: "Skynell", logo: "/brands/skynell.webp" },
] as const;

export const brandBySlug = (slug: string): Brand | undefined =>
  brands.find((b) => b.slug === slug);
