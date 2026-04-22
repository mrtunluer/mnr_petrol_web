const certifications = [
  { label: "ISO 9001", sub: "Kalite Yönetim Sistemi" },
  { label: "ISO 14001", sub: "Çevre Yönetimi" },
  { label: "API", sub: "American Petroleum Institute" },
  { label: "ACEA", sub: "Avrupa Otomotiv Standartı" },
  { label: "TSE", sub: "Türk Standartları Enstitüsü" },
] as const;

export default function CertificationsBar() {
  return (
    <section className="border-y border-[var(--color-border)] bg-[var(--color-surface-alt)] py-10">
      <div className="container-page">
        <div className="mb-6 text-center">
          <span className="kicker">Sertifikalar & Standartlar</span>
          <h3 className="mt-2 text-lg font-bold text-[var(--color-ink)]">
            Uluslararası standartlarda ürün ve hizmet
          </h3>
        </div>
        <ul className="grid grid-cols-2 gap-3 sm:grid-cols-3 lg:grid-cols-5">
          {certifications.map((c) => (
            <li
              key={c.label}
              className="group flex flex-col items-center gap-1 rounded-xl border border-[var(--color-border)] bg-white p-4 text-center transition-all hover:-translate-y-0.5 hover:border-[var(--color-brand)]/40 hover:shadow-md"
            >
              <div className="text-lg font-black tracking-tight text-[var(--color-ink)] transition-colors group-hover:text-[var(--color-brand)]">
                {c.label}
              </div>
              <div className="text-[10px] font-medium uppercase tracking-wider text-[var(--color-ink-muted)]">
                {c.sub}
              </div>
            </li>
          ))}
        </ul>
      </div>
    </section>
  );
}
