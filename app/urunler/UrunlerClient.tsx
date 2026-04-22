"use client";

import { useRouter, useSearchParams } from "next/navigation";
import { useMemo, useCallback } from "react";
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

export default function UrunlerClient({
  products,
  brands,
  categories,
}: Props) {
  const router = useRouter();
  const searchParams = useSearchParams();

  const selectedBrand = searchParams.get("marka");
  const selectedCategory = searchParams.get("kategori");

  const filtered = useMemo(() => {
    return products.filter((p) => {
      if (selectedBrand && p.brand !== selectedBrand) return false;
      if (selectedCategory && p.category !== selectedCategory) return false;
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

  const activeFilter = selectedBrand || selectedCategory;

  return (
    <div className="grid gap-8 lg:grid-cols-[240px_1fr]">
      <aside className="space-y-6 lg:sticky lg:top-24 lg:self-start">
        <FilterGroup
          title="Markalar"
          options={brands.map((b) => ({ slug: b.slug, label: b.name }))}
          selected={selectedBrand}
          onSelect={(slug) =>
            updateParam("marka", slug === selectedBrand ? null : slug)
          }
        />
        <CategoryFilterGroup
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
            className="inline-flex w-full items-center justify-center gap-2 rounded-lg border border-[var(--color-border)] bg-white px-4 py-2 text-sm font-semibold text-[var(--color-ink)] transition-colors hover:border-[var(--color-brand)] hover:text-[var(--color-brand)]"
          >
            Filtreleri Temizle
          </button>
        )}
      </aside>

      <div>
        <div className="mb-4 flex flex-wrap items-center justify-between gap-3">
          <span className="text-sm text-[var(--color-ink-soft)]">
            {filtered.length} sonuç
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

        {filtered.length === 0 ? (
          <div className="rounded-xl border border-dashed border-[var(--color-border)] bg-white p-12 text-center">
            <div className="text-lg font-semibold text-[var(--color-ink)]">
              Sonuç bulunamadı
            </div>
            <p className="mt-2 text-sm text-[var(--color-ink-soft)]">
              Farklı bir marka veya kategori deneyin.
            </p>
            <button
              type="button"
              onClick={clearAll}
              className="mt-4 inline-flex items-center rounded-full bg-[var(--color-brand)] px-5 py-2 text-sm font-semibold text-white hover:bg-[var(--color-brand-dark)]"
            >
              Tüm ürünleri göster
            </button>
          </div>
        ) : (
          <ul className="grid grid-cols-2 gap-4 sm:grid-cols-3">
            {filtered.map((p) => (
              <li key={p.id}>
                <ProductCard product={p} />
              </li>
            ))}
          </ul>
        )}
      </div>
    </div>
  );
}

function FilterGroup({
  title,
  options,
  selected,
  onSelect,
}: {
  title: string;
  options: { slug: string; label: string }[];
  selected: string | null;
  onSelect: (slug: string) => void;
}) {
  return (
    <div className="rounded-xl border border-[var(--color-border)] bg-white p-4">
      <h3 className="mb-3 text-xs font-bold uppercase tracking-wider text-[var(--color-ink-muted)]">
        {title}
      </h3>
      <ul className="space-y-1">
        {options.map((o) => {
          const isSelected = selected === o.slug;
          return (
            <li key={o.slug}>
              <button
                type="button"
                onClick={() => onSelect(o.slug)}
                className={`flex w-full items-center justify-between rounded-md px-3 py-2 text-sm transition-colors ${
                  isSelected
                    ? "bg-[var(--color-brand)] text-white"
                    : "text-[var(--color-ink)] hover:bg-[var(--color-surface-alt)]"
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
  title,
  selected,
  onSelect,
}: {
  title: string;
  selected: string | null;
  onSelect: (slug: string) => void;
}) {
  return (
    <div className="rounded-xl border border-[var(--color-border)] bg-white p-4">
      <h3 className="mb-3 text-xs font-bold uppercase tracking-wider text-[var(--color-ink-muted)]">
        {title}
      </h3>
      <ul className="space-y-1">
        {allCategories.map((c) => {
          const isSelected = selected === c.slug;
          return (
            <li key={c.slug}>
              <button
                type="button"
                onClick={() => onSelect(c.slug)}
                className={`flex w-full items-center justify-between rounded-md px-3 py-2 text-sm transition-colors ${
                  isSelected
                    ? "bg-[var(--color-brand)] text-white"
                    : "text-[var(--color-ink)] hover:bg-[var(--color-surface-alt)]"
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
                    className={`ml-4 mt-0.5 flex w-[calc(100%-1rem)] items-center justify-between rounded-md px-3 py-1.5 text-xs transition-colors ${
                      subSelected
                        ? "bg-[var(--color-brand)] text-white"
                        : "text-[var(--color-ink-soft)] hover:bg-[var(--color-surface-alt)]"
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
      className="inline-flex items-center gap-1.5 rounded-full border border-[var(--color-border)] bg-white px-3 py-1 text-xs font-medium text-[var(--color-ink)] transition-colors hover:border-[var(--color-brand)] hover:text-[var(--color-brand)]"
    >
      {label}
      <XIcon />
    </button>
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
    >
      <line x1="6" y1="6" x2="18" y2="18" />
      <line x1="18" y1="6" x2="6" y2="18" />
    </svg>
  );
}
