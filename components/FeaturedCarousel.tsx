"use client";

import { useCallback, useEffect, useRef, useState } from "react";
import ProductCard from "./ProductCard";
import type { Product } from "@/src/data/products";

type Props = { products: Product[] };

export default function FeaturedCarousel({ products }: Props) {
  const scrollerRef = useRef<HTMLUListElement | null>(null);
  const [atStart, setAtStart] = useState(true);
  const [atEnd, setAtEnd] = useState(false);

  const updateArrows = useCallback((): void => {
    const el = scrollerRef.current;
    if (!el) return;
    setAtStart(el.scrollLeft <= 4);
    setAtEnd(el.scrollLeft + el.clientWidth >= el.scrollWidth - 4);
  }, []);

  useEffect(() => {
    const el = scrollerRef.current;
    if (!el) return;
    updateArrows();
    el.addEventListener("scroll", updateArrows, { passive: true });
    const onResize = (): void => updateArrows();
    window.addEventListener("resize", onResize);
    return () => {
      el.removeEventListener("scroll", updateArrows);
      window.removeEventListener("resize", onResize);
    };
  }, [updateArrows]);

  const scrollByDir = (dir: 1 | -1): void => {
    const el = scrollerRef.current;
    if (!el) return;
    const step = Math.round(el.clientWidth * 0.8);
    el.scrollBy({ left: dir * step, behavior: "smooth" });
  };

  return (
    <div className="relative">
      <ul
        ref={scrollerRef}
        className="-mx-4 flex snap-x snap-mandatory gap-4 overflow-x-auto px-4 pb-4 [scrollbar-width:none] [&::-webkit-scrollbar]:hidden"
      >
        {products.map((p, i) => (
          <li
            key={p.id}
            className="min-w-[70%] shrink-0 snap-start sm:min-w-[45%] md:min-w-[32%] lg:min-w-[24%]"
          >
            <ProductCard product={p} priority={i < 4} />
          </li>
        ))}
      </ul>

      <ArrowButton
        direction="left"
        disabled={atStart}
        onClick={() => scrollByDir(-1)}
      />
      <ArrowButton
        direction="right"
        disabled={atEnd}
        onClick={() => scrollByDir(1)}
      />
    </div>
  );
}

function ArrowButton({
  direction,
  disabled,
  onClick,
}: {
  direction: "left" | "right";
  disabled: boolean;
  onClick: () => void;
}) {
  const isLeft = direction === "left";
  return (
    <button
      type="button"
      aria-label={isLeft ? "Önceki ürünler" : "Sonraki ürünler"}
      onClick={onClick}
      disabled={disabled}
      className={`absolute top-1/2 z-10 hidden h-11 w-11 -translate-y-1/2 items-center justify-center border border-[var(--color-ink)] bg-white text-[var(--color-ink)] transition-colors hover:bg-[var(--color-ink)] hover:text-white disabled:pointer-events-none disabled:opacity-0 md:flex ${
        isLeft ? "-left-4" : "-right-4"
      }`}
    >
      <svg
        width="18"
        height="18"
        viewBox="0 0 24 24"
        fill="none"
        stroke="currentColor"
        strokeWidth="2.5"
        strokeLinecap="round"
        strokeLinejoin="round"
        aria-hidden="true"
      >
        {isLeft ? (
          <polyline points="15 18 9 12 15 6" />
        ) : (
          <polyline points="9 18 15 12 9 6" />
        )}
      </svg>
    </button>
  );
}
