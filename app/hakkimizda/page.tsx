import type { Metadata } from "next";
import Image from "next/image";
import Link from "next/link";
import { buildMetadata } from "@/src/lib/seo";
import { site } from "@/src/lib/site";

export const metadata: Metadata = buildMetadata({
  title: "Hakkımızda",
  path: "/hakkimizda",
  description:
    "MNR Petrol Tarım İnş. San. Tic. Ltd. Şti. — 2008'den bu yana Akdeniz bölgesinde madeni yağ tedariğinde güvenilir çözüm ortağı.",
});

const values = [
  {
    num: "01",
    label: "Kalite",
    title: "Kalite güvencesi",
    body: "Tüm ürünlerimiz üretici yetkili kanallarından, uluslararası standartlara uygun olarak tedarik edilir.",
  },
  {
    num: "02",
    label: "Destek",
    title: "Uzman teknik kadro",
    body: "Deneyimli ekibimiz; viskozite, spesifikasyon ve kullanım önerileriyle en uygun ürünü seçmenizde yardımcı olur.",
  },
  {
    num: "03",
    label: "Tedarik",
    title: "Hızlı ve güvenilir sevkiyat",
    body: "Geniş stok altyapımız sayesinde servis, filo ve endüstriyel tesis taleplerini zamanında karşılıyoruz.",
  },
] as const;

export default function HakkimizdaPage() {
  return (
    <>
      {/* Intro */}
      <section className="bg-white py-20">
        <div className="container-page grid gap-12 lg:grid-cols-12">
          <div className="lg:col-span-5">
            <div className="font-mono text-xs text-[var(--color-ink-subtle)]">
              — 01
            </div>
            <div className="mt-2 text-[10px] font-bold uppercase tracking-[0.3em] text-[var(--color-brand)]">
              Hakkımızda
            </div>
            <h1 className="mt-3 text-4xl font-semibold tracking-tight text-[var(--color-ink)] sm:text-5xl">
              {site.legalName}
            </h1>
            <p className="mt-2 text-sm font-semibold uppercase tracking-[0.2em] text-[var(--color-ink-muted)]">
              {site.tagline}
            </p>

            <dl className="mt-10 grid grid-cols-3 divide-x divide-[var(--color-border)] border-y border-[var(--color-border)] py-5">
              <div className="px-4 first:pl-0">
                <dt className="font-mono text-xs text-[var(--color-ink-subtle)]">
                  — Kuruluş
                </dt>
                <dd className="mt-1 text-2xl font-semibold text-[var(--color-ink)]">
                  2008
                </dd>
              </div>
              <div className="px-4">
                <dt className="font-mono text-xs text-[var(--color-ink-subtle)]">
                  — Bölge
                </dt>
                <dd className="mt-1 text-2xl font-semibold text-[var(--color-ink)]">
                  Akdeniz
                </dd>
              </div>
              <div className="px-4 last:pr-0">
                <dt className="font-mono text-xs text-[var(--color-ink-subtle)]">
                  — Marka
                </dt>
                <dd className="mt-1 text-2xl font-semibold text-[var(--color-ink)]">
                  6
                </dd>
              </div>
            </dl>
          </div>

          <div className="lg:col-span-7">
            <div className="space-y-6 text-base leading-relaxed text-[var(--color-ink-soft)]">
              <p>
                2008 yılında kurulan firmamız, Akdeniz bölgesinde otomotiv ve
                endüstriyel sektörlerin madeni yağ ihtiyacını karşılayan
                güvenilir çözüm ortağınızdır. Yılların deneyimiyle, kaliteli
                ürünler ve profesyonel hizmet anlayışımızla müşterilerimize
                değer katıyoruz.
              </p>
              <p>
                Geniş ürün yelpazemiz ve uzman kadromuzla, madeni yağ
                konusunda her alanda saygıdeğer müşterilerimizin ihtiyacını
                karşılamak için çalışıyoruz.
              </p>
            </div>
          </div>
        </div>
      </section>

      {/* Values */}
      <section className="border-y border-[var(--color-border)] bg-[var(--color-surface-alt)]">
        <div className="container-page">
          <div className="flex flex-col items-start justify-between gap-4 border-b border-[var(--color-border)] py-8 md:flex-row md:items-end">
            <div>
              <div className="font-mono text-xs text-[var(--color-ink-subtle)]">
                — 02
              </div>
              <div className="mt-2 text-[10px] font-bold uppercase tracking-[0.3em] text-[var(--color-brand)]">
                Yaklaşımımız
              </div>
              <h2 className="mt-3 text-3xl font-semibold tracking-tight text-[var(--color-ink)] sm:text-4xl">
                Neden MNR Petrol
              </h2>
            </div>
            <p className="max-w-md text-sm text-[var(--color-ink-soft)]">
              Tedarik zincirinden teknik desteğe kadar üç temel ilkemizle
              çalışıyoruz.
            </p>
          </div>

          <ul className="grid grid-cols-1 divide-y divide-[var(--color-border)] md:grid-cols-3 md:divide-x md:divide-y-0">
            {values.map((v) => (
              <li
                key={v.num}
                className="flex flex-col gap-3 px-0 py-10 md:px-8 md:first:pl-0 md:last:pr-0"
              >
                <div className="flex items-baseline gap-3">
                  <span className="font-mono text-xs font-medium text-[var(--color-ink-subtle)]">
                    — {v.num}
                  </span>
                  <span className="text-[10px] font-semibold uppercase tracking-[0.22em] text-[var(--color-ink-muted)]">
                    {v.label}
                  </span>
                </div>
                <div className="text-xl font-semibold leading-snug text-[var(--color-ink)]">
                  {v.title}
                </div>
                <p className="text-sm leading-relaxed text-[var(--color-ink-soft)]">
                  {v.body}
                </p>
              </li>
            ))}
          </ul>
        </div>
      </section>

      {/* Ar-Ge */}
      <section className="bg-white py-24">
        <div className="container-page grid gap-12 lg:grid-cols-12">
          <div className="lg:col-span-4">
            <div className="font-mono text-xs text-[var(--color-ink-subtle)]">
              — 03
            </div>
            <div className="mt-2 text-[10px] font-bold uppercase tracking-[0.3em] text-[var(--color-brand)]">
              Faaliyet Alanı
            </div>
            <h2 className="mt-3 text-3xl font-semibold tracking-tight text-[var(--color-ink)] sm:text-4xl">
              Ar-Ge ve teknik destek
            </h2>
          </div>
          <div className="lg:col-span-8">
            <div className="space-y-6 text-base leading-relaxed text-[var(--color-ink-soft)]">
              <p>
                Partneri olduğumuz firmaların yurt dışı ve yurt içi Ar-Ge
                departmanları ile koordineli olarak çalışmakta, sektörün
                ihtiyacı olan özel ürünlerin oluşması ve sahaya sunulmasında
                öncülük etmekteyiz. Tamamı ile teknik ekiple hizmet veren
                firmamız, araç ve endüstriyel ekipmanlarınızın performansını
                maksimize etmek için en uygun yağlama çözümlerini sunmaktadır.
              </p>
              <p>
                Geniş araç filomuz ve deneyimli ekibimizle, sektörde dijital
                dönüşüme öncülük ederek müşterilerimize en verimli ve güvenilir
                hizmeti sunmaktayız.
              </p>
            </div>
          </div>
        </div>
      </section>

      {/* Dijital Girişimler */}
      <section className="border-t border-[var(--color-border)] bg-[var(--color-surface-alt)] py-24">
        <div className="container-page">
          <div className="flex flex-col items-start justify-between gap-4 border-b border-[var(--color-border)] pb-8 md:flex-row md:items-end">
            <div>
              <div className="font-mono text-xs text-[var(--color-ink-subtle)]">
                — 04
              </div>
              <div className="mt-2 text-[10px] font-bold uppercase tracking-[0.3em] text-[var(--color-brand)]">
                Dijital Girişimlerimiz
              </div>
              <h2 className="mt-3 text-3xl font-semibold tracking-tight text-[var(--color-ink)] sm:text-4xl">
                Grup bünyesindeki platformlar
              </h2>
            </div>
            <p className="max-w-md text-sm leading-relaxed text-[var(--color-ink-soft)]">
              Sahadaki tecrübemizi, otomotiv ve nakliye ekosisteminin dijital
              dönüşümüne taşıyan iki platform.
            </p>
          </div>

          <div className="grid grid-cols-1 gap-0 divide-y divide-[var(--color-border)] md:grid-cols-2 md:divide-x md:divide-y-0">
            <VenturesCard
              num="01"
              domain="yukunolsun.com"
              title="YükünOlsun"
              sector="Dijital Taşımacılık Pazaryeri"
              tagline="Yüksüz kalma — yükünü bul, aracını doldur."
              body="Yük sahiplerini ve nakliyecileri komisyonsuz bir dijital pazaryerinde buluşturan taşımacılık platformu. Akıllı filtreleme ve konum tabanlı eşleştirme ile boş dönüşleri azaltarak filo verimliliğini yükseltir."
              href="https://yukunolsun.com"
            />
            <VenturesCard
              num="02"
              domain="tamirdefteri.com"
              title="Tamir Defteri"
              sector="Atölye Yönetim Platformu"
              tagline="Defteri kalemi at, dijitale geç."
              body="Oto tamir ve servis işletmelerine yönelik dijital yönetim yazılımı. Müşteri kaydı, parça takibi, iş atama ve SMS tabanlı bakım hatırlatıcılarıyla sanayinin dijital atölyesi olarak hizmet verir."
              href="https://tamirdefteri.com"
            />
          </div>
        </div>
      </section>

      {/* CTA */}
      <section className="border-t border-[var(--color-border)] bg-[var(--color-night)] py-20 text-white">
        <div className="container-page grid gap-6 md:grid-cols-[1fr_auto] md:items-end">
          <div>
            <div className="text-[10px] font-bold uppercase tracking-[0.3em] text-[var(--color-brand)]">
              İletişim
            </div>
            <h2 className="mt-2 text-3xl font-semibold tracking-tight text-white sm:text-4xl">
              Birlikte çalışalım
            </h2>
            <p className="mt-3 max-w-xl text-sm text-white/70">
              İhtiyacınız olan ürün için teklif ya da özel çözüm için bize
              ulaşın.
            </p>
          </div>
          <div className="flex flex-wrap gap-3">
            <Link
              href="/urunler"
              className="inline-flex items-center gap-2 bg-[var(--color-brand)] px-6 py-3 text-xs font-bold uppercase tracking-[0.22em] text-white transition-colors hover:bg-[var(--color-brand-dark)]"
            >
              Ürünleri İncele
            </Link>
            <Link
              href="/#iletisim"
              className="inline-flex items-center gap-2 border border-white/30 px-6 py-3 text-xs font-bold uppercase tracking-[0.22em] transition-colors hover:border-white hover:bg-white/10"
            >
              İletişime Geç
            </Link>
          </div>
        </div>
      </section>
    </>
  );
}

function VenturesCard({
  num,
  domain,
  title,
  sector,
  tagline,
  body,
  href,
}: {
  num: string;
  domain: string;
  title: string;
  sector: string;
  tagline: string;
  body: string;
  href: string;
}) {
  return (
    <a
      href={href}
      target="_blank"
      rel="noopener noreferrer"
      className="group flex flex-col gap-5 bg-[var(--color-surface-alt)] px-0 py-10 transition-colors hover:bg-white md:px-10 md:first:pl-0 md:last:pr-0"
    >
      <div className="flex items-center justify-between">
        <div className="flex items-baseline gap-3">
          <span className="font-mono text-xs font-medium text-[var(--color-ink-subtle)]">
            — {num}
          </span>
          <span className="text-[10px] font-semibold uppercase tracking-[0.22em] text-[var(--color-ink-muted)]">
            {sector}
          </span>
        </div>
        <svg
          width="14"
          height="14"
          viewBox="0 0 24 24"
          fill="none"
          stroke="currentColor"
          strokeWidth="2"
          strokeLinecap="round"
          strokeLinejoin="round"
          className="text-[var(--color-ink-muted)] transition-all group-hover:-translate-y-0.5 group-hover:translate-x-0.5 group-hover:text-[var(--color-brand)]"
          aria-hidden="true"
        >
          <path d="M7 17L17 7" />
          <path d="M7 7h10v10" />
        </svg>
      </div>

      <div>
        <h3 className="text-3xl font-semibold tracking-tight text-[var(--color-ink)] transition-colors group-hover:text-[var(--color-brand)]">
          {title}
        </h3>
        <div className="mt-1 font-mono text-xs text-[var(--color-ink-muted)]">
          {domain}
        </div>
      </div>

      <p className="border-l-2 border-[var(--color-brand)] pl-4 text-sm font-medium italic leading-relaxed text-[var(--color-ink)]">
        {tagline}
      </p>

      <p className="text-sm leading-relaxed text-[var(--color-ink-soft)]">
        {body}
      </p>
    </a>
  );
}
