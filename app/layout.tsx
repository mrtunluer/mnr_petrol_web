import type { Metadata, Viewport } from "next";
import { Roboto } from "next/font/google";
import Navbar from "@/components/Navbar";
import Footer from "@/components/Footer";
import TopInfoBar from "@/components/TopInfoBar";
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
  weight: ["300", "400", "500", "700", "900"],
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
      <body>
        <TopInfoBar />
        <Navbar />
        <main>{children}</main>
        <Footer />
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
