import type { Metadata } from "next";
import { site } from "./site";

type SeoInput = {
  title: string;
  description?: string;
  path?: string;
  image?: string;
};

export function buildMetadata({
  title,
  description = site.description,
  path = "/",
  image = "/hero/banner.webp",
}: SeoInput): Metadata {
  const url = `${site.url}${path}`;
  const fullTitle = title === site.name ? title : `${title} | ${site.name}`;

  return {
    title: fullTitle,
    description,
    keywords: [...site.keywords],
    authors: [{ name: site.name }],
    metadataBase: new URL(site.url),
    alternates: { canonical: url },
    openGraph: {
      type: "website",
      url,
      title: fullTitle,
      description,
      siteName: site.name,
      locale: site.locale,
      images: [{ url: image }],
    },
    twitter: {
      card: "summary_large_image",
      title: fullTitle,
      description,
      images: [image],
    },
    robots: { index: true, follow: true },
  };
}

export const organizationJsonLd = {
  "@context": "https://schema.org",
  "@type": "Organization",
  name: site.name,
  url: site.url,
  logo: `${site.url}/logo.png`,
  description: site.description,
  address: {
    "@type": "PostalAddress",
    streetAddress: site.address.street,
    addressLocality: site.address.district,
    addressRegion: site.address.city,
    addressCountry: site.address.country,
  },
  contactPoint: {
    "@type": "ContactPoint",
    telephone: site.phone,
    contactType: "Customer Service",
    areaServed: "TR",
    availableLanguage: ["Turkish"],
  },
  sameAs: [site.url],
};

export const websiteJsonLd = {
  "@context": "https://schema.org",
  "@type": "WebSite",
  name: site.name,
  url: site.url,
  description: site.description,
  publisher: { "@type": "Organization", name: site.name },
  inLanguage: "tr-TR",
};

export const localBusinessJsonLd = {
  "@context": "https://schema.org",
  "@type": "LocalBusiness",
  name: site.name,
  image: `${site.url}/logo.png`,
  url: site.url,
  telephone: site.phone,
  address: {
    "@type": "PostalAddress",
    streetAddress: site.address.street,
    addressLocality: site.address.district,
    addressRegion: site.address.city,
    addressCountry: site.address.country,
  },
  geo: {
    "@type": "GeoCoordinates",
    latitude: site.address.lat,
    longitude: site.address.lng,
  },
  priceRange: "$$",
  openingHours: site.hours,
};
