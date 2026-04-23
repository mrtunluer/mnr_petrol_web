import type { Metadata, Viewport } from "next";
import { Roboto } from "next/font/google";
import Navbar from "@/components/Navbar";
import Footer from "@/components/Footer";
import TopInfoBar from "@/components/TopInfoBar";
import CookieBanner from "@/components/CookieBanner";
import {
  buildMetadata,
  localBusinessJsonLd,
  organizationJsonLd,
  websiteJsonLd,
} from "@/src/lib/seo";
import { site } from "@/src/lib/site";
import "./globals.css";

const roboto = Roboto({
  subsets: ["latin", "latin-ext"],
  weight: ["400", "500", "600", "700", "900"],
  display: "swap",
  variable: "--font-roboto",
});

export const metadata: Metadata = buildMetadata({
  title:
    "MNR Petrol - Motor Yağları, Antifriz, Fren Hidrolik Sıvıları ve Endüstriyel Ürünler",
  path: "/",
});

export const viewport: Viewport = {
  themeColor: site.brand.red,
  width: "device-width",
  initialScale: 1,
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="tr" className={roboto.variable}>
      <head>
        <link rel="preconnect" href="https://formsubmit.co" />
        <link rel="dns-prefetch" href="https://formsubmit.co" />
      </head>
      <body>
        <a
          href="#main"
          className="sr-only focus:not-sr-only focus:fixed focus:left-4 focus:top-4 focus:z-[100] focus:rounded focus:bg-white focus:px-4 focus:py-2 focus:text-sm focus:font-semibold focus:shadow-lg focus:outline-none focus:ring-2 focus:ring-[var(--color-brand)]"
        >
          İçeriğe atla
        </a>
        <TopInfoBar />
        <Navbar />
        <main id="main">{children}</main>
        <Footer />
        <CookieBanner />
        <script
          type="application/ld+json"
          dangerouslySetInnerHTML={{
            __html: JSON.stringify(organizationJsonLd),
          }}
        />
        <script
          type="application/ld+json"
          dangerouslySetInnerHTML={{
            __html: JSON.stringify(websiteJsonLd),
          }}
        />
        <script
          type="application/ld+json"
          dangerouslySetInnerHTML={{
            __html: JSON.stringify(localBusinessJsonLd),
          }}
        />
      </body>
    </html>
  );
}
