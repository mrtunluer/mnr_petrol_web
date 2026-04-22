"use client";

import Link from "next/link";
import Image from "next/image";
import { usePathname } from "next/navigation";
import { useEffect, useState } from "react";
import { brands } from "@/src/data/brands";
import { categories } from "@/src/data/categories";
import { site } from "@/src/lib/site";

const primaryLinks = [
  { href: "/", label: "Ana Sayfa" },
  { href: "/hakkimizda", label: "Hakkımızda" },
] as const;

export default function Navbar() {
  const pathname = usePathname();
  const [scrolled, setScrolled] = useState(false);
  const [mobileOpen, setMobileOpen] = useState(false);
  const [mobileSubmenuOpen, setMobileSubmenuOpen] = useState<string | null>(
    null,
  );

  useEffect(() => {
    const onScroll = () => setScrolled(window.scrollY > 8);
    onScroll();
    window.addEventListener("scroll", onScroll, { passive: true });
    return () => window.removeEventListener("scroll", onScroll);
  }, []);

  useEffect(() => {
    setMobileOpen(false);
    setMobileSubmenuOpen(null);
  }, [pathname]);

  const isActive = (href: string) =>
    href === "/" ? pathname === "/" : pathname.startsWith(href);

  return (
    <header
      className={`sticky top-0 z-50 bg-white transition-shadow ${
        scrolled ? "shadow-md" : "shadow-sm"
      }`}
    >
      <div className="container-page flex h-16 items-center justify-between gap-4">
        <Link href="/" className="flex items-center gap-3">
          <Image
            src="/logo.webp"
            alt="MNR Petrol"
            width={140}
            height={40}
            priority
            className="h-9 w-auto"
          />
          <span className="hidden flex-col leading-tight sm:flex">
            <span className="text-[13px] font-bold tracking-tight text-[var(--color-ink)]">
              {site.legalName}
            </span>
            <span className="text-[11px] font-medium uppercase tracking-wider text-[var(--color-ink-muted)]">
              {site.tagline}
            </span>
          </span>
        </Link>

        <nav className="hidden items-center gap-0.5 md:flex">
          {primaryLinks.map((link) => (
            <NavLink
              key={link.href}
              href={link.href}
              label={link.label}
              active={isActive(link.href)}
            />
          ))}

          <ProductsDropdown active={isActive("/urunler")} />

          <BrandsDropdown />

          <NavLink href="/#iletisim" label="İletişim" active={false} />
        </nav>

        <button
          type="button"
          aria-label="Menüyü aç"
          aria-expanded={mobileOpen}
          onClick={() => setMobileOpen((o) => !o)}
          className="inline-flex h-10 w-10 items-center justify-center rounded md:hidden"
        >
          <svg
            width="22"
            height="22"
            viewBox="0 0 24 24"
            fill="none"
            stroke="currentColor"
            strokeWidth="2"
            strokeLinecap="round"
            aria-hidden="true"
          >
            {mobileOpen ? (
              <>
                <line x1="6" y1="6" x2="18" y2="18" />
                <line x1="6" y1="18" x2="18" y2="6" />
              </>
            ) : (
              <>
                <line x1="4" y1="7" x2="20" y2="7" />
                <line x1="4" y1="12" x2="20" y2="12" />
                <line x1="4" y1="17" x2="20" y2="17" />
              </>
            )}
          </svg>
        </button>
      </div>

      {mobileOpen && (
        <div className="border-t border-[var(--color-border)] bg-white md:hidden">
          <div className="container-page flex flex-col py-3">
            {primaryLinks.map((link) => (
              <Link
                key={link.href}
                href={link.href}
                className="py-2 text-sm font-medium"
              >
                {link.label}
              </Link>
            ))}

            <MobileCollapseItem
              label="Ürünler"
              open={mobileSubmenuOpen === "products"}
              onToggle={() =>
                setMobileSubmenuOpen((k) =>
                  k === "products" ? null : "products",
                )
              }
              rootHref="/urunler"
            >
              {categories.map((c) => (
                <div key={c.slug}>
                  <Link
                    href={`/urunler?kategori=${c.slug}`}
                    className="block py-1.5 text-sm"
                  >
                    {c.name}
                  </Link>
                  {c.subCategories?.map((sc) => (
                    <Link
                      key={sc.slug}
                      href={`/urunler?kategori=${sc.slug}`}
                      className="ml-4 block py-1 text-xs text-[var(--color-ink-soft)]"
                    >
                      → {sc.name}
                    </Link>
                  ))}
                </div>
              ))}
            </MobileCollapseItem>

            <MobileCollapseItem
              label="Markalar"
              open={mobileSubmenuOpen === "brands"}
              onToggle={() =>
                setMobileSubmenuOpen((k) =>
                  k === "brands" ? null : "brands",
                )
              }
            >
              {brands.map((b) => (
                <Link
                  key={b.slug}
                  href={`/urunler?marka=${b.slug}`}
                  className="block py-1.5 text-sm"
                >
                  {b.name}
                </Link>
              ))}
            </MobileCollapseItem>

            <Link
              href="/#iletisim"
              className="py-2 text-sm font-medium"
            >
              İletişim
            </Link>
          </div>
        </div>
      )}
    </header>
  );
}

function NavLink({
  href,
  label,
  active,
}: {
  href: string;
  label: string;
  active: boolean;
}) {
  return (
    <Link
      href={href}
      className={`relative px-3 py-2 text-sm font-medium transition-colors hover:text-[var(--color-brand)] ${
        active ? "text-[var(--color-brand)]" : "text-[var(--color-ink)]"
      }`}
    >
      {label}
      {active && (
        <span className="absolute inset-x-3 -bottom-0.5 h-0.5 rounded bg-[var(--color-brand)]" />
      )}
    </Link>
  );
}

function BrandsDropdown() {
  return (
    <div className="group relative">
      <button
        type="button"
        className="flex items-center gap-1 px-3 py-2 text-sm font-medium transition-colors hover:text-[var(--color-brand)]"
      >
        Markalar
        <Chevron />
      </button>
      <div className="invisible absolute left-0 top-full z-40 min-w-[240px] translate-y-1 rounded-lg border border-[var(--color-border)] bg-white opacity-0 shadow-lg transition-all duration-150 group-hover:visible group-hover:translate-y-0 group-hover:opacity-100">
        <ul className="py-1.5">
          {brands.map((b) => (
            <li key={b.slug}>
              <Link
                href={`/urunler?marka=${b.slug}`}
                className="flex items-center gap-3 px-4 py-2 text-sm text-[var(--color-ink)] transition-colors hover:bg-[var(--color-surface-alt)] hover:text-[var(--color-brand)]"
              >
                <span className="relative h-7 w-10 shrink-0 overflow-hidden rounded bg-white ring-1 ring-[var(--color-border)]">
                  <Image
                    src={b.logo}
                    alt=""
                    fill
                    sizes="40px"
                    className="object-contain p-0.5"
                  />
                </span>
                <span className="flex-1">{b.name}</span>
              </Link>
            </li>
          ))}
        </ul>
      </div>
    </div>
  );
}

function ProductsDropdown({ active }: { active: boolean }) {
  return (
    <div className="group relative">
      <Link
        href="/urunler"
        className={`flex items-center gap-1 px-3 py-2 text-sm font-medium transition-colors hover:text-[var(--color-brand)] ${
          active ? "text-[var(--color-brand)]" : "text-[var(--color-ink)]"
        }`}
      >
        Ürünler
        <Chevron />
      </Link>
      <div className="invisible absolute left-0 top-full z-40 min-w-[280px] translate-y-1 rounded-lg border border-[var(--color-border)] bg-white opacity-0 shadow-lg transition-all duration-150 group-hover:visible group-hover:translate-y-0 group-hover:opacity-100">
        <ul className="py-1.5">
          {categories.map((c) => (
            <li key={c.slug} className="group/item relative">
              <Link
                href={`/urunler?kategori=${c.slug}`}
                className="flex items-center gap-3 px-4 py-2 text-sm text-[var(--color-ink)] transition-colors hover:bg-[var(--color-surface-alt)] hover:text-[var(--color-brand)]"
              >
                <span className="relative h-8 w-8 shrink-0 overflow-hidden rounded-md bg-[var(--color-surface-alt)]">
                  <Image
                    src={c.icon}
                    alt=""
                    fill
                    sizes="32px"
                    className="object-cover"
                  />
                </span>
                <span className="flex-1">{c.name}</span>
                {c.subCategories && c.subCategories.length > 0 && (
                  <span className="text-[var(--color-ink-muted)]">›</span>
                )}
              </Link>
              {c.subCategories && c.subCategories.length > 0 && (
                <div className="invisible absolute left-full top-0 z-50 ml-0.5 min-w-[220px] rounded-lg border border-[var(--color-border)] bg-white opacity-0 shadow-lg transition-all duration-150 group-hover/item:visible group-hover/item:opacity-100">
                  <ul className="py-1">
                    {c.subCategories.map((sc) => (
                      <li key={sc.slug}>
                        <Link
                          href={`/urunler?kategori=${sc.slug}`}
                          className="block px-4 py-2 text-sm text-[var(--color-ink)] transition-colors hover:bg-[var(--color-surface-alt)] hover:text-[var(--color-brand)]"
                        >
                          {sc.name}
                        </Link>
                      </li>
                    ))}
                  </ul>
                </div>
              )}
            </li>
          ))}
        </ul>
      </div>
    </div>
  );
}

function MobileCollapseItem({
  label,
  open,
  onToggle,
  rootHref,
  children,
}: {
  label: string;
  open: boolean;
  onToggle: () => void;
  rootHref?: string;
  children: React.ReactNode;
}) {
  return (
    <div className="border-b border-[var(--color-border)] last:border-b-0">
      <div className="flex items-center justify-between">
        {rootHref ? (
          <Link href={rootHref} className="py-2 text-sm font-medium">
            {label}
          </Link>
        ) : (
          <span className="py-2 text-sm font-medium">{label}</span>
        )}
        <button
          type="button"
          aria-expanded={open}
          aria-label={`${label} alt menüsünü ${open ? "kapat" : "aç"}`}
          onClick={onToggle}
          className="p-2"
        >
          <svg
            width="14"
            height="14"
            viewBox="0 0 24 24"
            fill="none"
            stroke="currentColor"
            strokeWidth="2"
            strokeLinecap="round"
            strokeLinejoin="round"
            className={`transition-transform ${open ? "rotate-180" : ""}`}
            aria-hidden="true"
          >
            <polyline points="6 9 12 15 18 9" />
          </svg>
        </button>
      </div>
      {open && <div className="pb-2 pl-3">{children}</div>}
    </div>
  );
}

function Chevron() {
  return (
    <svg
      width="12"
      height="12"
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth="2"
      strokeLinecap="round"
      strokeLinejoin="round"
      aria-hidden="true"
    >
      <polyline points="6 9 12 15 18 9" />
    </svg>
  );
}
