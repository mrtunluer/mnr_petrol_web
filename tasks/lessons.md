# Lessons Learned — MNR Petrol Next.js Migration

## Node.js / TypeScript

- **Avoid shadowing `process` in scripts.** Declaring `async function process(...)` in a script that later calls `process.exit(1)` causes TS to resolve `process` to the local function. Rename worker functions (e.g. `processJob`).
- **`process.cwd()` under `tsx` + Node 24**: surfaced a confusing `TypeError` when used at top-level. Prefer `path.dirname(fileURLToPath(import.meta.url))` + `path.resolve(..., '..')` for root discovery in one-shot scripts.

## Next.js 15

- **Pin a patched version.** `next@15.1.6` carries CVE-2025-66478. Default to `15.5.x` or newer when scaffolding.
- **Dynamic route params are async.** In `app/urun/[id]/page.tsx`, types are `{ params: Promise<{ id: string }> }` — `await` before use.
- **`generateStaticParams` + `generateMetadata`** together give per-product prerendered HTML plus per-product OG tags — essential for SEO on catalog sites.

## Image pipeline

- **WebP at q=82 is the sweet spot** for product photography on white backgrounds — ~75–85% size reduction vs PNG with no visible quality loss.
- **Right-size upstream, not at runtime.** Flutter pushed 800×800 PNGs to browsers; Next.js `next/image` + a build-time `sharp` resize avoids shipping any redundant pixels.
- **`optimize-images.ts` is idempotent** — safe to re-run, overwrites existing WebP.

## Architecture decisions

- **Static data (`src/data/*.ts`) over headless CMS** fits a catalog that changes rarely; eliminates a network hop and a runtime dependency. Revisit if the catalog grows past ~500 SKUs or non-technical editors need to update content.
- **Query params for filtering** (`/urunler?marka=borax`) keep the page SSG-able and make filter state shareable/bookmarkable without any client routing library.

## Content migration pitfalls

- **SEO metadata is not a source of truth.** `web/index.html` JSON-LD had stale phone (`+90 551 …`) and address (Ataşehir/İstanbul); the actual rendered UI in `main.dart` had the correct data (`+90 532 562 71 23`, Konyaaltı/Antalya). When both exist, **trust the UI code** — it's what customers saw.
  Why: index.html SEO blocks are often copy-pasted once and never updated; the Flutter UI gets shipped every day.
  How to apply: for any future data migration, cross-reference business data across every place it appears (UI, JSON-LD, `<meta>` tags) and flag conflicts explicitly to the user before choosing a source.

- **Don't skim a 9.8k-line monolith.** First migration pass I only read the hero; missed sub-menus ("Sarf Malzemeler → Fren Hidrolik / Katkı"), the top info bar, the featured-products horizontal carousel, the product-detail feature cards, and the contact form's "Konu" field. Expensive rework.
  Why: in Flutter, UI *is* logic; structural details only surface when you read the full widget tree.
  How to apply: for any port from a large single-file codebase, spawn an Explore subagent per destination page with an explicit "list every section / text / interaction" brief before writing replacement code.

- **Don't invent data that isn't in the source.** I added `info@mnrpetrol.com` to `site.ts` / Footer / TopInfoBar based on nothing — the Flutter UI never displays an email. The real email (`ugurunluer@gmail.com`) is only used as a FormSubmit.co backend endpoint and is never shown to users. Customers were about to see a fake address.
  Why: filling gaps from imagination beats the user's trust; a wrong address on a commercial site causes lost leads.
  How to apply: before adding any displayed business data (email, phone, tax no., trade registry), grep the source codebase for where/how it's actually rendered. If it's not rendered anywhere, it's not public. Ask before fabricating.

- **Shared hosting forbids API routes.** Hostinger/GoDaddy shared plans are pure Apache — no Node. If the user commits to those, flip `output: 'export'` first thing and route the contact form to a 3rd-party endpoint (FormSubmit.co, Formspree, Web3Forms). Don't leave `/api/contact` half-working.
  Why: deploy day isn't the time to discover Next.js API routes don't exist on the target.
  How to apply: ask deploy target first if it isn't specified; if "shared hosting" or Hostinger Premium/Deluxe/Economy is mentioned, static export is the only path.

- **The harness's cwd persists across Bash calls.** After `cd /out` for a server test, a later `npx next build` fails with "Couldn't find any `pages` or `app` directory" because it runs from `out/`. Always `cd $PROJECT_ROOT` at the top of multi-step scripts, or use `pushd`/`popd`.
