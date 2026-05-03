/**
 * Form endpoint — production'da `.env.production` üzerinden override edilebilir:
 *   NEXT_PUBLIC_FORM_EMAIL=info@ornek.com
 * Boş ise fallback olarak gömülü adrese gider.
 */
const formEmail =
  process.env.NEXT_PUBLIC_FORM_EMAIL?.trim() || "ugurunluer@gmail.com";

export const FORM_ENDPOINT = `https://formsubmit.co/ajax/${formEmail}`;
