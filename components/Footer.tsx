import Link from "next/link";
import Image from "next/image";
import { brands } from "@/src/data/brands";
import { categories } from "@/src/data/categories";
import { site } from "@/src/lib/site";
import NewsletterForm from "./NewsletterForm";

export default function Footer() {
  const year = new Date().getFullYear();

  return (
    <footer className="bg-[var(--color-night)] text-white">
      {/* Newsletter band */}
      <div className="border-y border-white/10">
        <div className="container-page grid gap-8 py-10 md:grid-cols-[1.1fr_1fr] md:items-center">
          <div>
            <div className="kicker text-white/80">Bülten</div>
            <h3 className="mt-3 text-2xl font-bold text-white sm:text-3xl">
              Bayilik fırsatları ve yeni ürünlerden haberdar olun
            </h3>
            <p className="mt-2 max-w-lg text-sm text-white/60">
              Portföyümüze katılan yeni ürünler, B2B bayilik fırsatları ve
              sektör duyurularını e-posta ile iletelim.
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
            2008'den bu yana Akdeniz bölgesinde otomotiv ve endüstriyel
            sektörlerin madeni yağ tedariğinde güvenilir çözüm ortağı.
          </p>

        </div>

        <div className="md:col-span-2">
          <h4 className="mb-4 text-xs font-bold uppercase tracking-[0.2em] text-white">
            Kurumsal
          </h4>
          <ul className="space-y-2.5 text-sm">
            <FooterLink href="/hakkimizda">Hakkımızda</FooterLink>
            <FooterLink href="/urunler">Ürünlerimiz</FooterLink>
            <FooterLink href="/#iletisim">İletişim</FooterLink>
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
          </address>
        </div>
      </div>

      {/* Brand strip */}
      <div className="border-y border-white/10">
        <div className="container-page flex flex-wrap items-center justify-center gap-4 py-6">
          <span className="text-[11px] font-semibold uppercase tracking-[0.2em] text-white/50">
            Yetkili Bayilik
          </span>
          {brands.map((b) => (
            <Link
              key={b.slug}
              href={`/urunler?marka=${b.slug}`}
              className="group flex h-10 w-24 items-center justify-center rounded bg-white/95 px-3 transition-all hover:bg-white hover:shadow-md"
              aria-label={b.name}
            >
              <div className="relative h-full w-full">
                <Image
                  src={b.logo}
                  alt={b.name}
                  fill
                  sizes="96px"
                  className="object-contain"
                />
              </div>
            </Link>
          ))}
        </div>
      </div>

      {/* Bottom bar */}
      <div>
        <div className="container-page py-5 text-center text-[11px] text-white/50">
          © {year} {site.legalName} — Tüm hakları saklıdır.
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

