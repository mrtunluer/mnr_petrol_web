"use client";

import { useEffect, useState } from "react";

const STORAGE_KEY = "mnr-cookie-consent";

export default function CookieBanner() {
  const [visible, setVisible] = useState(false);
  const [mounted, setMounted] = useState(false);

  useEffect(() => {
    setMounted(true);
    try {
      if (window.localStorage.getItem(STORAGE_KEY) !== "accepted") {
        setVisible(true);
      }
    } catch {
      setVisible(true);
    }
  }, []);

  function accept(): void {
    try {
      window.localStorage.setItem(STORAGE_KEY, "accepted");
    } catch {
      /* localStorage disabled */
    }
    setVisible(false);
  }

  if (!mounted || !visible) return null;

  return (
    <div
      role="dialog"
      aria-label="Çerez kullanım bildirimi"
      className="fixed inset-x-3 bottom-[calc(env(safe-area-inset-bottom)+1rem)] z-30 animate-[slideUp_0.35s_cubic-bezier(0.16,1,0.3,1)_forwards] lg:inset-auto lg:bottom-6 lg:right-6 lg:max-w-md"
    >
      <div className="border border-[var(--color-ink)] bg-white shadow-[0_20px_50px_-10px_rgba(15,23,42,0.3)]">
        <div className="border-b border-[var(--color-border)] px-4 pt-4 pb-3 lg:px-6 lg:pt-5 lg:pb-4">
          <div className="flex items-center gap-3">
            <CookieIcon />
            <div>
              <div className="font-mono text-[11px] text-[var(--color-ink-subtle)]">
                — Çerezler
              </div>
              <div className="mt-0.5 text-[13px] font-semibold uppercase tracking-[0.16em] text-[var(--color-ink)] lg:text-sm lg:tracking-[0.18em]">
                Çerez kullanımı
              </div>
            </div>
          </div>
        </div>
        <div className="px-4 py-4 lg:px-6 lg:py-5">
          <p className="text-[13px] leading-relaxed text-[var(--color-ink-soft)] lg:text-sm">
            Bu site, deneyiminizi iyileştirmek için temel teknik çerezler
            kullanır. Takip veya reklam amaçlı üçüncü taraf çerezi
            kullanmıyoruz.
          </p>
        </div>
        <div className="flex border-t border-[var(--color-border)]">
          <button
            type="button"
            onClick={accept}
            className="flex min-h-[48px] flex-1 items-center justify-center gap-2 bg-[var(--color-ink)] px-5 py-3 text-xs font-bold uppercase tracking-[0.22em] text-white transition-colors hover:bg-[var(--color-brand)] active:bg-[var(--color-brand)]"
          >
            Anladım
            <svg
              width="12"
              height="12"
              viewBox="0 0 24 24"
              fill="none"
              stroke="currentColor"
              strokeWidth="2.5"
              strokeLinecap="round"
              strokeLinejoin="round"
              aria-hidden="true"
            >
              <polyline points="20 6 9 17 4 12" />
            </svg>
          </button>
        </div>
      </div>

      <style>{`
        @keyframes slideUp {
          from { opacity: 0; transform: translateY(20px); }
          to { opacity: 1; transform: translateY(0); }
        }
      `}</style>
    </div>
  );
}

function CookieIcon() {
  return (
    <span
      aria-hidden="true"
      className="flex h-9 w-9 shrink-0 items-center justify-center border border-[var(--color-border)] bg-[var(--color-surface-alt)] text-[var(--color-brand)]"
    >
      <svg
        width="16"
        height="16"
        viewBox="0 0 24 24"
        fill="none"
        stroke="currentColor"
        strokeWidth="2"
        strokeLinecap="round"
        strokeLinejoin="round"
      >
        <path d="M21 12c0 5.25-4.5 9-9.5 9C6 21 3 16.5 3 12c0-5.5 4-9 9-9a7 7 0 0 0 9 9z" />
        <circle cx="8.5" cy="10.5" r="0.8" fill="currentColor" />
        <circle cx="13" cy="14.5" r="0.8" fill="currentColor" />
        <circle cx="16" cy="9" r="0.8" fill="currentColor" />
      </svg>
    </span>
  );
}
