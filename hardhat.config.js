require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

module.exports = {
  solidity: {
    version: "0.8.9",
    settings: {
      optimizer: {
        enabled: true,
      },
    },
  },
  allowUnlimitedContractSize: true,
  networks: {
    hardhat: {},
    goerli: {
      url: process.env.API_URL,
      accounts: [`0x416796fbf3383147f6a2342384846fce21c00b7faa651d1897ea0a056cf210bf`],
    },
    ETH_MAINNET: {
      accounts: [`0x416796fbf3383147f6a2342384846fce21c00b7faa651d1897ea0a056cf210bf`],
      url: `https://eth-mainnet.g.alchemy.com/v2/${process.env.ALCHEMY_API_KEY}`,
    },
    ETH_GOERLI: {
      accounts: [`0x416796fbf3383147f6a2342384846fce21c00b7faa651d1897ea0a056cf210bf`],
      url: `https://eth-goerli.g.alchemy.com/v2/${process.env.ALCHEMY_API_KEY}`,
    },
  },
  etherscan: {
    apiKey: `${process.env.ETHERSCAN_API_KEY}`,
  },
};
