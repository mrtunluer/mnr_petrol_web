import type { ReactNode } from "react";

type Props = { text: string };

const HEADING_KEYWORDS = [
  "Tanım",
  "Özellik",
  "Fayda",
  "Kullanım",
  "Alan",
  "Avantaj",
];

function isHeading(line: string): boolean {
  if (line.startsWith("•") || line.startsWith("-")) return false;
  const trimmed = line.trim();
  if (!trimmed) return false;
  if (HEADING_KEYWORDS.some((k) => trimmed.includes(k))) return true;
  return trimmed.length < 50 && !trimmed.endsWith(".") && !trimmed.endsWith(",");
}

export default function FormattedDescription({ text }: Props) {
  const lines = text.replace(/\r\n/g, "\n").split("\n");
  const nodes: ReactNode[] = [];

  lines.forEach((raw, idx) => {
    const line = raw.trim();
    if (!line) {
      nodes.push(<div key={`gap-${idx}`} className="h-3" aria-hidden="true" />);
      return;
    }

    if (line.startsWith("•") || line.startsWith("-")) {
      const clean = line.replace(/^[•\-]\s*/, "");
      nodes.push(
        <div key={`b-${idx}`} className="flex gap-3">
          <span
            className="mt-[0.6em] h-1.5 w-1.5 shrink-0 rounded-full bg-[var(--color-brand)]"
            aria-hidden="true"
          />
          <p className="text-[15px] leading-relaxed text-[var(--color-ink-soft)]">
            {clean}
          </p>
        </div>,
      );
      return;
    }

    if (isHeading(line)) {
      nodes.push(
        <div key={`h-${idx}`} className="mt-4 flex items-start gap-2.5">
          <span
            className="mt-1 h-5 w-1 shrink-0 rounded-sm bg-[var(--color-brand)]"
            aria-hidden="true"
          />
          <h3 className="text-[15px] font-extrabold leading-snug text-[var(--color-ink)]">
            {line}
          </h3>
        </div>,
      );
      return;
    }

    nodes.push(
      <p
        key={`p-${idx}`}
        className="text-[15px] leading-relaxed text-[var(--color-ink-soft)]"
      >
        {line}
      </p>,
    );
  });

  return <div className="space-y-1.5">{nodes}</div>;
}
