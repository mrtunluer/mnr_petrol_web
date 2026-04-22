import type { MetadataRoute } from "next";
import { site } from "@/src/lib/site";
import { brands } from "@/src/data/brands";
import { categories } from "@/src/data/categories";

export const dynamic = "force-static";

export default function sitemap(): MetadataRoute.Sitemap {
  const now = new Date();
  const base = site.url;

  const staticRoutes: MetadataRoute.Sitemap = [
    { url: `${base}/`, lastModified: now, changeFrequency: "weekly", priority: 1 },
    { url: `${base}/hakkimizda`, lastModified: now, changeFrequency: "monthly", priority: 0.6 },
    { url: `${base}/urunler`, lastModified: now, changeFrequency: "weekly", priority: 0.9 },
  ];

  const categoryRoutes: MetadataRoute.Sitemap = categories.map((c) => ({
    url: `${base}/urunler?kategori=${c.slug}`,
    lastModified: now,
    changeFrequency: "weekly",
    priority: 0.7,
  }));

  const brandRoutes: MetadataRoute.Sitemap = brands.map((b) => ({
    url: `${base}/urunler?marka=${b.slug}`,
    lastModified: now,
    changeFrequency: "weekly",
    priority: 0.7,
  }));

  return [...staticRoutes, ...categoryRoutes, ...brandRoutes];
}
