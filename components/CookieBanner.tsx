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
      className="fixed inset-x-3 bottom-[calc(env(safe-area-inset-bottom)+0.75rem)] z-30 animate-[slideUp_0.35s_cubic-bezier(0.16,1,0.3,1)_forwards] lg:inset-auto lg:bottom-6 lg:right-6 lg:max-w-md"
    >
      <div className="flex items-stretch overflow-hidden rounded-md bg-white shadow-[0_8px_24px_-4px_rgba(15,23,42,0.22)] ring-1 ring-[var(--color-border)]">
        <div className="flex-1 px-4 py-3 lg:px-5 lg:py-4">
          <p className="text-[12px] font-semibold leading-tight text-[var(--color-ink)] lg:text-sm">
            Çerez kullanımı
          </p>
          <p className="mt-0.5 text-[11px] leading-snug text-[var(--color-ink-soft)] lg:mt-1 lg:text-xs">
            Bu site yalnızca temel teknik çerezler kullanır.
          </p>
        </div>
        <button
          type="button"
          onClick={accept}
          aria-label="Çerez kullanımını kabul et"
          className="shrink-0 self-stretch bg-[var(--color-ink)] px-4 text-[11px] font-bold uppercase tracking-[0.16em] text-white transition-colors hover:bg-[var(--color-brand)] active:bg-[var(--color-brand)] lg:px-6 lg:text-xs"
        >
          Tamam
        </button>
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
