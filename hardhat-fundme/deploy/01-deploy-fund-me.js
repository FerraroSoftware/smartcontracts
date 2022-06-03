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
const {
  networkConfig,
  developmentChains,
} = require("../helper-hardhat-config");
const { network } = require("hardhat");
const { verify } = require("../utils/verify");

module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deploy, log } = deployments;
  const { deployer } = await getNamedAccounts();
  const chainId = network.config.chainId;

  // uses whatever you use with --network flag, yarn hardhat deploy --network rinkeby
  //   const ethUsdPriceFeedAddress = networkConfig[chainId]["ethUsdPriceFeed"];

  // Make the pricefeed dynamic for local vs testing
  let ethUsdPriceFeedAddress;
  if (developmentChains.includes(network.name)) {
    const ethUsdAggregator = await deployments.get("MockV3Aggregator");
    ethUsdPriceFeedAddress = ethUsdAggregator.address;
  } else {
    ethUsdPriceFeedAddress = networkConfig[chainId]["ethUsdPriceFeed"];
  }

  // if contract doesnt exist, deploy minimual version for local testing

  // what about changing chains
  // when going for localhost or hardhat network we want to use a mock
  const args = [ethUsdPriceFeedAddress];
  const fundMe = await deploy("FundMe", {
    from: deployer,
    args: [ethUsdPriceFeedAddress],
    log: true,
    waitConfirmations: network.config.blockConfirmations || 1,
  });
  log("-------------------------------------------------------------------");

  if (
    !developmentChains.includes(network.name) &&
    process.env.ETHERSCAN_API_KEY
  ) {
    await verify(fundMe.address, args);
  }
};

module.exports.tags = ["all", "fundme"];
