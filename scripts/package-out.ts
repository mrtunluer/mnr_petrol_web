/**
 * Packages the `out/` directory into a deployable zip for Hostinger/GoDaddy.
 * Run: npm run package
 * Output: dist/mnr-petrol-site.zip
 */
import { promises as fs } from "node:fs";
import { createWriteStream } from "node:fs";
import { fileURLToPath } from "node:url";
import path from "node:path";
import { spawn } from "node:child_process";

const ROOT = path.resolve(
  path.dirname(fileURLToPath(import.meta.url)),
  "..",
);
const OUT_DIR = path.join(ROOT, "out");
const DIST_DIR = path.join(ROOT, "dist");
const ZIP_PATH = path.join(DIST_DIR, "mnr-petrol-site.zip");

async function fileExists(p: string): Promise<boolean> {
  try {
    await fs.access(p);
    return true;
  } catch {
    return false;
  }
}

async function main(): Promise<void> {
  if (!(await fileExists(OUT_DIR))) {
    console.error(
      "out/ klasörü bulunamadı. Önce `npm run build` çalıştırın.",
    );
    process.exit(1);
  }

  await fs.mkdir(DIST_DIR, { recursive: true });
  await fs.rm(ZIP_PATH, { force: true });

  console.log(`Packaging ${OUT_DIR} → ${ZIP_PATH}`);

  const zip = spawn("zip", ["-rq9", ZIP_PATH, "."], {
    cwd: OUT_DIR,
    stdio: "inherit",
  });

  await new Promise<void>((resolve, reject) => {
    zip.on("exit", (code) => {
      if (code === 0) resolve();
      else reject(new Error(`zip exited with code ${code}`));
    });
    zip.on("error", reject);
  });

  const stat = await fs.stat(ZIP_PATH);
  const mb = (stat.size / (1024 * 1024)).toFixed(2);
  console.log(`\n✓ ${ZIP_PATH} (${mb} MB)`);
  console.log("");
  console.log("Yükleme adımları:");
  console.log(
    "  1. Hostinger/GoDaddy File Manager → public_html/ klasörüne gir",
  );
  console.log(
    "  2. mnr-petrol-site.zip'i yükle, sağ tık → Extract",
  );
  console.log("  3. Extract sonrası zip'i sil");
  console.log("");
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
