// used for hardhat and local testing

const { MockProvider } = require("ethereum-waffle");
const { LogDescription } = require("ethers/lib/utils");
const { network } = require("hardhat");
const {
  developmentChains,
  DECIMALS,
  INITIAL_ANSWER,
} = require("../helper-hardhat-config");

module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deploy, log } = deployments;
  const { deployer } = await getNamedAccounts();

  if (developmentChains.includes(network.name)) {
    log("Local network detected! Deploying mocks...");
    await deploy("MockV3Aggregator", {
      contract: "MockV3Aggregator",
      from: deployer,
      log: true,
      args: [DECIMALS, INITIAL_ANSWER],
    });
    log("Mocks Deployed!");
    log("-------------------------------------------------------------");
  }
};

// yarn hardhat deploy --tags mocks, only runs deploy scripts that have special tag
module.exports.tags = ["all", "mocks"];
