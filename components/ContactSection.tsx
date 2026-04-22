import ContactForm from "./ContactForm";
import { site } from "@/src/lib/site";

export default function ContactSection() {
  return (
    <section id="iletisim" className="bg-[var(--color-night)] pt-24 pb-0 text-white">
      <div className="container-page">
        <div className="flex flex-col items-start justify-between gap-4 border-b border-white/10 pb-10 md:flex-row md:items-end">
          <div>
            <div className="text-[10px] font-bold uppercase tracking-[0.3em] text-[var(--color-brand)]">
              İletişim
            </div>
            <h2 className="mt-2 text-3xl font-semibold tracking-tight text-white sm:text-4xl">
              Bize Ulaşın
            </h2>
            <p className="mt-3 max-w-xl text-sm leading-relaxed text-white/70">
              Teknik danışmanlık, bayi başvurusu ve özel fiyat talepleri için
              formu doldurabilir ya da doğrudan telefonla ulaşabilirsiniz.
            </p>
          </div>
          <div className="text-sm text-white/60">
            Pzt – Cmt · 09:00 – 18:00
          </div>
        </div>

        <div className="mt-12 grid gap-0 pb-24 md:grid-cols-12 md:divide-x md:divide-white/10">
          <div className="md:col-span-5 md:pr-10">
            <ul className="divide-y divide-white/10">
              <InfoRow
                num="01"
                label="Telefon"
                title={site.phone}
                sub="Hafta içi 09:00 – 18:00"
                href={`tel:${site.phone.replace(/\s+/g, "")}`}
              />
              <InfoRow
                num="02"
                label="Adres"
                title={site.address.street}
                sub={`${site.address.district} / ${site.address.city}`}
              />
              <InfoRow
                num="03"
                label="Şirket"
                title={site.legalName}
                sub={site.tagline}
              />
            </ul>
          </div>

          <div className="pt-10 md:col-span-7 md:pl-10 md:pt-0">
            <div className="mb-6">
              <div className="font-mono text-xs font-medium text-white/40">
                — Form
              </div>
              <h3 className="mt-2 text-xl font-semibold text-white">
                Mesaj gönderin
              </h3>
              <p className="mt-1 text-sm text-white/60">
                Formu doldurun, en kısa sürede geri dönüş yapalım.
              </p>
            </div>
            <ContactForm tone="dark" />
          </div>
        </div>
      </div>
    </section>
  );
}

function InfoRow({
  num,
  label,
  title,
  sub,
  href,
}: {
  num: string;
  label: string;
  title: string;
  sub?: string;
  href?: string;
}) {
  const content = (
    <div className="py-5">
      <div className="flex items-center gap-3">
        <span className="font-mono text-xs font-medium text-white/40">
          — {num}
        </span>
        <span className="text-[10px] font-semibold uppercase tracking-[0.22em] text-white/50">
          {label}
        </span>
      </div>
      <div className="mt-2 text-lg font-semibold leading-snug text-white">
        {title}
      </div>
      {sub && (
        <div className="mt-1 text-sm text-white/60">{sub}</div>
      )}
    </div>
  );
  return (
    <li>
      {href ? (
        <a
          href={href}
          className="group block transition-colors hover:bg-white/[0.03]"
        >
          {content}
        </a>
      ) : (
        content
      )}
    </li>
  );
}
