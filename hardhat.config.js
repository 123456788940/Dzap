require("dotenv").config();
require("@nomiclabs/hardhat-waffle");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.24",
  paths: {
    artifacts: "./src",
  },
  networks: {
    zkEVM: {
      url: `https://gnosis-chiado-rpc.publicnode.com`,
      accounts: [process.env.ACCOUNT_PRIVATE_KEY],
    },
  },
};
