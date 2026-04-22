import Link from "next/link";

type Action = {
  label: string;
  href: string;
};

type Props = {
  kicker: string;
  title: string;
  description?: string;
  action?: Action;
  tone?: "light" | "dark";
};

export default function SectionHeader({
  kicker,
  title,
  description,
  action,
  tone = "light",
}: Props) {
  const isDark = tone === "dark";
  return (
    <div className="flex flex-col items-start justify-between gap-4 md:flex-row md:items-end">
      <div>
        <div
          className={`text-[10px] font-bold uppercase tracking-[0.3em] ${
            isDark ? "text-[var(--color-brand)]" : "text-[var(--color-brand)]"
          }`}
        >
          {kicker}
        </div>
        <h2
          className={`mt-2 text-3xl font-semibold tracking-tight sm:text-4xl ${
            isDark ? "text-white" : "text-[var(--color-ink)]"
          }`}
        >
          {title}
        </h2>
        {description && (
          <p
            className={`mt-3 max-w-xl text-sm leading-relaxed ${
              isDark ? "text-white/70" : "text-[var(--color-ink-soft)]"
            }`}
          >
            {description}
          </p>
        )}
      </div>
      {action && (
        <Link
          href={action.href}
          className={`group inline-flex items-center gap-2 border-b pb-1 text-xs font-semibold uppercase tracking-[0.22em] transition-colors ${
            isDark
              ? "border-white text-white hover:border-[var(--color-brand)] hover:text-[var(--color-brand)]"
              : "border-[var(--color-ink)] text-[var(--color-ink)] hover:border-[var(--color-brand)] hover:text-[var(--color-brand)]"
          }`}
        >
          {action.label}
          <svg
            width="12"
            height="12"
            viewBox="0 0 24 24"
            fill="none"
            stroke="currentColor"
            strokeWidth="2"
            strokeLinecap="round"
            strokeLinejoin="round"
            className="transition-transform group-hover:translate-x-0.5"
            aria-hidden="true"
          >
            <line x1="5" y1="12" x2="19" y2="12" />
            <polyline points="12 5 19 12 12 19" />
          </svg>
        </Link>
      )}
    </div>
  );
}
