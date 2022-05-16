const hre = require("hardhat");

async function main() {

    //Get the contract to deploy
    const BlockchainReviews = await hre.ethers.getContractFactory("BlockchainReviews");
    const blockchainReviews = await BlockchainReviews.deploy();
  
    // Deploy contract
    await blockchainReviews.deployed();
    console.log("BlockchainReviews deployed to: ", blockchainReviews.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
