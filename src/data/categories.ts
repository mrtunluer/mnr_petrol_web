export type SubCategory = {
  slug: string;
  name: string;
};

export type Category = {
  slug: string;
  name: string;
  icon: string;
  subCategories?: readonly SubCategory[];
};

export const categories: readonly Category[] = [
  { slug: "motor", name: "Motor Yağları", icon: "/categories/motor-yaglari.webp" },
  { slug: "motorsiklet", name: "Motorsiklet Yağları", icon: "/categories/motorsiklet-yaglari.webp" },
  { slug: "sanziman", name: "Şanzıman ve Dişli Yağları", icon: "/categories/sanziman.webp" },
  { slug: "hidrolik", name: "Hidrolik Sistem Yağları", icon: "/categories/hidrolik.webp" },
  {
    slug: "sarf",
    name: "Sarf Malzemeler",
    icon: "/categories/sarf-malzemeler.webp",
    subCategories: [
      { slug: "fren", name: "Fren Hidrolik Sıvıları" },
      { slug: "katki", name: "Katkı Maddeleri" },
    ],
  },
  { slug: "antifriz", name: "Antifrizler", icon: "/categories/antifiriz.webp" },
] as const;

export const categoryBySlug = (slug: string): Category | undefined =>
  categories.find((c) => c.slug === slug);
