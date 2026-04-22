import Image from "next/image";
import ContactForm from "./ContactForm";
import { site } from "@/src/lib/site";

export default function ContactSection() {
  return (
    <section
      id="iletisim"
      className="relative isolate overflow-hidden bg-[var(--color-ink)] text-white"
    >
      <Image
        src="/hero/iletisim.webp"
        alt=""
        fill
        sizes="100vw"
        className="-z-10 object-cover opacity-30"
      />
      <div className="-z-10 absolute inset-0 bg-gradient-to-b from-black/75 to-black/85" />

      <div className="container-page py-20">
        <div className="mx-auto max-w-2xl text-center">
          <div className="flex items-center justify-center gap-3">
            <span className="h-px w-10 bg-[var(--color-brand)]" />
            <span className="text-xs font-bold uppercase tracking-[0.25em] text-white/90">
              İletişim
            </span>
            <span className="h-px w-10 bg-[var(--color-brand)]" />
          </div>
          <h2 className="mt-3 text-3xl font-bold sm:text-4xl">Bize Ulaşın</h2>
          <p className="mt-4 text-base text-white/80">
            Sorularınız için her zaman yanınızdayız.
          </p>
        </div>

        <div className="mt-12 grid gap-8 lg:grid-cols-[1fr_1.4fr]">
          <aside className="space-y-6">
            <InfoCard
              icon={<PhoneIcon />}
              title="Telefon"
              value={site.phone}
              sub="Hafta içi 09:00 - 18:00"
              href={`tel:${site.phone.replace(/\s+/g, "")}`}
            />
            <InfoCard
              icon={<PinIcon />}
              title="Adres"
              value={site.address.street}
              sub={`${site.address.district} / ${site.address.city}`}
            />
          </aside>

          <div className="rounded-2xl border border-[var(--color-border)] bg-white p-6 text-[var(--color-ink)] shadow-2xl sm:p-8">
            <header className="mb-5">
              <h3 className="text-xl font-bold">Mesaj Gönderin</h3>
              <p className="mt-1 text-sm text-[var(--color-ink-soft)]">
                Formu doldurun, size en kısa sürede geri dönüş yapalım.
              </p>
            </header>
            <ContactForm />
          </div>
        </div>
      </div>
    </section>
  );
}

function InfoCard({
  icon,
  title,
  value,
  sub,
  href,
}: {
  icon: React.ReactNode;
  title: string;
  value: string;
  sub?: string;
  href?: string;
}) {
  const content = (
    <div className="flex items-start gap-4 rounded-xl border border-white/15 bg-white/5 p-5 backdrop-blur-sm transition-colors hover:bg-white/10">
      <span className="flex h-12 w-12 shrink-0 items-center justify-center rounded-full bg-[var(--color-brand)] text-white shadow-lg shadow-[var(--color-brand)]/40">
        {icon}
      </span>
      <div>
        <div className="text-xs font-semibold uppercase tracking-wider text-white/70">
          {title}
        </div>
        <div className="mt-1 text-base font-semibold text-white">{value}</div>
        {sub && (
          <div className="mt-0.5 text-xs text-white/70">{sub}</div>
        )}
      </div>
    </div>
  );
  return href ? <a href={href}>{content}</a> : content;
}

function PhoneIcon() {
  return (
    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
      <path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z" />
    </svg>
  );
}

function PinIcon() {
  return (
    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
      <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z" />
      <circle cx="12" cy="10" r="3" />
    </svg>
  );
}

