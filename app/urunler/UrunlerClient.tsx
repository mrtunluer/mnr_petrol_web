"use client";

import { useRouter, useSearchParams } from "next/navigation";
import { useMemo, useCallback, useState, useEffect } from "react";
import ProductCard from "@/components/ProductCard";
import type { Product } from "@/src/data/products";
import type { Brand } from "@/src/data/brands";
import { categories as allCategories, type Category } from "@/src/data/categories";

type Props = {
  products: Product[];
  brands: Brand[];
  categories: Category[];
};

function categoryLabel(slug: string): string {
  for (const c of allCategories) {
    if (c.slug === slug) return c.name;
    const sc = c.subCategories?.find((x) => x.slug === slug);
    if (sc) return sc.name;
  }
  return slug;
}

function categoryMatches(productCategory: string, selected: string): boolean {
  if (productCategory === selected) return true;
  const parent = allCategories.find((c) => c.slug === selected);
  if (parent?.subCategories) {
    return parent.subCategories.some((sc) => sc.slug === productCategory);
  }
  return false;
}

export default function UrunlerClient({
  products,
  brands,
}: Props) {
  const router = useRouter();
  const searchParams = useSearchParams();
  const [filtersOpen, setFiltersOpen] = useState(false);

  const selectedBrand = searchParams.get("marka");
  const selectedCategory = searchParams.get("kategori");

  const filtered = useMemo(() => {
    return products.filter((p) => {
      if (selectedBrand && p.brand !== selectedBrand) return false;
      if (selectedCategory && !categoryMatches(p.category, selectedCategory))
        return false;
      return true;
    });
  }, [products, selectedBrand, selectedCategory]);

  const updateParam = useCallback(
    (key: "marka" | "kategori", value: string | null) => {
      const params = new URLSearchParams(searchParams.toString());
      if (value) params.set(key, value);
      else params.delete(key);
      const query = params.toString();
      router.replace(query ? `/urunler?${query}` : "/urunler", {
        scroll: false,
      });
    },
    [router, searchParams],
  );

  const clearAll = useCallback(() => {
    router.replace("/urunler", { scroll: false });
  }, [router]);

  useEffect(() => {
    if (!filtersOpen) return;
    document.body.style.overflow = "hidden";
    const onKey = (e: KeyboardEvent): void => {
      if (e.key === "Escape") setFiltersOpen(false);
    };
    window.addEventListener("keydown", onKey);
    return () => {
      document.body.style.overflow = "";
      window.removeEventListener("keydown", onKey);
    };
  }, [filtersOpen]);

  const activeFilter = selectedBrand || selectedCategory;
  const activeCount =
    (selectedBrand ? 1 : 0) + (selectedCategory ? 1 : 0);

  const filterPanel = (
    <div className="space-y-4">
      <FilterGroup
        num="01"
        title="Markalar"
        options={brands.map((b) => ({ slug: b.slug, label: b.name }))}
        selected={selectedBrand}
        onSelect={(slug) =>
          updateParam("marka", slug === selectedBrand ? null : slug)
        }
      />
      <CategoryFilterGroup
        num="02"
        title="Kategoriler"
        selected={selectedCategory}
        onSelect={(slug) =>
          updateParam("kategori", slug === selectedCategory ? null : slug)
        }
      />
      {activeFilter && (
        <button
          type="button"
          onClick={clearAll}
          className="inline-flex w-full items-center justify-center gap-2 border border-[var(--color-ink)] bg-white px-4 py-3 text-xs font-semibold uppercase tracking-[0.18em] text-[var(--color-ink)] transition-colors hover:bg-[var(--color-ink)] hover:text-white"
        >
          Filtreleri Temizle
        </button>
      )}
    </div>
  );

  return (
    <div className="grid gap-8 lg:grid-cols-[240px_1fr]">
      {/* Desktop sidebar */}
      <aside className="hidden lg:sticky lg:top-24 lg:block lg:self-start">
        {filterPanel}
      </aside>

      <div>
        {/* Mobile filter trigger + result count row */}
        <div className="mb-5 flex items-stretch gap-2 lg:hidden">
          <button
            type="button"
            onClick={() => setFiltersOpen(true)}
            className="flex flex-1 items-center justify-between border border-[var(--color-ink)] bg-white px-4 py-3 text-xs font-semibold uppercase tracking-[0.18em] text-[var(--color-ink)]"
            aria-label="Filtreleri aç"
          >
            <span className="flex items-center gap-2">
              <FilterIcon />
              Filtrele
              {activeCount > 0 && (
                <span className="inline-flex h-5 min-w-5 items-center justify-center bg-[var(--color-brand)] px-1 font-mono text-[10px] text-white">
                  {activeCount}
                </span>
              )}
            </span>
            <span className="font-mono text-[11px] text-[var(--color-ink-muted)]">
              {filtered.length} ürün
            </span>
          </button>
        </div>

        {/* Desktop result count + active chips */}
        <div className="mb-4 hidden flex-wrap items-center justify-between gap-3 lg:flex">
          <span className="text-sm text-[var(--color-ink-muted)]">
            <span className="font-mono text-xs text-[var(--color-ink-subtle)]">
              —{" "}
            </span>
            <span className="font-semibold text-[var(--color-ink)]">
              {filtered.length}
            </span>{" "}
            sonuç
          </span>
          {activeFilter && (
            <div className="flex flex-wrap gap-2">
              {selectedBrand && (
                <FilterChip
                  label={brands.find((b) => b.slug === selectedBrand)?.name ?? selectedBrand}
                  onRemove={() => updateParam("marka", null)}
                />
              )}
              {selectedCategory && (
                <FilterChip
                  label={categoryLabel(selectedCategory)}
                  onRemove={() => updateParam("kategori", null)}
                />
              )}
            </div>
          )}
        </div>

        {/* Mobile active chips row */}
        {activeFilter && (
          <div className="mb-4 flex flex-wrap gap-2 lg:hidden">
            {selectedBrand && (
              <FilterChip
                label={brands.find((b) => b.slug === selectedBrand)?.name ?? selectedBrand}
                onRemove={() => updateParam("marka", null)}
              />
            )}
            {selectedCategory && (
              <FilterChip
                label={categoryLabel(selectedCategory)}
                onRemove={() => updateParam("kategori", null)}
              />
            )}
          </div>
        )}

        {filtered.length === 0 ? (
          <div className="border border-[var(--color-border)] bg-white p-8 sm:p-12">
            <div className="font-mono text-xs text-[var(--color-ink-subtle)]">
              — Sonuç yok
            </div>
            <div className="mt-2 text-xl font-semibold tracking-tight text-[var(--color-ink)]">
              Bu filtreyle eşleşen ürün bulunamadı
            </div>
            <p className="mt-2 max-w-md text-sm text-[var(--color-ink-soft)]">
              Farklı bir marka veya kategori deneyin, ya da tüm kataloğa dönün.
            </p>
            <button
              type="button"
              onClick={clearAll}
              className="mt-6 inline-flex items-center gap-2 border border-[var(--color-ink)] bg-white px-5 py-3 text-xs font-semibold uppercase tracking-[0.18em] text-[var(--color-ink)] transition-colors hover:bg-[var(--color-ink)] hover:text-white"
            >
              Filtreleri temizle
            </button>
          </div>
        ) : (
          <ul className="grid grid-cols-2 gap-3 sm:grid-cols-3 sm:gap-4">
            {filtered.map((p) => (
              <li key={p.id}>
                <ProductCard product={p} />
              </li>
            ))}
          </ul>
        )}
      </div>

      {/* Mobile filter drawer (bottom sheet) */}
      {filtersOpen && (
        <div
          role="dialog"
          aria-modal="true"
          aria-label="Filtreler"
          className="fixed inset-0 z-50 lg:hidden"
        >
          <div
            onClick={() => setFiltersOpen(false)}
            className="absolute inset-0 bg-black/60"
            aria-hidden="true"
          />
          <div className="absolute inset-x-0 bottom-0 flex max-h-[88vh] flex-col bg-[var(--color-surface-alt)]">
            <div className="flex items-center justify-between border-b border-[var(--color-border)] bg-white px-5 py-4">
              <div>
                <div className="font-mono text-xs text-[var(--color-ink-subtle)]">
                  — Filtre
                </div>
                <div className="mt-0.5 text-sm font-semibold uppercase tracking-[0.18em] text-[var(--color-ink)]">
                  Ürünleri Süz
                </div>
              </div>
              <button
                type="button"
                onClick={() => setFiltersOpen(false)}
                aria-label="Kapat"
                className="flex h-10 w-10 items-center justify-center border border-[var(--color-border)] bg-white text-[var(--color-ink)] transition-colors hover:bg-[var(--color-ink)] hover:text-white"
              >
                <XIcon />
              </button>
            </div>

            <div className="flex-1 overflow-y-auto p-5">{filterPanel}</div>

            <div className="border-t border-[var(--color-border)] bg-white p-3">
              <button
                type="button"
                onClick={() => setFiltersOpen(false)}
                className="flex w-full items-center justify-center gap-2 bg-[var(--color-brand)] px-6 py-3.5 text-xs font-bold uppercase tracking-[0.22em] text-white transition-colors hover:bg-[var(--color-brand-dark)]"
              >
                {filtered.length} ürünü göster
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}

function FilterGroup({
  num,
  title,
  options,
  selected,
  onSelect,
}: {
  num: string;
  title: string;
  options: { slug: string; label: string }[];
  selected: string | null;
  onSelect: (slug: string) => void;
}) {
  return (
    <div className="border border-[var(--color-border)] bg-white">
      <div className="flex items-center gap-2 border-b border-[var(--color-border)] px-4 py-3">
        <span className="font-mono text-xs font-medium text-[var(--color-ink-subtle)]">
          — {num}
        </span>
        <span className="text-[10px] font-semibold uppercase tracking-[0.22em] text-[var(--color-ink-muted)]">
          {title}
        </span>
      </div>
      <ul className="py-1">
        {options.map((o) => {
          const isSelected = selected === o.slug;
          return (
            <li key={o.slug}>
              <button
                type="button"
                onClick={() => onSelect(o.slug)}
                className={`flex w-full items-center justify-between px-4 py-2 text-sm transition-colors ${
                  isSelected
                    ? "bg-[var(--color-ink)] text-white"
                    : "text-[var(--color-ink-soft)] hover:bg-[var(--color-surface-alt)] hover:text-[var(--color-ink)]"
                }`}
              >
                <span>{o.label}</span>
                {isSelected && <XIcon />}
              </button>
            </li>
          );
        })}
      </ul>
    </div>
  );
}

function CategoryFilterGroup({
  num,
  title,
  selected,
  onSelect,
}: {
  num: string;
  title: string;
  selected: string | null;
  onSelect: (slug: string) => void;
}) {
  return (
    <div className="border border-[var(--color-border)] bg-white">
      <div className="flex items-center gap-2 border-b border-[var(--color-border)] px-4 py-3">
        <span className="font-mono text-xs font-medium text-[var(--color-ink-subtle)]">
          — {num}
        </span>
        <span className="text-[10px] font-semibold uppercase tracking-[0.22em] text-[var(--color-ink-muted)]">
          {title}
        </span>
      </div>
      <ul className="py-1">
        {allCategories.map((c) => {
          const isSelected = selected === c.slug;
          return (
            <li key={c.slug}>
              <button
                type="button"
                onClick={() => onSelect(c.slug)}
                className={`flex w-full items-center justify-between px-4 py-2 text-sm transition-colors ${
                  isSelected
                    ? "bg-[var(--color-ink)] text-white"
                    : "text-[var(--color-ink-soft)] hover:bg-[var(--color-surface-alt)] hover:text-[var(--color-ink)]"
                }`}
              >
                <span>{c.name}</span>
                {isSelected && <XIcon />}
              </button>
              {c.subCategories?.map((sc) => {
                const subSelected = selected === sc.slug;
                return (
                  <button
                    key={sc.slug}
                    type="button"
                    onClick={() => onSelect(sc.slug)}
                    className={`flex w-full items-center justify-between border-t border-[var(--color-border-soft)] py-1.5 pl-8 pr-4 text-xs transition-colors ${
                      subSelected
                        ? "bg-[var(--color-ink)] text-white"
                        : "text-[var(--color-ink-muted)] hover:bg-[var(--color-surface-alt)]"
                    }`}
                  >
                    <span>→ {sc.name}</span>
                    {subSelected && <XIcon />}
                  </button>
                );
              })}
            </li>
          );
        })}
      </ul>
    </div>
  );
}

function FilterChip({
  label,
  onRemove,
}: {
  label: string;
  onRemove: () => void;
}) {
  return (
    <button
      type="button"
      onClick={onRemove}
      className="inline-flex items-center gap-1.5 border border-[var(--color-ink)] bg-[var(--color-ink)] px-3 py-1 text-xs font-semibold uppercase tracking-[0.12em] text-white transition-colors hover:bg-[var(--color-brand)] hover:border-[var(--color-brand)]"
    >
      {label}
      <XIcon />
    </button>
  );
}

function FilterIcon() {
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
      aria-hidden="true"
    >
      <polygon points="22 3 2 3 10 12.46 10 19 14 21 14 12.46 22 3" />
    </svg>
  );
}

function XIcon() {
  return (
    <svg
      width="12"
      height="12"
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth="2.5"
      strokeLinecap="round"
      aria-hidden="true"
    >
      <line x1="6" y1="6" x2="18" y2="18" />
      <line x1="18" y1="6" x2="6" y2="18" />
    </svg>
  );
}
