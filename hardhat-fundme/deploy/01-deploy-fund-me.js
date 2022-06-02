// dont need main for hardhat deploy

// function deployFunc() {
//   console.log("HI");
// hre.getNamedAccounts
// hre.deployments
// }

// module.exports.default = deployFunc;

// hre: hardhat runtime env
// module.exports = async (hre) => {
//    const {getNamedAccounts, deployments} = hre
// }

// const helperconfig = require("../helper-hardhat-config")
// const networkConfig = helperConfig.networkConfig
const { networkConfig } = require("../helper-hardhat-config");
const { network } = require("hardhat");

module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deploy, log } = deployments;
  const { deployer } = await getNamedAccounts();
  const chainId = network.config.chainId;

  // uses whatever you use with --network flag, yarn hardhat deploy --network rinkeby
  const ethUsdPriceFeedAddress = networkConfig[chainId]["ethUsdPriceFeed"];

  // if contract doesnt exist, deploy minimual version for local testing

  // what about changing chains
  // when going for localhost or hardhat network we want to use a mock
  const fundMe = await deploy("FundMe", {
    from: deployer,
    agrs: [],
    log: true,
  });
};