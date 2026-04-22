import Link from "next/link";
import Image from "next/image";
import { brands } from "@/src/data/brands";
import { categories } from "@/src/data/categories";
import { site } from "@/src/lib/site";
import NewsletterForm from "./NewsletterForm";

export default function Footer() {
  const year = new Date().getFullYear();

  return (
    <footer className="mt-24 bg-[var(--color-night)] text-white">
      {/* Newsletter band */}
      <div className="border-b border-white/10">
        <div className="container-page grid gap-8 py-12 md:grid-cols-[1.1fr_1fr] md:items-center">
          <div>
            <div className="kicker text-white/80">Bülten</div>
            <h3 className="mt-3 text-2xl font-bold text-white sm:text-3xl">
              Ürün ve kampanyalardan ilk siz haberdar olun
            </h3>
            <p className="mt-2 max-w-lg text-sm text-white/60">
              Yeni ürünler, bayilik fırsatları ve kampanyalar hakkında güncel
              kalmak için bültene katılın. Spam göndermiyoruz.
            </p>
          </div>
          <NewsletterForm />
        </div>
      </div>

      {/* Main footer grid */}
      <div className="container-page grid gap-10 py-16 md:grid-cols-12">
        <div className="md:col-span-4">
          <Link
            href="/"
            className="inline-flex items-center gap-3 rounded-xl bg-white/5 px-3 py-2 ring-1 ring-white/10"
          >
            <Image
              src="/logo.webp"
              alt={site.name}
              width={160}
              height={44}
              className="h-10 w-auto"
            />
            <span className="flex flex-col leading-tight">
              <span className="text-sm font-bold text-white">
                {site.name}
              </span>
              <span className="text-[10px] font-medium uppercase tracking-[0.25em] text-white/60">
                {site.tagline}
              </span>
            </span>
          </Link>
          <p className="mt-5 max-w-sm text-sm leading-relaxed text-white/65">
            15 yılı aşkın tecrübesiyle Türkiye'nin önde gelen madeni yağ
            tedarikçisi. Motor yağları, antifriz, fren hidrolik ve endüstriyel
            ürünlerde yetkili bayilik.
          </p>

          <div className="mt-6 flex items-center gap-3">
            <SocialLink href="#" label="LinkedIn">
              <LinkedInIcon />
            </SocialLink>
            <SocialLink href="#" label="Instagram">
              <InstagramIcon />
            </SocialLink>
            <SocialLink href="#" label="Facebook">
              <FacebookIcon />
            </SocialLink>
            <SocialLink
              href={`https://wa.me/${site.phone.replace(/[^0-9]/g, "")}`}
              label="WhatsApp"
              external
            >
              <WhatsAppIcon />
            </SocialLink>
          </div>
        </div>

        <div className="md:col-span-2">
          <h4 className="mb-4 text-xs font-bold uppercase tracking-[0.2em] text-white">
            Kurumsal
          </h4>
          <ul className="space-y-2.5 text-sm">
            <FooterLink href="/hakkimizda">Hakkımızda</FooterLink>
            <FooterLink href="/urunler">Ürünlerimiz</FooterLink>
            <FooterLink href="/#iletisim">İletişim</FooterLink>
            <FooterLink href="https://yukunolsun.com" external>
              yukunolsun.com
            </FooterLink>
          </ul>
        </div>

        <div className="md:col-span-3">
          <h4 className="mb-4 text-xs font-bold uppercase tracking-[0.2em] text-white">
            Kategoriler
          </h4>
          <ul className="space-y-2.5 text-sm">
            {categories.map((c) => (
              <FooterLink
                key={c.slug}
                href={`/urunler?kategori=${c.slug}`}
              >
                {c.name}
              </FooterLink>
            ))}
          </ul>
        </div>

        <div className="md:col-span-3">
          <h4 className="mb-4 text-xs font-bold uppercase tracking-[0.2em] text-white">
            İletişim
          </h4>
          <address className="space-y-4 text-sm not-italic text-white/65">
            <ContactRow icon={<PhoneIcon />}>
              <a
                href={`tel:${site.phone.replace(/\s+/g, "")}`}
                className="font-semibold text-white transition-colors hover:text-[var(--color-brand)]"
              >
                {site.phone}
              </a>
              <span className="mt-0.5 block text-[11px] text-white/50">
                Pzt–Cmt: 09:00 – 18:00
              </span>
            </ContactRow>
            <ContactRow icon={<PinIcon />}>
              <span className="leading-relaxed">
                {site.address.street}
                <br />
                {site.address.district} / {site.address.city}
              </span>
            </ContactRow>
            <ContactRow icon={<WhatsAppIconSmall />}>
              <a
                href={`https://wa.me/${site.phone.replace(/[^0-9]/g, "")}`}
                target="_blank"
                rel="noopener noreferrer"
                className="font-medium text-white transition-colors hover:text-[var(--color-brand)]"
              >
                WhatsApp Hattı
              </a>
            </ContactRow>
          </address>
        </div>
      </div>

      {/* Brand strip */}
      <div className="border-y border-white/10">
        <div className="container-page flex flex-wrap items-center justify-center gap-x-10 gap-y-5 py-6">
          <span className="text-[11px] font-semibold uppercase tracking-[0.2em] text-white/50">
            Yetkili Bayilik
          </span>
          {brands.map((b) => (
            <Link
              key={b.slug}
              href={`/urunler?marka=${b.slug}`}
              className="group relative h-7 w-20 opacity-50 transition-opacity hover:opacity-100"
              aria-label={b.name}
            >
              <Image
                src={b.logo}
                alt={b.name}
                fill
                sizes="80px"
                className="object-contain brightness-0 invert transition-all group-hover:brightness-100 group-hover:invert-0"
              />
            </Link>
          ))}
        </div>
      </div>

      {/* Bottom bar */}
      <div>
        <div className="container-page flex flex-col items-center justify-between gap-3 py-5 text-[11px] text-white/50 md:flex-row">
          <div>
            © {year} {site.legalName} — Tüm hakları saklıdır.
          </div>
          <div className="flex flex-wrap items-center gap-x-5 gap-y-2">
            <Link
              href="/hakkimizda"
              className="transition-colors hover:text-white"
            >
              Gizlilik Politikası
            </Link>
            <Link
              href="/hakkimizda"
              className="transition-colors hover:text-white"
            >
              Kullanım Koşulları
            </Link>
            <Link
              href="/hakkimizda"
              className="transition-colors hover:text-white"
            >
              KVKK
            </Link>
          </div>
        </div>
      </div>
    </footer>
  );
}

function FooterLink({
  href,
  children,
  external,
}: {
  href: string;
  children: React.ReactNode;
  external?: boolean;
}) {
  return (
    <li>
      {external ? (
        <a
          href={href}
          target="_blank"
          rel="noopener noreferrer"
          className="group inline-flex items-center gap-2 text-white/65 transition-colors hover:text-white"
        >
          <span className="h-px w-0 bg-[var(--color-brand)] transition-all duration-300 group-hover:w-4" />
          {children}
        </a>
      ) : (
        <Link
          href={href}
          className="group inline-flex items-center gap-2 text-white/65 transition-colors hover:text-white"
        >
          <span className="h-px w-0 bg-[var(--color-brand)] transition-all duration-300 group-hover:w-4" />
          {children}
        </Link>
      )}
    </li>
  );
}

function ContactRow({
  icon,
  children,
}: {
  icon: React.ReactNode;
  children: React.ReactNode;
}) {
  return (
    <div className="flex items-start gap-3">
      <span className="flex h-8 w-8 shrink-0 items-center justify-center rounded-md bg-white/5 text-[var(--color-brand)] ring-1 ring-white/10">
        {icon}
      </span>
      <div>{children}</div>
    </div>
  );
}

function SocialLink({
  href,
  label,
  external,
  children,
}: {
  href: string;
  label: string;
  external?: boolean;
  children: React.ReactNode;
}) {
  return (
    <a
      href={href}
      aria-label={label}
      target={external ? "_blank" : undefined}
      rel={external ? "noopener noreferrer" : undefined}
      className="flex h-9 w-9 items-center justify-center rounded-full bg-white/5 text-white/70 ring-1 ring-white/10 transition-all hover:-translate-y-0.5 hover:bg-[var(--color-brand)] hover:text-white hover:ring-[var(--color-brand)]"
    >
      {children}
    </a>
  );
}

function PhoneIcon() {
  return (
    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
      <path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z" />
    </svg>
  );
}

function PinIcon() {
  return (
    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
      <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z" />
      <circle cx="12" cy="10" r="3" />
    </svg>
  );
}

function LinkedInIcon() {
  return (
    <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor" aria-hidden="true">
      <path d="M20.45 20.45h-3.56v-5.57c0-1.33-.03-3.03-1.85-3.03-1.85 0-2.14 1.45-2.14 2.94v5.66H9.34V9h3.42v1.56h.05a3.74 3.74 0 0 1 3.37-1.85c3.6 0 4.27 2.37 4.27 5.45v6.29zM5.34 7.44a2.07 2.07 0 1 1 0-4.13 2.07 2.07 0 0 1 0 4.13zm1.78 13.01H3.56V9h3.56v11.45z" />
    </svg>
  );
}

function InstagramIcon() {
  return (
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
      <rect x="2" y="2" width="20" height="20" rx="5" />
      <path d="M16 11.37A4 4 0 1 1 12.63 8 4 4 0 0 1 16 11.37z" />
      <line x1="17.5" y1="6.5" x2="17.51" y2="6.5" />
    </svg>
  );
}

function FacebookIcon() {
  return (
    <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor" aria-hidden="true">
      <path d="M22 12a10 10 0 1 0-11.56 9.87v-6.98H8v-2.89h2.44V9.84c0-2.41 1.44-3.75 3.63-3.75 1.05 0 2.16.19 2.16.19v2.37h-1.22c-1.2 0-1.57.74-1.57 1.5v1.8h2.68l-.43 2.89h-2.25v6.98A10 10 0 0 0 22 12z" />
    </svg>
  );
}

function WhatsAppIcon() {
  return (
    <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor" aria-hidden="true">
      <path d="M17.47 14.38c-.3-.15-1.77-.87-2.05-.97-.27-.1-.48-.15-.68.15-.2.3-.78.97-.96 1.17-.17.2-.35.22-.65.07-.3-.15-1.26-.46-2.4-1.48-.9-.8-1.5-1.78-1.67-2.08-.18-.3-.02-.47.13-.62.13-.13.3-.35.45-.52.15-.18.2-.3.3-.5.1-.2.05-.37-.02-.52-.08-.15-.68-1.62-.92-2.22-.24-.58-.49-.5-.68-.51h-.58c-.2 0-.53.07-.8.37-.28.3-1.05 1.03-1.05 2.5s1.08 2.9 1.23 3.1c.15.2 2.1 3.2 5.08 4.5.71.3 1.26.49 1.7.63.71.23 1.36.2 1.87.12.57-.08 1.77-.72 2.02-1.42.25-.7.25-1.3.18-1.42-.08-.13-.28-.2-.58-.35zM12 2C6.48 2 2 6.48 2 12c0 1.76.46 3.41 1.26 4.85L2 22l5.35-1.23A9.95 9.95 0 0 0 12 22c5.52 0 10-4.48 10-10S17.52 2 12 2z" />
    </svg>
  );
}

function WhatsAppIconSmall() {
  return (
    <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor" aria-hidden="true">
      <path d="M17.47 14.38c-.3-.15-1.77-.87-2.05-.97-.27-.1-.48-.15-.68.15-.2.3-.78.97-.96 1.17-.17.2-.35.22-.65.07-.3-.15-1.26-.46-2.4-1.48-.9-.8-1.5-1.78-1.67-2.08-.18-.3-.02-.47.13-.62.13-.13.3-.35.45-.52.15-.18.2-.3.3-.5.1-.2.05-.37-.02-.52-.08-.15-.68-1.62-.92-2.22-.24-.58-.49-.5-.68-.51h-.58c-.2 0-.53.07-.8.37-.28.3-1.05 1.03-1.05 2.5s1.08 2.9 1.23 3.1c.15.2 2.1 3.2 5.08 4.5.71.3 1.26.49 1.7.63.71.23 1.36.2 1.87.12.57-.08 1.77-.72 2.02-1.42.25-.7.25-1.3.18-1.42-.08-.13-.28-.2-.58-.35zM12 2C6.48 2 2 6.48 2 12c0 1.76.46 3.41 1.26 4.85L2 22l5.35-1.23A9.95 9.95 0 0 0 12 22c5.52 0 10-4.48 10-10S17.52 2 12 2z" />
    </svg>
  );
}
