type Venture = {
  num: string;
  title: string;
  domain: string;
  sector: string;
  tagline: string;
  body: string;
  features: readonly string[];
  href: string;
  status: string;
};

const ventures: readonly Venture[] = [
  {
    num: "01",
    title: "Tamir Defteri",
    domain: "tamirdefteri.com",
    sector: "Atölye Yönetim Yazılımı",
    tagline: "Sanayinin dijital atölyesi",
    body: "Oto tamir ve servis işletmelerine yönelik dijital yönetim platformu. Sesli kayıt teknolojisi, araç ve müşteri profilleri, parça takibi, otomatik bakım hatırlatmaları ve SMS bildirimleriyle defter kalem ihtiyacını ortadan kaldırır.",
    features: [
      "Sesli veri girişi",
      "Otomatik bakım hatırlatma",
      "SMS bildirimi",
      "30 gün ücretsiz deneme",
    ],
    href: "https://tamirdefteri.com",
    status: "Aktif",
  },
  {
    num: "02",
    title: "YükünOlsun",
    domain: "yukunolsun.com",
    sector: "Dijital Taşımacılık Pazaryeri",
    tagline: "Yüksüz kalma",
    body: "Yük sahiplerini ve taşıyıcıları sıfır komisyonlu dijital pazaryerinde buluşturan platform. Yapay zeka destekli akıllı eşleştirme, dorse ve araç filtreleme, gerçek zamanlı ilan yönetimiyle boş dönüşleri azaltır ve filo verimliliğini yükseltir.",
    features: [
      "10.000+ kayıtlı taşıyıcı",
      "Günlük 15.000+ ilan",
      "81 il kapsamı",
      "Sıfır komisyon",
    ],
    href: "https://yukunolsun.com",
    status: "Aktif",
  },
] as const;

export default function VenturesSection() {
  return (
    <section
      id="yazilim"
      className="relative border-t border-[var(--color-border)] bg-[var(--color-night)] py-14 text-white sm:py-20 lg:py-24"
    >
      <div
        aria-hidden="true"
        className="absolute inset-x-0 top-0 h-px bg-gradient-to-r from-transparent via-[var(--color-brand)]/40 to-transparent"
      />
      <div className="container-page">
        <div className="border-b border-white/10 pb-10 md:pb-12">
          <div className="flex flex-col items-start justify-between gap-6 md:flex-row md:items-end">
            <div>
              <div className="flex items-center gap-3">
                <span className="h-px w-10 bg-[var(--color-brand)]" />
                <span className="font-mono text-[11px] uppercase tracking-[0.22em] text-white/50">
                  Yazılım Çözümlerimiz
                </span>
              </div>
              <h2 className="mt-5 text-3xl font-black tracking-tight text-white sm:text-4xl lg:text-5xl">
                Grup bünyesindeki dijital platformlar
              </h2>
            </div>
            <p className="max-w-md text-sm leading-relaxed text-white/60">
              Sahadaki tecrübemizi otomotiv ve nakliye ekosisteminin dijital
              dönüşümüne taşıyan iki yazılım ürünü geliştirdik.
            </p>
          </div>
        </div>

        <div className="mt-12 grid grid-cols-1 gap-6 md:grid-cols-2 md:gap-8">
          {ventures.map((v) => (
            <a
              key={v.num}
              href={v.href}
              target="_blank"
              rel="noopener noreferrer"
              className="group relative block overflow-hidden border border-white/10 bg-[var(--color-night-soft)] p-5 transition-all duration-300 hover:-translate-y-1 hover:border-[var(--color-brand)]/60 motion-reduce:hover:translate-y-0 sm:p-7 lg:p-10"
            >
              <span
                aria-hidden="true"
                className="absolute inset-x-0 top-0 h-0.5 origin-left scale-x-0 bg-[var(--color-brand)] transition-transform duration-300 group-hover:scale-x-100"
              />

              <div className="flex items-center justify-between gap-4">
                <div className="flex items-center gap-3">
                  <span className="font-mono text-xs text-white/40">
                    — {v.num}
                  </span>
                  <span className="text-[10px] font-bold uppercase tracking-[0.22em] text-white/60">
                    {v.sector}
                  </span>
                </div>
                <span className="inline-flex items-center gap-1.5 text-[10px] font-bold uppercase tracking-[0.2em] text-emerald-400">
                  <span className="relative flex h-1.5 w-1.5">
                    <span className="absolute inline-flex h-full w-full animate-ping rounded-full bg-emerald-400 opacity-75 motion-reduce:animate-none" />
                    <span className="relative inline-flex h-1.5 w-1.5 rounded-full bg-emerald-400" />
                  </span>
                  {v.status}
                </span>
              </div>

              <div className="mt-8 sm:mt-10">
                <h3 className="text-3xl font-black tracking-tight text-white transition-colors group-hover:text-[var(--color-brand)] sm:text-4xl lg:text-5xl">
                  {v.title}
                </h3>
                <div className="mt-2 font-mono text-xs text-white/40">
                  {v.domain}
                </div>
              </div>

              <p className="mt-6 border-l-2 border-[var(--color-brand)] pl-4 text-base font-medium italic leading-relaxed text-white sm:mt-8">
                {v.tagline}
              </p>

              <p className="mt-5 text-sm leading-relaxed text-white/65 sm:mt-6">
                {v.body}
              </p>

              <ul className="mt-6 flex flex-wrap gap-2 sm:mt-8">
                {v.features.map((f) => (
                  <li
                    key={f}
                    className="inline-flex items-center gap-1.5 border border-white/10 bg-white/[0.03] px-2.5 py-1 text-[10px] font-semibold uppercase tracking-[0.16em] text-white/70"
                  >
                    <span
                      aria-hidden="true"
                      className="h-1 w-1 rounded-full bg-[var(--color-brand)]"
                    />
                    {f}
                  </li>
                ))}
              </ul>

              <div className="mt-8 inline-flex items-center gap-2 text-[11px] font-bold uppercase tracking-[0.24em] text-[var(--color-brand)] sm:mt-10">
                Platforma Git
                <svg
                  width="16"
                  height="16"
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
