const { ethers } = require("hardhat");
const { expect, assert } = require("chai");
//mochajs.org/
// describe("SimpleStorage", () => {})
https: describe("SimpleStorage", function () {
  let simpleStorage;
  let simpleStorageFactory;

  // Before each test
  beforeEach(async function () {
    simpleStorageFactory = await ethers.getContractFactory("SimpleStorage");
    simpleStorage = await simpleStorageFactory.deploy();
  });

  // Test
  it("Should start with a favorite number of 0", async function () {
    const currentValue = await simpleStorage.retrieve();
    const expectedValue = "0";
    assert.equal(currentValue.toString(), expectedValue);
    // expect(current.currentValue.toString().to.equal(expectedValue));
  });

  // Test
  // it.only("Should update when we call store", async function () {
  it("Should update when we call store", async function () {
    const expectedValue = "7";
    const transactionResponse = await simpleStorage.store(expectedValue);
    await transactionResponse.wait(1);

    const currentValue = await simpleStorage.retrieve();
    assert.equal(currentValue.toString(), expectedValue);
  });
});
