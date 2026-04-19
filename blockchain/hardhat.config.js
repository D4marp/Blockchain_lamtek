require("@nomicfoundation/hardhat-toolbox");

const besuAccounts = process.env.BLOCKCHAIN_PRIVATE_KEY
  ? [process.env.BLOCKCHAIN_PRIVATE_KEY]
  : [];

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: {
    version: "0.8.19",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
      viaIR: true,
    },
  },
  networks: {
    hardhat: {
      chainId: 1337,
    },
    localhost: {
      url: "http://127.0.0.1:8545",
      chainId: 1337,
    },
    besu: {
      url: process.env.BESU_RPC_URL || "http://localhost:8545",
      chainId: 1337,
      accounts: besuAccounts,
      gasPrice: 0,
    },
  },
  paths: {
    sources: "./contracts",
    tests: "./test",
    cache: "./cache",
    artifacts: "./artifacts",
  },
};
