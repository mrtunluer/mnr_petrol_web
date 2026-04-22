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
        className="group relative block aspect-square w-full overflow-hidden rounded-2xl bg-white ring-1 ring-[var(--color-border)] transition-shadow hover:shadow-xl"
      >
        <Image
          src={src}
          alt={alt}
          fill
          sizes="(max-width: 1024px) 100vw, 600px"
          priority
          className="object-contain p-6 transition-transform duration-300 ease-out group-hover:scale-[1.04]"
        />
        <span className="pointer-events-none absolute right-4 top-4 flex h-10 w-10 items-center justify-center rounded-full bg-white/95 text-[var(--color-ink)] shadow-md opacity-0 transition-opacity duration-200 group-hover:opacity-100">
          <ZoomIcon />
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
                className="absolute right-6 top-6 flex h-11 w-11 items-center justify-center rounded-full bg-white/10 text-white shadow-lg shadow-black/40 transition-colors hover:bg-white/20"
              >
                <XIcon />
              </button>
              <div
                onClick={(e) => e.stopPropagation()}
                className={`relative max-h-[85vh] w-full max-w-5xl overflow-hidden rounded-xl bg-white p-4 shadow-2xl transition-all duration-300 sm:rounded-2xl sm:p-6 ${
                  animateIn ? "scale-100 opacity-100" : "scale-90 opacity-0"
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
