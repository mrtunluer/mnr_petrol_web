"use client";

import Link from "next/link";
import { useEffect } from "react";

export default function GlobalError({
  error,
  reset,
}: {
  error: Error & { digest?: string };
  reset: () => void;
}) {
  useEffect(() => {
    // eslint-disable-next-line no-console
    console.error(error);
  }, [error]);

  return (
    <section className="bg-[var(--color-surface-alt)] py-24">
      <div className="container-page">
        <div className="grid gap-10 lg:grid-cols-12 lg:items-center">
          <div className="lg:col-span-6">
            <div className="font-mono text-xs text-[var(--color-ink-subtle)]">
              — 500
            </div>
            <div className="mt-2 text-[10px] font-bold uppercase tracking-[0.3em] text-[var(--color-brand)]">
              Beklenmeyen Hata
            </div>
            <h1 className="mt-3 text-4xl font-semibold tracking-tight text-[var(--color-ink)] sm:text-5xl">
              Bir şeyler ters gitti
            </h1>
            <p className="mt-4 max-w-md text-sm leading-relaxed text-[var(--color-ink-soft)]">
              İsteğinizi işlerken bir hata oluştu. Sayfayı yeniden yükleyebilir
              veya ana sayfaya dönebilirsiniz. Sorun devam ederse bizimle
              iletişime geçin.
            </p>
            <div className="mt-8 flex flex-wrap gap-3">
              <button
                type="button"
                onClick={reset}
                className="inline-flex items-center gap-2 bg-[var(--color-ink)] px-6 py-3 text-xs font-bold uppercase tracking-[0.22em] text-white transition-colors hover:bg-[var(--color-brand)]"
              >
                Tekrar Dene
              </button>
              <Link
                href="/"
                className="inline-flex items-center gap-2 border-b border-[var(--color-ink)] pb-1 text-xs font-semibold uppercase tracking-[0.22em] text-[var(--color-ink)] transition-colors hover:border-[var(--color-brand)] hover:text-[var(--color-brand)]"
              >
                Ana sayfaya dön →
              </Link>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}
