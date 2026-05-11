import Link from "next/link";

type Activity = {
  num: string;
  label: string;
  title: string;
  body: string;
  href?: string;
  external?: boolean;
};

const activities: readonly Activity[] = [
  {
    num: "01",
    label: "Madeni Yağ",
    title: "Tedarik & Distribütörlük",
    body: "Akdeniz bölgesinde otomotiv ve endüstriyel sektörlerin madeni yağ ihtiyacını altı premium marka portföyüyle karşılıyoruz.",
    href: "/urunler",
  },
  {
    num: "02",
    label: "Yazılım",
    title: "Dijital Platformlar",
    body: "Atölyeler ve nakliyeciler için geliştirdiğimiz iki dijital platformla otomotiv ekosistemine yazılım çözümleri sunuyoruz.",
    href: "#yazilim",
  },
  {
    num: "03",
    label: "Lojistik",
    title: "Filo & Taşımacılık",
    body: "Geniş araç filomuz ve grup bünyesindeki taşımacılık pazaryeriyle Akdeniz bölgesinde lojistik zincirinin tüm halkalarında varız.",
  },
  {
    num: "04",
    label: "Sanayi & İnşaat",
    title: "Kurumsal Tedarik",
    body: "Endüstriyel tesislerin yağlama ihtiyaçları, sanayi ve inşaat sektörlerine yönelik kurumsal tedarik çözümlerimizle iş ortağınızız.",
  },
] as const;

export default function ActivitiesGrid() {
  return (
    <section className="bg-white py-20">
      <div className="container-page">
        <div className="flex flex-col items-start justify-between gap-4 border-b border-[var(--color-border)] pb-8 md:flex-row md:items-end">
          <div>
            <div className="font-mono text-xs text-[var(--color-ink-subtle)]">
              — Faaliyet Alanlarımız
            </div>
            <h2 className="mt-2 text-2xl font-semibold tracking-tight text-[var(--color-ink)] sm:text-3xl md:text-4xl">
              Hizmet verdiğimiz alanlar
            </h2>
          </div>
          <p className="max-w-md text-sm leading-relaxed text-[var(--color-ink-soft)]">
            Madeni yağ tedariğinden dijital girişimlere — birden fazla
            sektörde uzmanlaşmış ekiplerle hizmet veriyoruz.
          </p>
        </div>

        <ul className="grid grid-cols-1 divide-y divide-[var(--color-border)] sm:grid-cols-2 sm:divide-x sm:divide-y-0 lg:grid-cols-4">
          {activities.map((a, i) => {
            const wrap = (children: React.ReactNode) => {
              if (!a.href) return children;
              const cls = "group flex h-full flex-col gap-3 py-8 transition-colors hover:bg-[var(--color-surface-alt)] active:bg-[var(--color-surface-alt)] sm:px-6";
              if (a.external) {
                return (
                  <a
                    href={a.href}
                    target="_blank"
                    rel="noopener noreferrer"
                    className={cls}
                  >
                    {children}
                  </a>
                );
              }
              return (
                <Link href={a.href} className={cls}>
                  {children}
                </Link>
              );
            };
            return (
              <li
                key={a.num}
                className={`${
                  a.href
                    ? ""
                    : "flex flex-col gap-3 py-8 sm:px-6"
                } ${i % 2 === 0 ? "sm:first:pl-0" : ""} sm:last:pr-0 lg:[&:nth-child(4n+1)]:pl-0 lg:[&:nth-child(4n)]:pr-0`}
              >
                {wrap(
                  <>
                    <div className="flex items-baseline gap-3">
                      <span className="font-mono text-xs font-medium text-[var(--color-ink-subtle)]">
                        — {a.num}
                      </span>
                      <span className="text-[10px] font-semibold uppercase tracking-[0.22em] text-[var(--color-brand)]">
                        {a.label}
                      </span>
                    </div>
                    <div className="text-lg font-semibold leading-snug text-[var(--color-ink)] transition-colors group-hover:text-[var(--color-brand)]">
                      {a.title}
                    </div>
                    <p className="text-sm leading-relaxed text-[var(--color-ink-soft)]">
                      {a.body}
                    </p>
                    {a.href && (
                      <span className="mt-auto inline-flex items-center gap-1.5 text-[11px] font-bold uppercase tracking-[0.2em] text-[var(--color-brand)]">
                        Detay
                        <svg
                          width="10"
                          height="10"
                          viewBox="0 0 24 24"
                          fill="none"
                          stroke="currentColor"
                          strokeWidth="2.5"
                          strokeLinecap="round"
                          strokeLinejoin="round"
                          className="transition-transform group-hover:translate-x-1"
                          aria-hidden="true"
                        >
                          <line x1="5" y1="12" x2="19" y2="12" />
                          <polyline points="12 5 19 12 12 19" />
                        </svg>
                      </span>
                    )}
                  </>,
                )}
              </li>
            );
          })}
        </ul>
      </div>
    </section>
  );
}
