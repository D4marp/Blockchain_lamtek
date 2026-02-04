const hre = require("hardhat");
const fs = require("fs");
const path = require("path");

async function main() {
  console.log("===========================================");
  console.log("  LAM Teknik Smart Contracts Deployment");
  console.log("===========================================\n");

  const [deployer] = await hre.ethers.getSigners();
  console.log("Deploying contracts with account:", deployer.address);
  
  const balance = await hre.ethers.provider.getBalance(deployer.address);
  console.log("Account balance:", hre.ethers.formatEther(balance), "ETH\n");

  // Deploy AkreditasiRegistry
  console.log("Deploying AkreditasiRegistry...");
  const AkreditasiRegistry = await hre.ethers.getContractFactory("AkreditasiRegistry");
  const akreditasiRegistry = await AkreditasiRegistry.deploy();
  await akreditasiRegistry.waitForDeployment();
  const akreditasiAddress = await akreditasiRegistry.getAddress();
  console.log("✓ AkreditasiRegistry deployed to:", akreditasiAddress);

  // Deploy AsesmenKecukupanContract
  console.log("\nDeploying AsesmenKecukupanContract...");
  const AsesmenKecukupan = await hre.ethers.getContractFactory("AsesmenKecukupanContract");
  const asesmenKecukupan = await AsesmenKecukupan.deploy();
  await asesmenKecukupan.waitForDeployment();
  const asesmenKecukupanAddress = await asesmenKecukupan.getAddress();
  console.log("✓ AsesmenKecukupanContract deployed to:", asesmenKecukupanAddress);

  // Deploy AsesmenLapanganContract
  console.log("\nDeploying AsesmenLapanganContract...");
  const AsesmenLapangan = await hre.ethers.getContractFactory("AsesmenLapanganContract");
  const asesmenLapangan = await AsesmenLapangan.deploy();
  await asesmenLapangan.waitForDeployment();
  const asesmenLapanganAddress = await asesmenLapangan.getAddress();
  console.log("✓ AsesmenLapanganContract deployed to:", asesmenLapanganAddress);

  // Deploy DokumenIPFSRegistry
  console.log("\nDeploying DokumenIPFSRegistry...");
  const DokumenIPFS = await hre.ethers.getContractFactory("DokumenIPFSRegistry");
  const dokumenIPFS = await DokumenIPFS.deploy();
  await dokumenIPFS.waitForDeployment();
  const dokumenIPFSAddress = await dokumenIPFS.getAddress();
  console.log("✓ DokumenIPFSRegistry deployed to:", dokumenIPFSAddress);

  // Save deployment info
  const deploymentInfo = {
    network: hre.network.name,
    deployer: deployer.address,
    deployedAt: new Date().toISOString(),
    contracts: {
      AkreditasiRegistry: akreditasiAddress,
      AsesmenKecukupanContract: asesmenKecukupanAddress,
      AsesmenLapanganContract: asesmenLapanganAddress,
      DokumenIPFSRegistry: dokumenIPFSAddress,
    },
  };

  const deploymentPath = path.join(__dirname, "..", "deployments");
  if (!fs.existsSync(deploymentPath)) {
    fs.mkdirSync(deploymentPath, { recursive: true });
  }

  fs.writeFileSync(
    path.join(deploymentPath, `${hre.network.name}-deployment.json`),
    JSON.stringify(deploymentInfo, null, 2)
  );

  console.log("\n===========================================");
  console.log("  Deployment Complete!");
  console.log("===========================================\n");
  console.log("Contract Addresses:");
  console.log("-------------------");
  console.log("AKREDITASI_CONTRACT_ADDRESS=" + akreditasiAddress);
  console.log("ASESMEN_KECUKUPAN_CONTRACT_ADDRESS=" + asesmenKecukupanAddress);
  console.log("ASESMEN_LAPANGAN_CONTRACT_ADDRESS=" + asesmenLapanganAddress);
  console.log("DOKUMEN_IPFS_CONTRACT_ADDRESS=" + dokumenIPFSAddress);
  console.log("\nCopy these addresses to your .env file!");
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
