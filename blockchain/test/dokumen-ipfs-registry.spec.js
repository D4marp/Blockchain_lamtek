const { expect } = require('chai');
const { ethers } = require('hardhat');

describe('DokumenIPFSRegistry baseline', function () {
  async function deployFixture() {
    const [owner] = await ethers.getSigners();
    const Factory = await ethers.getContractFactory('DokumenIPFSRegistry');
    const registry = await Factory.deploy();
    await registry.waitForDeployment();

    return { registry, owner };
  }

  it('sets deployer as owner and authorized signer', async function () {
    const { registry, owner } = await deployFixture();

    expect(await registry.owner()).to.equal(owner.address);
    expect(await registry.isAuthorized(owner.address)).to.equal(true);
  });

  it('uploads a document and increments totalDokumen', async function () {
    const { registry } = await deployFixture();

    await (await registry.uploadDokumen(
      'AKR-001',
      'QmHashDokumen001',
      'dokumen.pdf',
      0,
      1024,
      'application/pdf',
      'sha256dokumen001',
      '{"source":"baseline-test"}'
    )).wait();

    expect(await registry.totalDokumen()).to.equal(1n);

    const doc = await registry.getDokumen(1);
    expect(doc.kodeAkreditasi).to.equal('AKR-001');
    expect(doc.ipfsHash).to.equal('QmHashDokumen001');
    expect(doc.isActive).to.equal(true);
    expect(doc.isVerified).to.equal(false);
  });
});
