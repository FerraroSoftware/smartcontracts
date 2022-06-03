const { inputToConfig } = require("@ethereum-waffle/compiler");
const { assert } = require("chai");
const { deployments, ethers, getNamedAccounts } = require("hardhat");

describe("FundMe", async function () {
  // deploy our fundme contract
  // using hardhat deploy
  // const accounts = await ethers.getSigners()
  // const accountZero = accounts[0]

  let fundMe;
  let mockV3Aggregator;
  let deployer;
  const sendValue = ethers.utils.parseEther("1");
  beforeEach(async () => {
    // const accounts = await ethers.getSigners()
    // deployer = accounts[0]
    deployer = (await getNamedAccounts()).deployer;
    await deployments.fixture(["all"]);
    fundMe = await ethers.getContract("FundMe", deployer);
    mockV3Aggregator = await ethers.getContract("MockV3Aggregator", deployer);
  });
  describe("constructor", async function () {
    it("sets the aggreagtor address correctly", async function () {
      const response = await fundMe.priceFeed();
      assert.equal(response, mockV3Aggregator.address);
    });
  });
});
