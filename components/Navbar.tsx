"use client";

import Link from "next/link";
import Image from "next/image";
import { usePathname } from "next/navigation";
import { useEffect, useRef, useState } from "react";
import { brands } from "@/src/data/brands";
import { categories } from "@/src/data/categories";
import { site } from "@/src/lib/site";

const primaryLinks = [
  { href: "/", label: "Ana Sayfa" },
  { href: "/hakkimizda", label: "Hakkımızda" },
] as const;

const MOBILE_PANEL_ID = "mobile-menu-panel";

export default function Navbar() {
  const pathname = usePathname();
  const [scrolled, setScrolled] = useState(false);
  const [mobileOpen, setMobileOpen] = useState(false);
  const [mobileSubmenuOpen, setMobileSubmenuOpen] = useState<string | null>(
    null,
  );
  const triggerRef = useRef<HTMLButtonElement>(null);
  const panelRef = useRef<HTMLElement>(null);
  const wasOpenRef = useRef(false);

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

  useEffect(() => {
    if (!mobileOpen) return;

    const body = document.body;
    const previousOverflow = body.style.overflow;
    const previousOverscroll = body.style.overscrollBehavior;
    body.style.overflow = "hidden";
    body.style.overscrollBehavior = "contain";

    const onKey = (e: KeyboardEvent) => {
      if (e.key === "Escape") setMobileOpen(false);
    };
    document.addEventListener("keydown", onKey);

    return () => {
      body.style.overflow = previousOverflow;
      body.style.overscrollBehavior = previousOverscroll;
      document.removeEventListener("keydown", onKey);
    };
  }, [mobileOpen]);

  useEffect(() => {
    if (wasOpenRef.current && !mobileOpen) {
      triggerRef.current?.focus();
    }
    if (mobileOpen && !wasOpenRef.current) {
      panelRef.current?.scrollTo(0, 0);
    }
    wasOpenRef.current = mobileOpen;
  }, [mobileOpen]);

  const isActive = (href: string) =>
    href === "/" ? pathname === "/" : pathname.startsWith(href);

  const closeAll = () => {
    setMobileOpen(false);
    setMobileSubmenuOpen(null);
  };

  return (
    <>
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
            ref={triggerRef}
            type="button"
            aria-label={mobileOpen ? "Menüyü kapat" : "Menüyü aç"}
            aria-expanded={mobileOpen}
            aria-controls={MOBILE_PANEL_ID}
            onClick={() => setMobileOpen((o) => !o)}
            className="inline-flex h-11 w-11 items-center justify-center rounded text-[var(--color-ink)] transition-colors hover:bg-[var(--color-surface-alt)] active:bg-[var(--color-border-soft)] md:hidden"
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
      </header>

      <div
        className={`fixed inset-0 z-[45] bg-[var(--color-night)]/40 transition-opacity duration-200 motion-reduce:transition-none md:hidden ${
          mobileOpen
            ? "pointer-events-auto opacity-100"
            : "pointer-events-none opacity-0"
        }`}
        aria-hidden="true"
        onClick={closeAll}
      />

      <nav
        ref={panelRef}
        id={MOBILE_PANEL_ID}
        aria-label="Mobil menü"
        aria-hidden={!mobileOpen}
        inert={!mobileOpen}
        className={`fixed inset-x-0 top-16 z-[45] max-h-[calc(100dvh-4rem)] overflow-y-auto overscroll-contain border-t border-[var(--color-border)] bg-white shadow-xl transition-transform duration-200 motion-reduce:transition-none md:hidden ${
          mobileOpen
            ? "translate-y-0"
            : "pointer-events-none -translate-y-full"
        }`}
      >
        <div
          className="container-page flex flex-col py-2"
          onClick={(e) => {
            if ((e.target as HTMLElement).closest("a")) {
              closeAll();
            }
          }}
        >
          {primaryLinks.map((link) => (
            <Link
              key={link.href}
              href={link.href}
              className={`flex min-h-[48px] items-center border-b border-[var(--color-border-soft)] text-sm font-medium transition-colors active:bg-[var(--color-surface-alt)] ${
                isActive(link.href)
                  ? "text-[var(--color-brand)]"
                  : "text-[var(--color-ink)]"
              }`}
            >
              {link.label}
            </Link>
          ))}

          <MobileCollapseItem
            label="Ürünler"
            panelId="mobile-submenu-products"
            open={mobileSubmenuOpen === "products"}
            onToggle={() =>
              setMobileSubmenuOpen((k) =>
                k === "products" ? null : "products",
              )
            }
            rootHref="/urunler"
            active={isActive("/urunler")}
          >
            {categories.map((c) => (
              <div key={c.slug}>
                <Link
                  href={`/urunler?kategori=${c.slug}`}
                  className="flex min-h-[44px] items-center gap-3 text-sm text-[var(--color-ink)] transition-colors hover:text-[var(--color-brand)] active:bg-[var(--color-surface-alt)]"
                >
                  <span className="relative h-7 w-7 shrink-0 overflow-hidden rounded-md bg-[var(--color-surface-alt)]">
                    <Image
                      src={c.icon}
                      alt=""
                      fill
                      sizes="28px"
                      className="object-cover"
                    />
                  </span>
                  <span className="flex-1">{c.name}</span>
                </Link>
                {c.subCategories?.map((sc) => (
                  <Link
                    key={sc.slug}
                    href={`/urunler?kategori=${sc.slug}`}
                    className="ml-10 flex min-h-[40px] items-center text-xs text-[var(--color-ink-soft)] transition-colors hover:text-[var(--color-brand)] active:bg-[var(--color-surface-alt)]"
                  >
                    → {sc.name}
                  </Link>
                ))}
              </div>
            ))}
          </MobileCollapseItem>

          <MobileCollapseItem
            label="Markalar"
            panelId="mobile-submenu-brands"
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
                className="flex min-h-[44px] items-center gap-3 text-sm text-[var(--color-ink)] transition-colors hover:text-[var(--color-brand)] active:bg-[var(--color-surface-alt)]"
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
            ))}
          </MobileCollapseItem>

          <Link
            href="/#iletisim"
            className="flex min-h-[48px] items-center text-sm font-medium text-[var(--color-ink)] transition-colors active:bg-[var(--color-surface-alt)]"
          >
            İletişim
          </Link>
        </div>
      </nav>
    </>
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
  const [open, setOpen] = useState(false);
  const ref = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (!open) return;
    const onPointer = (e: PointerEvent) => {
      if (!ref.current?.contains(e.target as Node)) setOpen(false);
    };
    const onKey = (e: KeyboardEvent) => {
      if (e.key === "Escape") setOpen(false);
    };
    document.addEventListener("pointerdown", onPointer);
    document.addEventListener("keydown", onKey);
    return () => {
      document.removeEventListener("pointerdown", onPointer);
      document.removeEventListener("keydown", onKey);
    };
  }, [open]);

  const onMouseEnter = (e: React.PointerEvent) => {
    if (e.pointerType === "mouse") setOpen(true);
  };
  const onMouseLeave = (e: React.PointerEvent) => {
    if (e.pointerType === "mouse") setOpen(false);
  };

  return (
    <div
      ref={ref}
      className="relative"
      onPointerEnter={onMouseEnter}
      onPointerLeave={onMouseLeave}
    >
      <button
        type="button"
        aria-haspopup="true"
        aria-expanded={open}
        aria-controls="desktop-brands-menu"
        onClick={() => setOpen((o) => !o)}
        className="flex items-center gap-1 px-3 py-2 text-sm font-medium transition-colors hover:text-[var(--color-brand)]"
      >
        Markalar
        <Chevron rotated={open} />
      </button>
      <div
        id="desktop-brands-menu"
        className={`absolute left-0 top-full z-40 min-w-[240px] rounded-lg border border-[var(--color-border)] bg-white shadow-lg transition-all duration-150 motion-reduce:transition-none ${
          open
            ? "visible translate-y-0 opacity-100"
            : "invisible translate-y-1 opacity-0"
        }`}
      >
        <ul className="py-1.5" onClick={() => setOpen(false)}>
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
  const [open, setOpen] = useState(false);
  const ref = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (!open) return;
    const onPointer = (e: PointerEvent) => {
      if (!ref.current?.contains(e.target as Node)) setOpen(false);
    };
    const onKey = (e: KeyboardEvent) => {
      if (e.key === "Escape") setOpen(false);
    };
    document.addEventListener("pointerdown", onPointer);
    document.addEventListener("keydown", onKey);
    return () => {
      document.removeEventListener("pointerdown", onPointer);
      document.removeEventListener("keydown", onKey);
    };
  }, [open]);

  const onMouseEnter = (e: React.PointerEvent) => {
    if (e.pointerType === "mouse") setOpen(true);
  };
  const onMouseLeave = (e: React.PointerEvent) => {
    if (e.pointerType === "mouse") setOpen(false);
  };

  return (
    <div
      ref={ref}
      className="relative flex items-center"
      onPointerEnter={onMouseEnter}
      onPointerLeave={onMouseLeave}
    >
      <Link
        href="/urunler"
        className={`px-3 py-2 text-sm font-medium transition-colors hover:text-[var(--color-brand)] ${
          active ? "text-[var(--color-brand)]" : "text-[var(--color-ink)]"
        }`}
      >
        Ürünler
      </Link>
      <button
        type="button"
        aria-haspopup="true"
        aria-expanded={open}
        aria-controls="desktop-products-menu"
        aria-label={open ? "Ürün menüsünü kapat" : "Ürün menüsünü aç"}
        onClick={() => setOpen((o) => !o)}
        className={`-ml-2 inline-flex h-9 w-7 items-center justify-center transition-colors hover:text-[var(--color-brand)] ${
          active ? "text-[var(--color-brand)]" : "text-[var(--color-ink)]"
        }`}
      >
        <Chevron rotated={open} />
      </button>
      <div
        id="desktop-products-menu"
        className={`absolute left-0 top-full z-40 min-w-[280px] rounded-lg border border-[var(--color-border)] bg-white shadow-lg transition-all duration-150 motion-reduce:transition-none ${
          open
            ? "visible translate-y-0 opacity-100"
            : "invisible translate-y-1 opacity-0"
        }`}
      >
        <ul className="py-1.5" onClick={() => setOpen(false)}>
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
                <div className="invisible absolute left-full top-0 z-50 ml-0.5 min-w-[220px] rounded-lg border border-[var(--color-border)] bg-white opacity-0 shadow-lg transition-all duration-150 group-hover/item:visible group-hover/item:opacity-100 motion-reduce:transition-none">
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
  active,
  panelId,
  children,
}: {
  label: string;
  open: boolean;
  onToggle: () => void;
  rootHref?: string;
  active?: boolean;
  panelId: string;
  children: React.ReactNode;
}) {
  const labelClass = `flex-1 text-sm font-medium transition-colors ${
    active ? "text-[var(--color-brand)]" : "text-[var(--color-ink)]"
  }`;

  return (
    <div className="border-b border-[var(--color-border-soft)] last:border-b-0">
      <div className="flex items-stretch">
        {rootHref ? (
          <>
            <Link
              href={rootHref}
              className={`flex min-h-[48px] flex-1 items-center text-sm font-medium transition-colors active:bg-[var(--color-surface-alt)] ${
                active
                  ? "text-[var(--color-brand)]"
                  : "text-[var(--color-ink)]"
              }`}
            >
              {label}
            </Link>
            <button
              type="button"
              aria-expanded={open}
              aria-controls={panelId}
              aria-label={`${label} alt menüsünü ${open ? "kapat" : "aç"}`}
              onClick={onToggle}
              className="inline-flex h-12 min-w-[44px] items-center justify-center px-3 text-[var(--color-ink-muted)] transition-colors hover:text-[var(--color-brand)] active:bg-[var(--color-surface-alt)]"
            >
              <Chevron rotated={open} />
            </button>
          </>
        ) : (
          <button
            type="button"
            aria-expanded={open}
            aria-controls={panelId}
            onClick={onToggle}
            className="flex min-h-[48px] w-full items-center justify-between text-left transition-colors active:bg-[var(--color-surface-alt)]"
          >
            <span className={labelClass}>{label}</span>
            <span className="inline-flex h-12 min-w-[44px] items-center justify-center px-3 text-[var(--color-ink-muted)]">
              <Chevron rotated={open} />
            </span>
          </button>
        )}
      </div>
      <div
        id={panelId}
        aria-hidden={!open}
        inert={!open}
        className={`grid transition-[grid-template-rows] duration-200 ease-out motion-reduce:transition-none ${
          open ? "grid-rows-[1fr]" : "grid-rows-[0fr]"
        }`}
      >
        <div className="overflow-hidden">
          <div className="pb-2 pl-3">{children}</div>
        </div>
      </div>
    </div>
  );
}

function Chevron({ rotated = false }: { rotated?: boolean }) {
  return (
    <svg
      width="14"
      height="14"
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth="2"
      strokeLinecap="round"
      strokeLinejoin="round"
      className={`transition-transform duration-150 motion-reduce:transition-none ${
        rotated ? "rotate-180" : ""
      }`}
      aria-hidden="true"
    >
      <polyline points="6 9 12 15 18 9" />
    </svg>
  );
}
