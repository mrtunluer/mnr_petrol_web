export type Venture = {
  slug: string;
  num: string;
  name: string;
  domain: string;
  sector: string;
  tagline: string;
  description: string;
  features: readonly string[];
  detailFeatures: readonly string[];
  audience: string;
  pricing: string;
  href: string;
  logo: string;
  logoBg: string;
};

export const ventures: readonly Venture[] = [
  {
    slug: "tamir-defteri",
    num: "01",
    name: "Tamir Defteri",
    domain: "tamirdefteri.com",
    sector: "Atölye Yönetim Yazılımı",
    tagline: "Sanayinin dijital atölyesi",
    description:
      "Oto tamir ve servis işletmelerine yönelik dijital yönetim platformu. Sesli kayıt teknolojisi, müşteri/araç profilleri, parça takibi, otomatik bakım hatırlatmaları ve SMS bildirimleriyle defter kalem ihtiyacını ortadan kaldırır.",
    features: [
      "Sesli veri girişi",
      "Otomatik bakım hatırlatma",
      "SMS bildirimi",
      "30 gün ücretsiz deneme",
    ],
    detailFeatures: [
      "Sesli veri girişi",
      "Otomatik bakım hatırlatma",
      "SMS bildirimi",
      "Müşteri ve araç profilleri",
      "Parça hareket takibi",
      "Çalışan görev atama",
    ],
    audience: "Oto tamir & servis işletmeleri",
    pricing: "30 gün ücretsiz deneme",
    href: "https://tamirdefteri.com",
    logo: "/ventures/tamirdefteri.webp",
    logoBg: "bg-[var(--color-ink)]",
  },
  {
    slug: "yukunolsun",
    num: "02",
    name: "YükünOlsun",
    domain: "yukunolsun.com",
    sector: "Dijital Taşımacılık Pazaryeri",
    tagline: "Yüksüz kalma",
    description:
      "Yük sahiplerini ve taşıyıcıları sıfır komisyonlu dijital pazaryerinde buluşturan platform. Yapay zeka destekli akıllı eşleştirme, dorse ve araç filtreleme, gerçek zamanlı ilan yönetimiyle boş dönüşleri azaltır.",
    features: [
      "10.000+ kayıtlı taşıyıcı",
      "Günlük 15.000+ ilan",
      "81 il kapsamı",
      "Sıfır komisyon",
    ],
    detailFeatures: [
      "10.000+ kayıtlı taşıyıcı",
      "Günlük 15.000+ ilan",
      "81 il kapsamı",
      "Sıfır komisyon",
      "AI destekli eşleştirme",
      "Doğrulanmış üyeler",
    ],
    audience: "Yük sahipleri & taşıyıcılar",
    pricing: "Tamamen ücretsiz",
    href: "https://yukunolsun.com",
    logo: "/ventures/yukunolsun.webp",
    logoBg: "bg-white",
  },
] as const;
