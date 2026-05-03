"use client";

import { useState, useTransition } from "react";
import { FORM_ENDPOINT } from "@/src/lib/form-endpoint";

type Status =
  | { kind: "idle" }
  | { kind: "ok"; message: string }
  | { kind: "error"; message: string };

type Props = {
  tone?: "light" | "dark";
};

export default function ContactForm({ tone = "light" }: Props) {
  const [status, setStatus] = useState<Status>({ kind: "idle" });
  const [isPending, startTransition] = useTransition();
  const isDark = tone === "dark";

  async function onSubmit(formData: FormData): Promise<void> {
    setStatus({ kind: "idle" });

    const payload = {
      name: String(formData.get("name") ?? "").trim(),
      email: String(formData.get("email") ?? "").trim(),
      phone: String(formData.get("phone") ?? "").trim(),
      subject: String(formData.get("subject") ?? "").trim(),
      message: String(formData.get("message") ?? "").trim(),
      website: String(formData.get("website") ?? ""),
    };

    if (payload.website) {
      setStatus({ kind: "ok", message: "✓ Mesajınız alındı." });
      return;
    }
    if (!payload.name || !payload.email || !payload.message) {
      setStatus({
        kind: "error",
        message: "⚠ Lütfen tüm zorunlu alanları doldurun.",
      });
      return;
    }
    if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(payload.email)) {
      setStatus({
        kind: "error",
        message: "⚠ Geçerli bir e-posta adresi girin.",
      });
      return;
    }

    try {
      const controller = new AbortController();
      const timeoutId = setTimeout(() => controller.abort(), 15_000);
      const res = await fetch(FORM_ENDPOINT, {
        method: "POST",
        headers: {
          "content-type": "application/json",
          accept: "application/json",
        },
        body: JSON.stringify({
          name: payload.name,
          email: payload.email,
          phone: payload.phone,
          subject: payload.subject,
          message: payload.message,
          _subject: payload.subject
            ? `MNR Petrol — ${payload.subject} (${payload.name})`
            : `MNR Petrol — Yeni iletişim mesajı (${payload.name})`,
          _template: "table",
          _captcha: "false",
        }),
        signal: controller.signal,
      });
      clearTimeout(timeoutId);
      if (!res.ok) {
        setStatus({
          kind: "error",
          message: "✗ Mesaj gönderilemedi. Lütfen tekrar deneyin.",
        });
        return;
      }
      setStatus({
        kind: "ok",
        message:
          "✓ Mesajınız başarıyla gönderildi! En kısa sürede dönüş yapacağız.",
      });
    } catch (err) {
      if (err instanceof DOMException && err.name === "AbortError") {
        setStatus({
          kind: "error",
          message: "✗ Bağlantı zaman aşımına uğradı. Lütfen tekrar deneyin.",
        });
        return;
      }
      setStatus({
        kind: "error",
        message:
          "✗ Bağlantı hatası. Lütfen internet bağlantınızı kontrol edin.",
      });
    }
  }

  const fieldClass = isDark
    ? "field-input-dark"
    : "field-input-light";

  return (
    <form
      onSubmit={(e) => {
        e.preventDefault();
        const fd = new FormData(e.currentTarget);
        const formEl = e.currentTarget;
        startTransition(async () => {
          await onSubmit(fd);
          if (status.kind !== "error") formEl.reset();
        });
      }}
      className="space-y-4"
      noValidate
    >
      <input
        type="text"
        name="website"
        tabIndex={-1}
        autoComplete="off"
        className="absolute h-0 w-0 opacity-0"
        aria-hidden="true"
      />

      <div className="grid gap-4 sm:grid-cols-2">
        <Field label="Ad Soyad" required tone={tone}>
          <input
            name="name"
            required
            autoComplete="name"
            className={fieldClass}
          />
        </Field>
        <Field label="E-posta" required tone={tone}>
          <input
            name="email"
            type="email"
            required
            autoComplete="email"
            className={fieldClass}
          />
        </Field>
      </div>

      <div className="grid gap-4 sm:grid-cols-2">
        <Field label="Telefon" tone={tone}>
          <input
            name="phone"
            type="tel"
            autoComplete="tel"
            className={fieldClass}
          />
        </Field>
        <Field label="Konu" tone={tone}>
          <input name="subject" className={fieldClass} />
        </Field>
      </div>

      <Field label="Mesajınız" required tone={tone}>
        <textarea
          name="message"
          required
          rows={5}
          className={`${fieldClass} resize-y`}
        />
      </Field>

      {status.kind !== "idle" && (
        <div
          role={status.kind === "error" ? "alert" : "status"}
          className={`border p-3 text-sm ${
            status.kind === "ok"
              ? isDark
                ? "border-emerald-500/40 bg-emerald-500/10 text-emerald-200"
                : "border-green-200 bg-green-50 text-green-800"
              : isDark
                ? "border-red-500/40 bg-red-500/10 text-red-200"
                : "border-red-200 bg-red-50 text-red-800"
          }`}
        >
          {status.message}
        </div>
      )}

      <button
        type="submit"
        disabled={isPending}
        className="inline-flex w-full items-center justify-center gap-2 bg-[var(--color-brand)] px-6 py-3.5 text-xs font-bold uppercase tracking-[0.22em] text-white transition-colors hover:bg-[var(--color-brand-dark)] disabled:cursor-not-allowed disabled:opacity-60"
      >
        {isPending ? "Gönderiliyor..." : "Mesajı Gönder"}
        {!isPending && (
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
            <line x1="5" y1="12" x2="19" y2="12" />
            <polyline points="12 5 19 12 12 19" />
          </svg>
        )}
      </button>

      <style>{`
        .field-input-light,
        .field-input-dark {
          display: block;
          width: 100%;
          padding: 0.75rem 1rem;
          font-size: 1rem;
          outline: none;
          transition: border-color .15s, background-color .15s, box-shadow .15s;
          border-width: 1px;
          border-style: solid;
        }
        .field-input-light {
          background: #fff;
          color: var(--color-ink);
          border-color: var(--color-border);
        }
        .field-input-light:focus {
          border-color: var(--color-brand);
          box-shadow: 0 0 0 3px rgba(215, 25, 32, 0.12);
        }
        .field-input-dark {
          background: rgba(255, 255, 255, 0.04);
          color: #fff;
          border-color: rgba(255, 255, 255, 0.12);
        }
        .field-input-dark::placeholder {
          color: rgba(255, 255, 255, 0.35);
        }
        .field-input-dark:focus {
          border-color: var(--color-brand);
          background: rgba(255, 255, 255, 0.06);
          box-shadow: 0 0 0 3px rgba(215, 25, 32, 0.2);
        }
      `}</style>
    </form>
  );
}

function Field({
  label,
  required,
  tone,
  children,
}: {
  label: string;
  required?: boolean;
  tone: "light" | "dark";
  children: React.ReactNode;
}) {
  const isDark = tone === "dark";
  return (
    <label className="block">
      <span
        className={`mb-1.5 block text-[10px] font-semibold uppercase tracking-[0.22em] ${
          isDark ? "text-white/60" : "text-[var(--color-ink-soft)]"
        }`}
      >
        {label}
        {required && <span className="text-[var(--color-brand)]"> *</span>}
      </span>
      {children}
    </label>
  );
}
