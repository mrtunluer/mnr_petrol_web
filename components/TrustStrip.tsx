type Item = {
  title: string;
  body: string;
  icon: "authentic" | "delivery" | "expert" | "dealer";
};

const items: readonly Item[] = [
  {
    title: "Orijinal Ürün",
    body: "Yetkili distribütör garantisi",
    icon: "authentic",
  },
  {
    title: "Hızlı Teslimat",
    body: "Geniş stok, zamanında sevkiyat",
    icon: "delivery",
  },
  {
    title: "Uzman Kadro",
    body: "15+ yıllık teknik destek",
    icon: "expert",
  },
  {
    title: "Yetkili Bayilik",
    body: "Borax, Oilport, Xenol ve daha fazlası",
    icon: "dealer",
  },
] as const;

export default function TrustStrip() {
  return (
    <section className="relative z-10 -mt-10 bg-transparent">
      <div className="container-page">
        <ul className="grid overflow-hidden rounded-2xl bg-white shadow-[0_20px_60px_-15px_rgba(15,23,42,0.2)] ring-1 ring-[var(--color-border)] sm:grid-cols-2 lg:grid-cols-4">
          {items.map((it, i) => (
            <li
              key={it.title}
              className={`flex items-center gap-4 p-5 lg:p-6 ${
                i < items.length - 1
                  ? "border-b border-[var(--color-border)] sm:[&:nth-child(2n+1)]:border-r sm:[&:nth-child(odd)]:border-r sm:nth-child(odd):border-r lg:border-b-0 lg:[&:not(:last-child)]:border-r"
                  : ""
              }`}
            >
              <span className="flex h-12 w-12 shrink-0 items-center justify-center rounded-xl bg-[var(--color-brand-light)] text-[var(--color-brand)]">
                <Icon kind={it.icon} />
              </span>
              <div className="min-w-0">
                <div className="text-sm font-bold text-[var(--color-ink)]">
                  {it.title}
                </div>
                <div className="mt-0.5 text-xs text-[var(--color-ink-muted)]">
                  {it.body}
                </div>
              </div>
            </li>
          ))}
        </ul>
      </div>
    </section>
  );
}

function Icon({ kind }: { kind: Item["icon"] }) {
  const common = {
    width: 22,
    height: 22,
    viewBox: "0 0 24 24",
    fill: "none",
    stroke: "currentColor",
    strokeWidth: 2,
    strokeLinecap: "round" as const,
    strokeLinejoin: "round" as const,
    "aria-hidden": true,
  };
  if (kind === "authentic") {
    return (
      <svg {...common}>
        <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z" />
        <polyline points="9 12 11 14 15 10" />
      </svg>
    );
  }
  if (kind === "delivery") {
    return (
      <svg {...common}>
        <rect x="1" y="3" width="15" height="13" />
        <polygon points="16 8 20 8 23 11 23 16 16 16 16 8" />
        <circle cx="5.5" cy="18.5" r="2.5" />
        <circle cx="18.5" cy="18.5" r="2.5" />
      </svg>
    );
  }
  if (kind === "expert") {
    return (
      <svg {...common}>
        <circle cx="12" cy="8" r="4" />
        <path d="M6 21v-2a4 4 0 0 1 4-4h4a4 4 0 0 1 4 4v2" />
      </svg>
    );
  }
  return (
    <svg {...common}>
      <path d="M6 2L3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z" />
      <line x1="3" y1="6" x2="21" y2="6" />
      <path d="M16 10a4 4 0 0 1-8 0" />
    </svg>
  );
}
