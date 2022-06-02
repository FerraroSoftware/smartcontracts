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

module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deploy, log } = deployments;
  const { deployer } = await getNamedAccounts();
  const chainId = network.config.chainId;

  // what about changing chains
  // when going for localhost or hardhat network we want to use a mock
};
