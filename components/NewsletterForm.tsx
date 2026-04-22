"use client";

import { useState, useTransition } from "react";
import { FORM_ENDPOINT } from "@/src/lib/form-endpoint";

type Status = "idle" | "ok" | "error";

export default function NewsletterForm() {
  const [email, setEmail] = useState("");
  const [status, setStatus] = useState<Status>("idle");
  const [isPending, startTransition] = useTransition();

  function onSubmit(e: React.FormEvent<HTMLFormElement>): void {
    e.preventDefault();
    setStatus("idle");
    if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
      setStatus("error");
      return;
    }
    startTransition(async () => {
      try {
        const res = await fetch(FORM_ENDPOINT, {
          method: "POST",
          headers: {
            "content-type": "application/json",
            accept: "application/json",
          },
          body: JSON.stringify({
            email,
            _subject: `MNR Petrol — Yeni bülten aboneliği (${email})`,
            _template: "basic",
            _captcha: "false",
            type: "newsletter",
          }),
        });
        setStatus(res.ok ? "ok" : "error");
        if (res.ok) setEmail("");
      } catch {
        setStatus("error");
      }
    });
  }

  return (
    <form onSubmit={onSubmit} className="flex flex-col gap-3">
      <div className="flex flex-col gap-3 sm:flex-row">
        <div className="relative flex-1">
          <span className="pointer-events-none absolute left-4 top-1/2 -translate-y-1/2 text-white/40">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
              <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z" />
              <polyline points="22,6 12,13 2,6" />
            </svg>
          </span>
          <input
            type="email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            placeholder="E-posta adresiniz"
            aria-label="E-posta adresi"
            className="h-12 w-full border border-white/15 bg-white/5 pl-11 pr-4 text-sm text-white placeholder:text-white/35 focus:border-[var(--color-brand)] focus:bg-white/10 focus:outline-none"
            required
          />
        </div>
        <button
          type="submit"
          disabled={isPending}
          className="inline-flex h-12 items-center justify-center gap-2 bg-[var(--color-brand)] px-6 text-xs font-bold uppercase tracking-[0.22em] text-white transition-colors hover:bg-[var(--color-brand-dark)] disabled:cursor-not-allowed disabled:opacity-60"
        >
          {isPending ? "Gönderiliyor…" : "Abone Ol"}
          {!isPending && (
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
              <line x1="5" y1="12" x2="19" y2="12" />
              <polyline points="12 5 19 12 12 19" />
            </svg>
          )}
        </button>
      </div>
      {status !== "idle" && (
        <p
          role={status === "error" ? "alert" : "status"}
          className={`text-xs ${
            status === "ok" ? "text-emerald-300" : "text-red-300"
          }`}
        >
          {status === "ok"
            ? "✓ Bültene başarıyla abone oldunuz."
            : "⚠ Geçerli bir e-posta adresi girin."}
        </p>
      )}
    </form>
  );
}
