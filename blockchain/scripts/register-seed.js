// Register the seeded tenants + akreditasi onto the live AkreditasiRegistry,
// so the real upload→read-back document flow works against on-chain data.
const hre = require("hardhat");
const fs = require("fs");
const path = require("path");

async function main() {
  const depFile = path.join(__dirname, "..", "deployments", `${hre.network.name}-deployment.json`);
  const dep = JSON.parse(fs.readFileSync(depFile, "utf8"));
  const addr = dep.contracts.AkreditasiRegistry;
  const reg = await hre.ethers.getContractAt("AkreditasiRegistry", addr);
  console.log("AkreditasiRegistry:", addr);

  const tenants = [
    { id: 1, nama: "Institut Teknologi Sepuluh Nopember" },
    { id: 2, nama: "Politeknik Elektronika Negeri Surabaya" },
    { id: 3, nama: "Universitas Gadjah Mada" },
  ];
  for (const t of tenants) {
    try {
      const tx = await reg.registerTenant(t.id, t.nama);
      await tx.wait();
      console.log(`✓ tenant ${t.id} registered`);
    } catch (e) {
      console.log(`• tenant ${t.id} skip: ${e.shortMessage || e.message}`);
    }
  }

  // tipe REGULER = 0
  const akreditasi = [
    { kode: "AKR-2026-0001", institusi: 1, prodi: 1, upps: 1 },
    { kode: "AKR-2026-0002", institusi: 1, prodi: 2, upps: 1 },
    { kode: "AKR-2026-0003", institusi: 2, prodi: 3, upps: 2 },
    { kode: "AKR-2026-0004", institusi: 2, prodi: 6, upps: 2 },
    { kode: "AKR-2026-0005", institusi: 1, prodi: 1, upps: 1 },
    { kode: "AKR-2026-0006", institusi: 3, prodi: 4, upps: 3 },
    { kode: "AKR-2026-0007", institusi: 3, prodi: 5, upps: 3 },
    { kode: "AKR-2025-0008", institusi: 2, prodi: 3, upps: 2 },
    { kode: "AKR-2025-0009", institusi: 1, prodi: 2, upps: 1 },
    { kode: "AKR-2025-0010", institusi: 1, prodi: 1, upps: 1 },
  ];
  for (const a of akreditasi) {
    try {
      const tx = await reg.registerAkreditasi(a.kode, a.institusi, a.prodi, a.upps, 0, "");
      await tx.wait();
      console.log(`✓ ${a.kode} registered on-chain`);
    } catch (e) {
      console.log(`• ${a.kode} skip: ${e.shortMessage || e.message}`);
    }
  }

  const total = await reg.getTotalAkreditasi();
  console.log("Total akreditasi on-chain:", total.toString());
}

main().then(() => process.exit(0)).catch((e) => { console.error(e); process.exit(1); });
