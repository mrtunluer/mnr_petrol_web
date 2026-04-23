import { site } from "@/src/lib/site";

export default function TopInfoBar() {
  const phoneHref = `tel:${site.phone.replace(/\s+/g, "")}`;
  const fullAddress = `${site.address.street}, ${site.address.district} / ${site.address.city}`;

  return (
    <div className="hidden bg-[#1e293b] text-white md:block">
      <div className="container-page flex h-9 items-center justify-between text-xs">
        <div className="flex items-center gap-5">
          <a
            href={phoneHref}
            className="inline-flex items-center gap-1.5 text-white/85 transition-colors hover:text-white"
          >
            <PhoneIcon />
            <span className="font-medium">{site.phone}</span>
          </a>
          <span className="hidden items-center gap-1.5 text-white/75 lg:inline-flex">
            <PinIcon />
            {fullAddress}
          </span>
        </div>
        <div className="flex items-center gap-4 text-white/75">
          <span className="inline-flex items-center gap-1.5">
            <ClockIcon />
            Pzt–Cmt: 09:00–18:00
          </span>
        </div>
      </div>
    </div>
  );
}

function PhoneIcon() {
  return (
    <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
      <path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z" />
    </svg>
  );
}

function PinIcon() {
  return (
    <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
      <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z" />
      <circle cx="12" cy="10" r="3" />
    </svg>
  );
}

function ClockIcon() {
  return (
    <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
      <circle cx="12" cy="12" r="10" />
      <polyline points="12 6 12 12 16 14" />
    </svg>
  );
}
