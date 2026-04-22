/**
 * One-shot asset optimization: assets/images/* → public/* (WebP, right-sized).
 * Run: npm run optimize-images
 */
import { promises as fs } from "node:fs";
import { fileURLToPath } from "node:url";
import path from "node:path";
import sharp from "sharp";

const ROOT = path.resolve(path.dirname(fileURLToPath(import.meta.url)), "..");
const SRC = path.join(ROOT, "assets", "images");
const OUT = path.join(ROOT, "public");

type Job = {
  src: string;
  dst: string;
  maxWidth: number;
  quality: number;
};

const BRAND_FOLDERS = new Set([
  "borax",
  "brava",
  "japanoil",
  "xenol",
  "oilport",
  "skynell",
]);

const CATEGORY_RENAMES: Record<string, string> = {
  "motor-yaglari.png": "categories/motor-yaglari.webp",
  "motorsiklet-yaglari.png": "categories/motorsiklet-yaglari.webp",
  "sanziman.png": "categories/sanziman.webp",
  "motor-bakim.png": "categories/hidrolik.webp",
  "sarf-malzemeler.png": "categories/sarf-malzemeler.webp",
  "antifiriz.png": "categories/antifiriz.webp",
};

const HERO_RENAMES: Record<string, string> = {
  "banner.jpg": "hero/banner.webp",
  "iletisim-arkaplan.jpg": "hero/iletisim.webp",
  "mnr-petrol.jpg": "logo.webp",
};

async function walk(dir: string): Promise<string[]> {
  const entries = await fs.readdir(dir, { withFileTypes: true });
  const files = await Promise.all(
    entries.map(async (e) => {
      const full = path.join(dir, e.name);
      return e.isDirectory() ? walk(full) : [full];
    }),
  );
  return files.flat();
}

function classify(rel: string): Omit<Job, "src"> | null {
  const parts = rel.split(path.sep);

  if (parts[0] === "logos" && parts[1]) {
    return {
      dst: `brands/${path.parse(parts[1]).name}.webp`,
      maxWidth: 320,
      quality: 90,
    };
  }

  if (parts[0] && BRAND_FOLDERS.has(parts[0])) {
    const file = parts[parts.length - 1];
    if (!file) return null;
    return {
      dst: `products/${parts[0]}/${path.parse(file).name}.webp`,
      maxWidth: 800,
      quality: 82,
    };
  }

  if (parts.length === 1 && parts[0]) {
    const file = parts[0];
    if (CATEGORY_RENAMES[file]) {
      return { dst: CATEGORY_RENAMES[file], maxWidth: 640, quality: 82 };
    }
    if (HERO_RENAMES[file]) {
      return { dst: HERO_RENAMES[file], maxWidth: 1600, quality: 82 };
    }
  }

  return null;
}

async function processJob(job: Job): Promise<{ from: number; to: number }> {
  const srcStat = await fs.stat(job.src);
  const outPath = path.join(OUT, job.dst);
  await fs.mkdir(path.dirname(outPath), { recursive: true });

  const image = sharp(job.src).rotate();
  const meta = await image.metadata();
  const needsResize = (meta.width ?? 0) > job.maxWidth;

  await (needsResize
    ? image.resize({ width: job.maxWidth, withoutEnlargement: true })
    : image
  )
    .webp({ quality: job.quality, effort: 5 })
    .toFile(outPath);

  const dstStat = await fs.stat(outPath);
  return { from: srcStat.size, to: dstStat.size };
}

async function ensurePwaIcons(): Promise<void> {
  const webIcons = path.join(ROOT, "web", "icons");
  const mapping: Record<string, string> = {
    "Icon-192.png": "icon-192.png",
    "Icon-512.png": "icon-512.png",
    "Icon-maskable-192.png": "icon-maskable-192.png",
    "Icon-maskable-512.png": "icon-maskable-512.png",
  };

  for (const [src, dst] of Object.entries(mapping)) {
    const srcPath = path.join(webIcons, src);
    try {
      await fs.access(srcPath);
    } catch {
      continue;
    }
    const outPath = path.join(OUT, dst);
    const size = src.includes("192") ? 192 : 512;
    await sharp(srcPath)
      .resize(size, size, { fit: "cover" })
      .png({ compressionLevel: 9 })
      .toFile(outPath);
    console.log(`  pwa: ${src} → /${dst}`);
  }

  const faviconSrc = path.join(ROOT, "web", "favicon.png");
  try {
    await fs.access(faviconSrc);
    await fs.copyFile(faviconSrc, path.join(OUT, "favicon.png"));
    console.log("  pwa: favicon.png → /favicon.png");
  } catch {
    /* ignore */
  }
}

function fmtBytes(n: number): string {
  if (n < 1024) return `${n} B`;
  if (n < 1024 * 1024) return `${(n / 1024).toFixed(1)} KB`;
  return `${(n / (1024 * 1024)).toFixed(2)} MB`;
}

async function main(): Promise<void> {
  const allFiles = await walk(SRC);
  const jobs: Job[] = [];
  const skipped: string[] = [];

  for (const abs of allFiles) {
    const rel = path.relative(SRC, abs);
    const cls = classify(rel);
    if (cls) jobs.push({ src: abs, ...cls });
    else skipped.push(rel);
  }

  console.log(`Found ${allFiles.length} source files → ${jobs.length} jobs, ${skipped.length} skipped`);

  let totalFrom = 0;
  let totalTo = 0;
  for (const job of jobs) {
    const { from, to } = await processJob(job);
    totalFrom += from;
    totalTo += to;
    console.log(
      `  ${path.relative(SRC, job.src)} → /${job.dst}  (${fmtBytes(from)} → ${fmtBytes(to)})`,
    );
  }

  await ensurePwaIcons();

  console.log("");
  console.log(`Total: ${fmtBytes(totalFrom)} → ${fmtBytes(totalTo)}  (saved ${fmtBytes(totalFrom - totalTo)})`);
  if (skipped.length > 0) {
    console.log(`Skipped: ${skipped.join(", ")}`);
  }
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
