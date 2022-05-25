const { expect } = require("chai");


describe("Review Test", async function(){

    let hardhatReviews, owner;

    this.beforeEach(async function()  {
        //const accounts = await ethers.getSigners()
        //const deployer = accounts[0]
        //await deployments.fixture(["all"])
        //reviews = await ethers.getContractFactory("BlockchainReviews")
        [owner] = await ethers.getSigners();
        const Reviews = await ethers.getContractFactory("BlockchainReviews");
        hardhatReviews = await Reviews.deploy();
        
        
    })

    it("Allows clients to onboard", async function() {
        
        await hardhatReviews.onboardClient("bla", "bla",
            {
                from: owner[0],
                value: '10000000000000000'
            }
        );
        const contractBalance = await hardhatReviews.getContractBalance();
        expect(contractBalance).to.equal('10000000000000000');
        console.log(contractBalance.toString());
        
        const clientData = await hardhatReviews.viewClientList();
        console.log(clientData[0].clientName);
        expect(clientData[0].clientName).to.equal("bla");
    })
})