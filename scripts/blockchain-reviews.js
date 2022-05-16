// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");

// Returns the Ether balance of a given address
async function getBalance(address) {
  const balanceBigInt = await hre.waffle.provider.getBalance(address);
  return hre.ethers.utils.formatEther(balanceBigInt);
}

async function printReviews(reviews) {
  for (const review of reviews) {
    console.log(`Rating: ${review.rating} Review: ${review.review}`);
  }
}

// Logs the ether balance for  list of addressess.
async function printBalances(addresses) {
  let idx = 0;
  for (const address of addresses) {
    console.log(`Address ${idx} balance: `, await getBalance(address));
    idx++;
  }
}

async function main() {
  // Get example accounts
  const [owner, tipper4, tipper, tipper2, tipper3] = await hre.ethers.getSigners(); 

  //Get the contract to deploy
  const BlockchainReviews = await hre.ethers.getContractFactory("BlockchainReviews");
  const blockchainReviews = await BlockchainReviews.deploy();

  // Deploy contract
  await blockchainReviews.deployed();
  console.log("BlockchainReviews deployed to: ", blockchainReviews.address);

  // print address
  const addresses = [owner.address, tipper.address, tipper2.address, tipper3.address, blockchainReviews.address];
  console.log("=== START ===");
  await printBalances(addresses);

  // Submit the BlockchainReviews
  await blockchainReviews.connect(tipper4).submitReviews("2", "too bad");
  await blockchainReviews.connect(tipper).submitReviews("5", "Fantastic");
  await blockchainReviews.connect(tipper2).submitReviews("3", "Ok ok it was");
  await blockchainReviews.connect(tipper3).submitReviews("1", "Worst service");

  // Read all the reviews
  console.log("=== Reviews ===");
  const reviews = await blockchainReviews.getReviews();
  printReviews(reviews);
}


// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
