"use client";

import Image from "next/image";
import { useEffect, useState } from "react";
import { createPortal } from "react-dom";

type Props = {
  src: string;
  alt: string;
};

export default function ImageZoom({ src, alt }: Props) {
  const [open, setOpen] = useState(false);
  const [animateIn, setAnimateIn] = useState(false);

  useEffect(() => {
    if (!open) return;
    const t = requestAnimationFrame(() => setAnimateIn(true));
    const onKey = (e: KeyboardEvent): void => {
      if (e.key === "Escape") close();
    };
    document.body.style.overflow = "hidden";
    window.addEventListener("keydown", onKey);
    return () => {
      cancelAnimationFrame(t);
      document.body.style.overflow = "";
      window.removeEventListener("keydown", onKey);
    };
  }, [open]);

  function close(): void {
    setAnimateIn(false);
    window.setTimeout(() => setOpen(false), 280);
  }

  return (
    <>
      <button
        type="button"
        onClick={() => setOpen(true)}
        aria-label="Resmi büyüt"
        className="group relative block aspect-square w-full overflow-hidden border border-[var(--color-border)] bg-white transition-colors hover:border-[var(--color-ink)]"
      >
        <Image
          src={src}
          alt={alt}
          fill
          sizes="(max-width: 1024px) 100vw, 600px"
          priority
          className="object-contain p-8 transition-transform duration-500 ease-out group-hover:scale-[1.04]"
        />
        <span className="pointer-events-none absolute right-4 top-4 inline-flex items-center gap-1.5 bg-white px-2.5 py-1 text-[10px] font-semibold uppercase tracking-[0.18em] text-[var(--color-ink)] opacity-0 ring-1 ring-[var(--color-border)] transition-opacity duration-200 group-hover:opacity-100">
          <ZoomIcon />
          Büyüt
        </span>
      </button>

      {open && typeof document !== "undefined"
        ? createPortal(
            <div
              role="dialog"
              aria-modal="true"
              aria-label={alt}
              onClick={close}
              className={`fixed inset-0 z-[100] flex items-center justify-center bg-black/95 p-4 backdrop-blur-sm transition-opacity duration-300 sm:p-10 ${
                animateIn ? "opacity-100" : "opacity-0"
              }`}
            >
              <button
                type="button"
                aria-label="Kapat"
                onClick={close}
                className="absolute right-6 top-6 inline-flex items-center gap-2 border border-white/40 bg-white/10 px-4 py-2 text-xs font-semibold uppercase tracking-[0.18em] text-white backdrop-blur-sm transition-colors hover:bg-white hover:text-[var(--color-ink)]"
              >
                Kapat
                <XIcon />
              </button>
              <div
                onClick={(e) => e.stopPropagation()}
                className={`relative max-h-[85vh] w-full max-w-5xl overflow-hidden bg-white p-4 transition-all duration-300 sm:p-6 ${
                  animateIn ? "scale-100 opacity-100" : "scale-95 opacity-0"
                }`}
                style={{ transitionTimingFunction: "cubic-bezier(0.16, 1, 0.3, 1)" }}
              >
                <Image
                  src={src}
                  alt={alt}
                  width={1600}
                  height={1600}
                  sizes="90vw"
                  className="h-auto max-h-[80vh] w-full object-contain"
                />
              </div>
            </div>,
            document.body,
          )
        : null}
    </>
  );
}

function ZoomIcon() {
  return (
    <svg
      width="18"
      height="18"
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth="2"
      strokeLinecap="round"
      strokeLinejoin="round"
      aria-hidden="true"
    >
      <circle cx="11" cy="11" r="8" />
      <line x1="21" y1="21" x2="16.65" y2="16.65" />
      <line x1="11" y1="8" x2="11" y2="14" />
      <line x1="8" y1="11" x2="14" y2="11" />
    </svg>
  );
}

function XIcon() {
  return (
    <svg
      width="20"
      height="20"
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth="2"
      strokeLinecap="round"
      aria-hidden="true"
    >
      <line x1="6" y1="6" x2="18" y2="18" />
      <line x1="18" y1="6" x2="6" y2="18" />
    </svg>
  );
}
