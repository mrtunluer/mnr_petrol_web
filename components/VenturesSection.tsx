import Image from "next/image";
import Link from "next/link";
import { ventures } from "@/src/data/ventures";

export default function VenturesSection() {
  return (
    <section
      id="yazilim"
      className="scroll-mt-16 border-t border-[var(--color-border)] bg-[var(--color-surface-alt)] py-14 sm:py-20 lg:py-24"
    >
      <div className="container-page">
        <div className="flex flex-col items-start justify-between gap-4 border-b border-[var(--color-border)] pb-8 md:flex-row md:items-end">
          <div>
            <div className="text-[10px] font-bold uppercase tracking-[0.3em] text-[var(--color-brand)]">
              Yazılım Çözümlerimiz
            </div>
            <h2 className="mt-2 text-3xl font-bold tracking-tight text-[var(--color-ink)] sm:text-4xl">
              Grup bünyesindeki dijital platformlar
            </h2>
          </div>
          <Link
            href="/yazilim"
            className="group inline-flex items-center gap-2 text-[11px] font-bold uppercase tracking-[0.22em] text-[var(--color-ink)] transition-colors hover:text-[var(--color-brand)]"
          >
            Tüm yazılım çözümleri
            <svg
              width="14"
              height="14"
              viewBox="0 0 24 24"
              fill="none"
              stroke="currentColor"
              strokeWidth="2"
              strokeLinecap="round"
              strokeLinejoin="round"
              className="transition-transform group-hover:translate-x-1"
              aria-hidden="true"
            >
              <line x1="5" y1="12" x2="19" y2="12" />
              <polyline points="12 5 19 12 12 19" />
            </svg>
          </Link>
        </div>

        <div className="mt-10 grid grid-cols-1 gap-6 md:grid-cols-2 md:gap-8">
          {ventures.map((v) => (
            <a
              key={v.num}
              href={v.href}
              target="_blank"
              rel="noopener noreferrer"
              aria-label={`${v.name} platformuna git (yeni sekmede açılır)`}
              className="group relative flex flex-col gap-5 overflow-hidden border border-[var(--color-border)] bg-white p-5 transition-all duration-300 hover:-translate-y-1 hover:border-[var(--color-ink)] hover:shadow-card-hover motion-reduce:hover:translate-y-0 sm:p-7 lg:p-9"
            >
              <span
                aria-hidden="true"
                className="absolute inset-x-0 top-0 h-0.5 origin-left scale-x-0 bg-[var(--color-brand)] transition-transform duration-300 group-hover:scale-x-100"
              />

              <div className="flex items-center justify-between gap-4">
                <div className="flex items-center gap-3">
                  <span
                    className={`relative inline-flex h-11 w-14 shrink-0 items-center justify-center overflow-hidden rounded ring-1 ring-[var(--color-border)] ${v.logoBg}`}
                  >
                    <Image
                      src={v.logo}
                      alt={v.name}
                      fill
                      sizes="56px"
                      className="object-contain p-1.5"
                    />
                  </span>
                  <div className="flex flex-col leading-tight">
                    <span className="font-mono text-xs text-[var(--color-ink-subtle)]">
                      — {v.num}
                    </span>
                    <span className="text-[10px] font-bold uppercase tracking-[0.22em] text-[var(--color-ink-muted)]">
                      {v.sector}
                    </span>
                  </div>
                </div>
                <span className="inline-flex items-center gap-1.5 text-[10px] font-bold uppercase tracking-[0.2em] text-emerald-600">
                  <span className="relative flex h-1.5 w-1.5">
                    <span className="absolute inline-flex h-full w-full animate-ping rounded-full bg-emerald-500 opacity-75 motion-reduce:animate-none" />
                    <span className="relative inline-flex h-1.5 w-1.5 rounded-full bg-emerald-500" />
                  </span>
                  Aktif
                </span>
              </div>

              <div>
                <h3 className="text-2xl font-bold tracking-tight text-[var(--color-ink)] transition-colors group-hover:text-[var(--color-brand)] sm:text-3xl">
                  {v.name}
                </h3>
                <div className="mt-1 font-mono text-xs text-[var(--color-ink-muted)]">
                  {v.domain}
                </div>
              </div>

              <p className="border-l-2 border-[var(--color-brand)] pl-4 text-sm font-medium italic leading-relaxed text-[var(--color-ink)]">
                {v.tagline}
              </p>

              <p className="text-sm leading-relaxed text-[var(--color-ink-soft)]">
                {v.description}
              </p>

              <ul className="flex flex-wrap gap-2">
                {v.features.map((f) => (
                  <li
                    key={f}
                    className="inline-flex items-center gap-1.5 border border-[var(--color-border)] bg-[var(--color-surface-alt)] px-2.5 py-1 text-[10px] font-semibold uppercase tracking-[0.16em] text-[var(--color-ink-soft)]"
                  >
                    <span
                      aria-hidden="true"
                      className="h-1 w-1 rounded-full bg-[var(--color-brand)]"
                    />
                    {f}
                  </li>
                ))}
              </ul>

              <div className="mt-2 inline-flex items-center gap-2 text-[11px] font-bold uppercase tracking-[0.22em] text-[var(--color-brand)]">
                Platforma Git
                <svg
                  width="14"
                  height="14"
                  viewBox="0 0 24 24"
                  fill="none"
                  stroke="currentColor"
                  strokeWidth="2"
                  strokeLinecap="round"
                  strokeLinejoin="round"
                  className="transition-transform duration-300 group-hover:translate-x-1 motion-reduce:transition-none"
                  aria-hidden="true"
                >
                  <line x1="5" y1="12" x2="19" y2="12" />
                  <polyline points="12 5 19 12 12 19" />
                </svg>
              </div>
            </a>
          ))}
        </div>
      </div>
    </section>
  );
}
