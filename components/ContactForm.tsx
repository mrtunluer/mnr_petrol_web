"use client";

import { useState, useTransition } from "react";
import { FORM_ENDPOINT } from "@/src/lib/form-endpoint";

type Status =
  | { kind: "idle" }
  | { kind: "ok"; message: string }
  | { kind: "error"; message: string };

export default function ContactForm() {
  const [status, setStatus] = useState<Status>({ kind: "idle" });
  const [isPending, startTransition] = useTransition();

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
        <Field label="Ad Soyad" required>
          <input
            name="name"
            required
            autoComplete="name"
            className="field-input"
          />
        </Field>
        <Field label="E-posta" required>
          <input
            name="email"
            type="email"
            required
            autoComplete="email"
            className="field-input"
          />
        </Field>
      </div>

      <div className="grid gap-4 sm:grid-cols-2">
        <Field label="Telefon">
          <input
            name="phone"
            type="tel"
            autoComplete="tel"
            className="field-input"
          />
        </Field>
        <Field label="Konu">
          <input name="subject" className="field-input" />
        </Field>
      </div>

      <Field label="Mesajınız" required>
        <textarea
          name="message"
          required
          rows={5}
          className="field-input resize-y"
        />
      </Field>

      {status.kind !== "idle" && (
        <div
          role={status.kind === "error" ? "alert" : "status"}
          className={`rounded-lg border p-3 text-sm ${
            status.kind === "ok"
              ? "border-green-200 bg-green-50 text-green-800"
              : "border-red-200 bg-red-50 text-red-800"
          }`}
        >
          {status.message}
        </div>
      )}

      <button
        type="submit"
        disabled={isPending}
        className="inline-flex w-full items-center justify-center gap-2 rounded-full bg-[var(--color-brand)] px-6 py-3.5 text-sm font-bold uppercase tracking-wide text-white shadow-lg shadow-[var(--color-brand)]/30 transition-all hover:bg-[var(--color-brand-dark)] disabled:cursor-not-allowed disabled:opacity-60"
      >
        {isPending ? "Gönderiliyor..." : "Mesajı Gönder"}
      </button>

      <style>{`
        .field-input {
          display: block;
          width: 100%;
          border-radius: 0.625rem;
          border: 1px solid var(--color-border);
          background: #fff;
          padding: 0.75rem 1rem;
          font-size: 0.9375rem;
          color: var(--color-ink);
          outline: none;
          transition: border-color .15s, box-shadow .15s;
        }
        .field-input:focus {
          border-color: var(--color-brand);
          box-shadow: 0 0 0 3px rgba(215, 25, 32, 0.15);
        }
      `}</style>
    </form>
  );
}

function Field({
  label,
  required,
  children,
}: {
  label: string;
  required?: boolean;
  children: React.ReactNode;
}) {
  return (
    <label className="block">
      <span className="mb-1.5 block text-xs font-semibold uppercase tracking-wider text-[var(--color-ink-soft)]">
        {label}
        {required && <span className="text-[var(--color-brand)]"> *</span>}
      </span>
      {children}
    </label>
  );
}
