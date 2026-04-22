type Item = {
  num: string;
  label: string;
  title: string;
  body: string;
};

const items: readonly Item[] = [
  {
    num: "01",
    label: "Tecrübe",
    title: "Sektörde 15+ yıl",
    body: "Akdeniz bölgesinde otomotiv ve endüstriyel sektörlerin madeni yağ ihtiyacında güvenilir çözüm ortağı.",
  },
  {
    num: "02",
    label: "Yetki",
    title: "6 Premium marka",
    body: "Borax, Japan Oil, Xenol, Oilport, Brava ve Skynell markalarının resmi distribütörlüğü.",
  },
  {
    num: "03",
    label: "Tedarik",
    title: "B2B & filo çözümleri",
    body: "Servisler, oto sanayiler, lojistik ve endüstriyel tesisler için özel fiyatlandırma ve sevkiyat.",
  },
  {
    num: "04",
    label: "Destek",
    title: "Teknik danışmanlık",
    body: "Araç ve ekipmanınız için uygun viskozite, spesifikasyon ve kullanım önerileri.",
  },
] as const;

export default function TrustStrip() {
  return (
    <section className="border-y border-[var(--color-border)] bg-white">
      <div className="container-page">
        <div className="flex flex-col items-start justify-between gap-4 border-b border-[var(--color-border)] py-8 md:flex-row md:items-center">
          <div>
            <div className="text-[10px] font-bold uppercase tracking-[0.3em] text-[var(--color-brand)]">
              Kurumsal Kapasite
            </div>
            <h2 className="mt-2 text-xl font-semibold tracking-tight text-[var(--color-ink)] sm:text-2xl">
              Profesyonel madeni yağ tedariğinin dört temeli
            </h2>
          </div>
          <div className="text-sm text-[var(--color-ink-muted)]">
            {site_year()} itibariyle
          </div>
        </div>

        <ul className="grid grid-cols-1 divide-y divide-[var(--color-border)] md:grid-cols-4 md:divide-x md:divide-y-0">
          {items.map((it) => (
            <li
              key={it.num}
              className="group flex flex-col gap-3 px-0 py-7 md:px-6 md:first:pl-0 md:last:pr-0"
            >
              <div className="flex items-baseline gap-3">
                <span className="font-mono text-xs font-medium text-[var(--color-ink-subtle)]">
                  — {it.num}
                </span>
                <span className="text-[10px] font-semibold uppercase tracking-[0.22em] text-[var(--color-ink-muted)]">
                  {it.label}
                </span>
              </div>
              <div className="text-lg font-semibold leading-snug text-[var(--color-ink)]">
                {it.title}
              </div>
              <p className="text-sm leading-relaxed text-[var(--color-ink-soft)]">
                {it.body}
              </p>
            </li>
          ))}
        </ul>
      </div>
    </section>
  );
}

function site_year(): string {
  return String(new Date().getFullYear());
}
