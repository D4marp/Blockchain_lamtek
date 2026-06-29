// Deploy all contracts then register demo tenants + akreditasi in one Hardhat run.
const hre = require("hardhat");
const fs = require("fs");
const path = require("path");

async function main() {
  const [deployer] = await hre.ethers.getSigners();
  console.log("Deployer:", deployer.address);

  const factories = [
    ["AkreditasiRegistry", "AkreditasiRegistry"],
    ["AsesmenKecukupanContract", "AsesmenKecukupanContract"],
    ["AsesmenLapanganContract", "AsesmenLapanganContract"],
    ["DokumenIPFSRegistry", "DokumenIPFSRegistry"],
  ];

  const contracts = {};
  for (const [name, factoryName] of factories) {
    const F = await hre.ethers.getContractFactory(factoryName);
    const c = await F.deploy();
    await c.waitForDeployment();
    contracts[name] = await c.getAddress();
    console.log(`✓ ${name}: ${contracts[name]}`);
  }

  const depDir = path.join(__dirname, "..", "deployments");
  if (!fs.existsSync(depDir)) fs.mkdirSync(depDir, { recursive: true });
  const depFile = path.join(depDir, `${hre.network.name}-deployment.json`);
  fs.writeFileSync(
    depFile,
    JSON.stringify(
      {
        network: hre.network.name,
        deployer: deployer.address,
        deployedAt: new Date().toISOString(),
        contracts,
      },
      null,
      2,
    ),
  );

  const reg = await hre.ethers.getContractAt("AkreditasiRegistry", contracts.AkreditasiRegistry);
  const txs = [];

  for (const t of [
    { id: 1, nama: "Institut Teknologi Sepuluh Nopember" },
    { id: 2, nama: "Politeknik Elektronika Negeri Surabaya" },
    { id: 3, nama: "Universitas Gadjah Mada" },
  ]) {
    try {
      const tx = await reg.registerTenant(t.id, t.nama);
      const rc = await tx.wait();
      txs.push({ action: "registerTenant", hash: rc.hash, block: rc.blockNumber });
      console.log(`✓ tenant ${t.id}`);
    } catch (e) {
      console.log(`• tenant ${t.id}: ${e.shortMessage || e.message}`);
    }
  }

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
      const rc = await tx.wait();
      txs.push({ action: "registerAkreditasi", kode: a.kode, hash: rc.hash, block: rc.blockNumber });
      console.log(`✓ ${a.kode} tx=${rc.hash}`);
    } catch (e) {
      console.log(`• ${a.kode}: ${e.shortMessage || e.message}`);
    }
  }

  const total = await reg.getTotalAkreditasi();
  console.log("\nTotal akreditasi on-chain:", total.toString());
  console.log("Transactions:", txs.length);

  const resultFile = path.join(depDir, `${hre.network.name}-transactions.json`);
  fs.writeFileSync(resultFile, JSON.stringify({ contracts, transactions: txs }, null, 2));
  console.log("Saved:", resultFile);
}

main().then(() => process.exit(0)).catch((e) => { console.error(e); process.exit(1); });
