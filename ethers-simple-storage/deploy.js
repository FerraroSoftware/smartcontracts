const { Console } = require("console");
const ethers = require("ethers");
const fs = require("fs-extra");
require("dotenv").config();

async function main() {
  // Endpoint to connect to alchemy
  const provider = new ethers.providers.JsonRpcProvider(
    process.env.RPC_URL_ALCH
  );
  // Private key to sign transactions from metamask
  const wallet = new ethers.Wallet(process.env.PRIVATE_KEY, provider);

  // Get contract info
  const abi = fs.readFileSync("./SimpleStorage_sol_SimpleStorage.abi", "utf8");
  const binary = fs.readFileSync(
    "./SimpleStorage_sol_SimpleStorage.bin",
    "utf8"
  );

  // Deploy contract and wait 1 block to confirm
  const contractFactory = new ethers.ContractFactory(abi, binary, wallet);
  console.log("Deploying, please wait...");
  const contract = await contractFactory.deploy();
  await contract.deployTransaction.wait(1);
  console.log(`Contract address: ${contract.address}`);

  // View function to retrieve favNum
  const currentFavNumber = await contract.retrieve();
  console.log(`Current Favorite Number: ${currentFavNumber.toString()}`);

  // Spend gas and store new number. Wait 1 block to confirm
  const transactionResponse = await contract.store("7");
  const transactionReceipt = await transactionResponse.wait(1);

  // Check favnum
  const updatedFavNumber = await contract.retrieve();
  console.log(`Updated Favorite Number: ${updatedFavNumber.toString()}`);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
