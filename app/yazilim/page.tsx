import type { Metadata } from "next";
import Image from "next/image";
import Link from "next/link";
import { buildMetadata } from "@/src/lib/seo";
import { site } from "@/src/lib/site";

export const metadata: Metadata = buildMetadata({
  title: "Yazılım Çözümlerimiz",
  path: "/yazilim",
  description:
    "Tamir Defteri ve YükünOlsun — MNR Petrol grup bünyesindeki iki dijital platform. Atölye yönetim yazılımı ve dijital taşımacılık pazaryeri.",
});

type Venture = {
  num: string;
  name: string;
  domain: string;
  sector: string;
  tagline: string;
  intro: string;
  body: string;
  features: readonly string[];
  href: string;
  logo: string;
  logoBg: string;
  audience: string;
  pricing: string;
};

const ventures: readonly Venture[] = [
  {
    num: "01",
    name: "Tamir Defteri",
    domain: "tamirdefteri.com",
    sector: "Atölye Yönetim Yazılımı",
    tagline: "Sanayinin dijital atölyesi",
    intro:
      "Oto tamir ve servis işletmelerinin defter-kalem dönemini bitiren dijital yönetim platformu.",
    body: "Müşteri ve araç profilleri, parça hareketi takibi, iş atama ve performans takibi, otomatik bakım hatırlatmaları ve SMS bildirimleriyle atölyenin tüm operasyonunu tek bir yazılımda yönetir. Sesli veri girişi sayesinde usta ekipler işin başından kaldığında bile kayıt tutabilir; kağıt kaybı, eksik fatura ve unutulan bakım işleri ortadan kalkar.",
    features: [
      "Sesli veri girişi",
      "Otomatik bakım hatırlatma",
      "SMS bildirimi",
      "Müşteri ve araç profilleri",
      "Parça hareket takibi",
      "Çalışan görev atama",
    ],
    href: "https://tamirdefteri.com",
    logo: "/ventures/tamirdefteri.webp",
    logoBg: "bg-[var(--color-ink)]",
    audience: "Oto tamir & servis işletmeleri",
    pricing: "30 gün ücretsiz deneme",
  },
  {
    num: "02",
    name: "YükünOlsun",
    domain: "yukunolsun.com",
    sector: "Dijital Taşımacılık Pazaryeri",
    tagline: "Yüksüz kalma",
    intro:
      "Yük sahiplerini ve taşıyıcıları sıfır komisyonlu dijital pazaryerinde buluşturan taşımacılık platformu.",
    body: "WhatsApp ve Facebook gruplarındaki yük arama süreçlerini güvenli ve doğrulanmış bir platforma taşır. Yapay zeka destekli akıllı eşleştirme, dorse ve araç tipi filtreleme, konum tabanlı öneriler ve gerçek zamanlı ilan yönetimiyle boş dönüşleri azaltır ve filo verimliliğini yükseltir. 81 il kapsamında, sıfır komisyon ve gizli ücretsiz kullanım modeli sunar.",
    features: [
      "10.000+ kayıtlı taşıyıcı",
      "Günlük 15.000+ ilan",
      "81 il kapsamı",
      "Sıfır komisyon",
      "AI destekli eşleştirme",
      "Doğrulanmış üyeler",
    ],
    href: "https://yukunolsun.com",
    logo: "/ventures/yukunolsun.webp",
    logoBg: "bg-white",
    audience: "Yük sahipleri & taşıyıcılar",
    pricing: "Tamamen ücretsiz",
  },
] as const;

export default function YazilimPage() {
  return (
    <>
      {/* 01 Intro */}
      <section className="bg-white py-16 sm:py-20">
        <div className="container-page grid gap-10 lg:grid-cols-12 lg:gap-12">
          <div className="lg:col-span-5">
            <div className="font-mono text-xs text-[var(--color-ink-subtle)]">
              — 01
            </div>
            <div className="mt-2 text-[10px] font-bold uppercase tracking-[0.3em] text-[var(--color-brand)]">
              Yazılım Çözümlerimiz
            </div>
            <h1 className="mt-3 text-3xl font-bold tracking-tight text-[var(--color-ink)] sm:text-4xl lg:text-5xl">
              Otomotiv ve nakliye için dijital platformlar
            </h1>
          </div>

          <div className="lg:col-span-7">
            <div className="space-y-5 text-base leading-relaxed text-[var(--color-ink-soft)]">
              <p>
                Sahadaki madeni yağ tedariği tecrübemizi, otomotiv ve nakliye
                ekosisteminin dijital ihtiyaçlarına çözüm sunmak için
                yazılım geliştirme alanına taşıdık. Grup bünyesinde geliştirdiğimiz
                iki bağımsız platform, farklı kullanıcı segmentlerine hizmet
                veriyor.
              </p>
              <p>
                <strong className="font-semibold text-[var(--color-ink)]">
                  Tamir Defteri
                </strong>{" "}
                oto tamir atölyelerinin operasyonel yönetimini dijitalleştirirken,{" "}
                <strong className="font-semibold text-[var(--color-ink)]">
                  YükünOlsun
                </strong>{" "}
                nakliyecileri ve yük sahiplerini sıfır komisyonlu bir
                pazaryerinde buluşturuyor. Her iki platform da bağımsız
                ürünler olarak hizmet vermeye devam ediyor.
              </p>
            </div>
          </div>
        </div>

        <div className="container-page mt-12">
          <dl className="grid grid-cols-3 gap-4 border-y border-[var(--color-border)] py-6 sm:gap-0 sm:divide-x sm:divide-[var(--color-border)]">
            <div className="sm:px-6 sm:first:pl-0">
              <dt className="font-mono text-[10px] uppercase tracking-[0.18em] text-[var(--color-ink-subtle)]">
                — Platform
              </dt>
              <dd className="mt-2 text-2xl font-bold tracking-tight text-[var(--color-ink)] sm:text-3xl">
                2
              </dd>
            </div>
            <div className="sm:px-6">
              <dt className="font-mono text-[10px] uppercase tracking-[0.18em] text-[var(--color-ink-subtle)]">
                — Sektör
              </dt>
              <dd className="mt-2 text-base font-semibold leading-tight text-[var(--color-ink)] sm:text-xl">
                Otomotiv · Nakliye
              </dd>
            </div>
            <div className="sm:px-6 sm:last:pr-0">
              <dt className="font-mono text-[10px] uppercase tracking-[0.18em] text-[var(--color-ink-subtle)]">
                — Durum
              </dt>
              <dd className="mt-2 inline-flex items-center gap-2 text-base font-semibold text-emerald-600 sm:text-xl">
                <span className="relative flex h-2 w-2">
                  <span className="absolute inline-flex h-full w-full animate-ping rounded-full bg-emerald-500 opacity-75 motion-reduce:animate-none" />
                  <span className="relative inline-flex h-2 w-2 rounded-full bg-emerald-500" />
                </span>
                Aktif
              </dd>
            </div>
          </dl>
        </div>
      </section>

      {/* 02 Platforms detail */}
      <section className="border-t border-[var(--color-border)] bg-[var(--color-surface-alt)] py-16 sm:py-20 lg:py-24">
        <div className="container-page">
          <div className="border-b border-[var(--color-border)] pb-8">
            <div className="font-mono text-xs text-[var(--color-ink-subtle)]">
              — 02
            </div>
            <div className="mt-2 text-[10px] font-bold uppercase tracking-[0.3em] text-[var(--color-brand)]">
              Platformlar
            </div>
            <h2 className="mt-3 text-2xl font-bold tracking-tight text-[var(--color-ink)] sm:text-3xl md:text-4xl">
              Detaylı ürün tanıtımı
            </h2>
          </div>

          <div className="mt-10 space-y-6 sm:mt-12 sm:space-y-8">
            {ventures.map((v) => (
              <article
                key={v.num}
                className="group relative overflow-hidden border border-[var(--color-border)] bg-white p-6 transition-shadow hover:shadow-card-hover sm:p-8 lg:p-10"
              >
                <span
                  aria-hidden="true"
                  className="absolute inset-x-0 top-0 h-0.5 bg-[var(--color-brand)]"
                />

                <div className="grid gap-8 lg:grid-cols-12">
                  <div className="lg:col-span-5">
                    <div className="flex items-center gap-3">
                      <span
                        className={`relative inline-flex h-12 w-16 shrink-0 items-center justify-center overflow-hidden rounded ring-1 ring-[var(--color-border)] ${v.logoBg}`}
                      >
                        <Image
                          src={v.logo}
                          alt={v.name}
                          fill
                          sizes="64px"
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

                    <h3 className="mt-6 text-3xl font-bold tracking-tight text-[var(--color-ink)] sm:text-4xl">
                      {v.name}
                    </h3>
                    <div className="mt-1 font-mono text-xs text-[var(--color-ink-muted)]">
                      {v.domain}
                    </div>

                    <p className="mt-5 border-l-2 border-[var(--color-brand)] pl-4 text-base font-medium italic leading-relaxed text-[var(--color-ink)]">
                      {v.tagline}
                    </p>

                    <dl className="mt-6 space-y-3 text-sm">
                      <div className="flex items-baseline gap-3">
                        <dt className="font-mono text-[10px] uppercase tracking-[0.18em] text-[var(--color-ink-subtle)]">
                          Hedef
                        </dt>
                        <dd className="text-[var(--color-ink-soft)]">
                          {v.audience}
                        </dd>
                      </div>
                      <div className="flex items-baseline gap-3">
                        <dt className="font-mono text-[10px] uppercase tracking-[0.18em] text-[var(--color-ink-subtle)]">
                          Model
                        </dt>
                        <dd className="text-[var(--color-ink-soft)]">
                          {v.pricing}
                        </dd>
                      </div>
                    </dl>

                    <a
                      href={v.href}
                      target="_blank"
                      rel="noopener noreferrer"
                      className="mt-8 inline-flex items-center gap-2 bg-[var(--color-brand)] px-6 py-3 text-xs font-bold uppercase tracking-[0.22em] text-white transition-colors hover:bg-[var(--color-brand-dark)] active:bg-[var(--color-brand-dark)]"
                    >
                      Platforma Git
                      <svg
                        width="14"
                        height="14"
                        viewBox="0 0 24 24"
                        fill="none"
                        stroke="currentColor"
                        strokeWidth="2.5"
                        strokeLinecap="round"
                        strokeLinejoin="round"
                        aria-hidden="true"
                      >
                        <path d="M7 17L17 7" />
                        <path d="M7 7h10v10" />
                      </svg>
                    </a>
                  </div>

                  <div className="lg:col-span-7">
                    <p className="text-base font-medium leading-relaxed text-[var(--color-ink)]">
                      {v.intro}
                    </p>
                    <p className="mt-4 text-sm leading-relaxed text-[var(--color-ink-soft)]">
                      {v.body}
                    </p>

                    <div className="mt-6">
                      <div className="text-[10px] font-bold uppercase tracking-[0.22em] text-[var(--color-ink-muted)]">
                        Öne Çıkan Özellikler
                      </div>
                      <ul className="mt-3 grid grid-cols-1 gap-2 sm:grid-cols-2">
                        {v.features.map((f) => (
                          <li
                            key={f}
                            className="inline-flex items-center gap-2 border border-[var(--color-border)] bg-[var(--color-surface-alt)] px-3 py-2 text-[11px] font-semibold uppercase tracking-[0.14em] text-[var(--color-ink-soft)]"
                          >
                            <span
                              aria-hidden="true"
                              className="h-1 w-1 shrink-0 rounded-full bg-[var(--color-brand)]"
                            />
                            {f}
                          </li>
                        ))}
                      </ul>
                    </div>
                  </div>
                </div>
              </article>
            ))}
          </div>
        </div>
      </section>

      {/* 03 CTA */}
      <section className="border-t border-[var(--color-border)] bg-[var(--color-night)] py-16 text-white sm:py-20">
        <div className="container-page">
          <div className="grid gap-6 md:grid-cols-[1fr_auto] md:items-end">
            <div>
              <div className="font-mono text-xs text-white/50">— 03</div>
              <div className="mt-2 text-[10px] font-bold uppercase tracking-[0.3em] text-[var(--color-brand)]">
                İletişim
              </div>
              <h2 className="mt-3 text-2xl font-bold tracking-tight text-white sm:text-3xl md:text-4xl">
                Platformlarımız hakkında daha fazla bilgi
              </h2>
              <p className="mt-3 max-w-xl text-sm text-white/70">
                Kurumsal anlaşma, bayilik fırsatları veya entegrasyon
                talepleri için bizimle iletişime geçin.
              </p>
            </div>
            <div className="flex flex-wrap gap-3">
              <Link
                href="/#iletisim"
                className="inline-flex min-h-[48px] items-center gap-2 bg-[var(--color-brand)] px-6 py-3 text-xs font-bold uppercase tracking-[0.22em] text-white transition-colors hover:bg-[var(--color-brand-dark)] active:bg-[var(--color-brand-dark)]"
              >
                İletişime Geç
              </Link>
              <a
                href={`tel:${site.phone.replace(/\s+/g, "")}`}
                className="inline-flex min-h-[48px] items-center gap-2 border border-white/30 px-6 py-3 text-xs font-bold uppercase tracking-[0.22em] transition-colors hover:border-white hover:bg-white/10 active:bg-white/10"
              >
                {site.phone}
              </a>
            </div>
          </div>
        </div>
      </section>
    </>
  );
}
