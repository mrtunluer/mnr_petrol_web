import type { Metadata } from "next";
import Image from "next/image";
import Link from "next/link";
import { buildMetadata } from "@/src/lib/seo";
import { SectionHeader } from "@/components/CategoriesGrid";

export const metadata: Metadata = buildMetadata({
  title: "Hakkımızda",
  path: "/hakkimizda",
  description:
    "MNR Petrol Tarım İnş. San. Tic. Ltd. Şti. — 2008'den bu yana Akdeniz bölgesinde madeni yağ tedariğinde güvenilir çözüm ortağı.",
});

type Feature = {
  title: string;
  body: string;
  icon: "verified" | "support" | "truck";
};

const features: readonly Feature[] = [
  {
    title: "Kalite Güvencesi",
    body: "Tüm ürünlerimiz uluslararası standartlara uygun olarak tedarik edilir.",
    icon: "verified",
  },
  {
    title: "Uzman Destek",
    body: "Deneyimli ekibimiz, size en uygun ürünü seçmenizde yardımcı olur.",
    icon: "support",
  },
  {
    title: "Hızlı Teslimat",
    body: "Geniş stok ağımız ile siparişlerinizi zamanında teslim ediyoruz.",
    icon: "truck",
  },
] as const;

export default function HakkimizdaPage() {
  return (
    <>
      <section className="bg-gradient-to-b from-white to-[var(--color-surface-alt)] py-16">
        <div className="container-page grid items-center gap-12 md:grid-cols-[1fr_1.3fr]">
          <div className="flex justify-center">
            <div className="rounded-2xl bg-white p-8 shadow-md ring-1 ring-[var(--color-border)]">
              <Image
                src="/logo.webp"
                alt="MNR Petrol"
                width={240}
                height={80}
                className="h-20 w-auto object-contain"
                priority
              />
            </div>
          </div>
          <div>
            <div className="flex items-center gap-3">
              <span className="h-px w-10 bg-[var(--color-brand)]" />
              <span className="text-xs font-bold uppercase tracking-[0.25em] text-[var(--color-brand)]">
                Hakkımızda
              </span>
            </div>
            <h1 className="mt-3 text-4xl font-bold text-[var(--color-ink)] sm:text-5xl">
              MNR Petrol Tarım İnş. San. Tic. Ltd. Şti.
            </h1>
            <p className="mt-2 text-sm font-semibold uppercase tracking-wider text-[var(--color-ink-muted)]">
              Antalya Madeni Yağ
            </p>
            <p className="mt-6 text-lg leading-relaxed text-[var(--color-ink-soft)]">
              2008 yılında kurulan firmamız, Akdeniz bölgesinde otomotiv ve
              endüstriyel sektörlerin madeni yağ ihtiyacını karşılayan güvenilir
              çözüm ortağınızdır. Yılların deneyimiyle, kaliteli ürünler ve
              profesyonel hizmet anlayışımızla müşterilerimize değer katıyoruz.
            </p>
          </div>
        </div>
      </section>

      <section className="bg-white py-16">
        <div className="container-page">
          <SectionHeader
            kicker="Yaklaşımımız"
            title="Neden MNR Petrol?"
            subtitle="Geniş ürün yelpazemiz ve uzman kadromuzla, madeni yağ konusunda her alanda siz saygıdeğer müşterilerimizin ihtiyacını karşılamak için çalışıyoruz."
          />
          <ul className="mt-12 grid gap-6 md:grid-cols-3">
            {features.map((f) => (
              <li
                key={f.title}
                className="group rounded-2xl border border-[var(--color-border)] bg-white p-8 transition-all duration-300 hover:-translate-y-1 hover:border-[var(--color-brand)]/30 hover:shadow-lg"
              >
                <div className="flex h-12 w-12 items-center justify-center rounded-xl bg-[var(--color-brand)]/10 text-[var(--color-brand)] transition-colors group-hover:bg-[var(--color-brand)] group-hover:text-white">
                  <FeatureIcon kind={f.icon} />
                </div>
                <h3 className="mt-5 text-lg font-semibold text-[var(--color-ink)]">
                  {f.title}
                </h3>
                <p className="mt-2 text-sm leading-relaxed text-[var(--color-ink-soft)]">
                  {f.body}
                </p>
              </li>
            ))}
          </ul>
        </div>
      </section>

      <section className="bg-[var(--color-surface-alt)] py-16">
        <div className="container-page max-w-4xl">
          <SectionHeader kicker="Faaliyetimiz" title="Ar-Ge ve Teknik Destek" />
          <div className="mt-8 space-y-6 text-center text-lg leading-relaxed text-[var(--color-ink-soft)]">
            <p>
              Partneri olduğumuz firmaların yurt dışı ve yurt içi Ar-Ge
              departmanları ile koordineli olarak çalışmakta, sektörün ihtiyacı
              olan özel ürünlerin oluşması ve sahaya sunulmasında öncülük
              etmekteyiz. Tamamı ile teknik ekiple hizmet veren firmamız, araç
              ve endüstriyel ekipmanlarınızın performansını maksimize etmek için
              en uygun yağlama çözümlerini sunmaktadır.
            </p>
            <p>
              Nakliye sektöründe büyük bir yenilik olarak hayata geçirdiğimiz{" "}
              <a
                href="https://yukunolsun.com"
                target="_blank"
                rel="noopener noreferrer"
                className="font-bold text-[var(--color-brand)] underline underline-offset-4"
              >
                yukunolsun.com
              </a>{" "}
              platformumuz, araç sahipleri ile yük sahiplerini bir araya
              getiren inovatif bir dijital çözümdür. Modern teknoloji
              altyapımız ve güçlü yazılım sistemimiz sayesinde, nakliye
              süreçlerini hızlandırıyor, maliyetleri düşürüyor ve lojistik
              operasyonlarını optimize ediyoruz.
            </p>
            <p>
              Geniş araç filomuz ve deneyimli ekibimizle, sektörde dijital
              dönüşüme öncülük ederek müşterilerimize en verimli ve güvenilir
              hizmeti sunmaktayız.
            </p>
          </div>
        </div>
      </section>

      <section className="bg-[var(--color-ink)] py-16 text-white">
        <div className="container-page flex flex-col items-center gap-6 text-center">
          <h2 className="text-3xl font-bold sm:text-4xl">
            Birlikte çalışalım
          </h2>
          <p className="max-w-xl text-white/80">
            İhtiyacınız olan ürün hakkında bilgi almak veya özel bir çözüm için
            bize ulaşın.
          </p>
          <div className="flex flex-wrap justify-center gap-3">
            <Link
              href="/urunler"
              className="inline-flex items-center gap-2 rounded-full bg-[var(--color-brand)] px-6 py-3 text-sm font-bold uppercase tracking-wide shadow-lg shadow-[var(--color-brand)]/30 transition-colors hover:bg-[var(--color-brand-dark)]"
            >
              Ürünleri İncele
            </Link>
            <Link
              href="/#iletisim"
              className="inline-flex items-center gap-2 rounded-full border-2 border-white px-6 py-3 text-sm font-bold uppercase tracking-wide transition-colors hover:bg-white/10"
            >
              İletişime Geç
            </Link>
          </div>
        </div>
      </section>
    </>
  );
}

function FeatureIcon({ kind }: { kind: Feature["icon"] }) {
  const common = {
    width: 24,
    height: 24,
    viewBox: "0 0 24 24",
    fill: "none",
    stroke: "currentColor",
    strokeWidth: 2,
    strokeLinecap: "round" as const,
    strokeLinejoin: "round" as const,
    "aria-hidden": true,
  };
  if (kind === "verified") {
    return (
      <svg {...common}>
        <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z" />
        <polyline points="9 12 11 14 15 10" />
      </svg>
    );
  }
  if (kind === "support") {
    return (
      <svg {...common}>
        <path d="M3 18v-6a9 9 0 0 1 18 0v6" />
        <path d="M21 19a2 2 0 0 1-2 2h-1v-6h3v4zM3 19a2 2 0 0 0 2 2h1v-6H3v4z" />
      </svg>
    );
  }
  return (
    <svg {...common}>
      <rect x="1" y="3" width="15" height="13" />
      <polygon points="16 8 20 8 23 11 23 16 16 16 16 8" />
      <circle cx="5.5" cy="18.5" r="2.5" />
      <circle cx="18.5" cy="18.5" r="2.5" />
    </svg>
  );
}
