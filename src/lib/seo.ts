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
      images: [{ url: image, width: 1200, height: 630, alt: title }],
    },
    twitter: {
      card: "summary_large_image",
      title: fullTitle,
      description,
      images: [image],
    },
    robots: { index: true, follow: true },
    verification: {
      google: site.verification.google || undefined,
      yandex: site.verification.yandex || undefined,
      other: site.verification.bing
        ? { "msvalidate.01": [site.verification.bing] }
        : undefined,
    },
  };
}

export const organizationJsonLd = {
  "@context": "https://schema.org",
  "@type": "Organization",
  name: site.legalName,
  alternateName: site.name,
  url: site.url,
  logo: `${site.url}/logo.webp`,
  description: site.description,
  foundingDate: "2008",
  address: {
    "@type": "PostalAddress",
    streetAddress: site.address.street,
    addressLocality: site.address.district,
    addressRegion: site.address.city,
    postalCode: site.address.postalCode,
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
  "@type": "AutomotiveBusiness",
  "@id": `${site.url}#localbusiness`,
  name: site.name,
  legalName: site.legalName,
  image: `${site.url}/logo.webp`,
  url: site.url,
  telephone: site.phone,
  description: site.description,
  address: {
    "@type": "PostalAddress",
    streetAddress: site.address.street,
    addressLocality: site.address.district,
    addressRegion: site.address.city,
    postalCode: site.address.postalCode,
    addressCountry: {
      "@type": "Country",
      name: site.address.countryName,
      identifier: site.address.country,
    },
  },
  geo: {
    "@type": "GeoCoordinates",
    latitude: site.address.lat,
    longitude: site.address.lng,
  },
  hasMap: site.mapUrl,
  areaServed: site.serviceArea.map((name) => ({
    "@type": "Place",
    name,
  })),
  priceRange: "$$",
  openingHoursSpecification: [
    {
      "@type": "OpeningHoursSpecification",
      dayOfWeek: [
        "Monday",
        "Tuesday",
        "Wednesday",
        "Thursday",
        "Friday",
        "Saturday",
      ],
      opens: "09:00",
      closes: "18:00",
    },
  ],
  sameAs: [site.url],
};
