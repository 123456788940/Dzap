
const { expect } = require("chai");
const { ethers } = require("hardhat");


    describe("DZapStaking Contract", function () {
        let DZapStaking, dZapStaking;
        let MockERC721, mockERC721;
        let MockERC20, mockERC20;


 
        before(async function() {
            [owner, addr1, addr2] = await ethers.getSigners();
     


        MockERC721 = await ethers.getContractFactory("MockERC721");
        mockERC721 = await MockERC721.deploy();
        await mockERC721.deployed();

        MockERC20 = await ethers.getContractFactory("MockERC20");
        mockERC20 = await MockERC20.deploy();
        await mockERC20.deployed();

        
        DZapStaking = await ethers.getContractFactory("DZapStaking");
        dZapStaking = await DZapStaking.deploy();
        await dZapStaking.deployed();

       
      
            await dZapStaking.initialize(
                mockERC721.address,
                mockERC20.address,
                ethers.utils.parseUnits("1", 18),
                100,
                10
         
   

);


await mockERC721.mint(addr1.address, 1);
});




describe("Deployment", function () {
    it("Should set the correct reward parameters", async function () {
        expect(await dZapStaking.rewardPerBlock()).to.equal(ethers.utils.parseUnits("1", 18));
        expect(await dZapStaking.unbondingPeriod()).to.equal(100);
        expect(await dZapStaking.rewardDelayPeriod()).to.equal(10);
    });
});


    describe("Staking", function () {


   it("Should allow a user to stake an NFT", async function () {

        await mockERC721.connect(addr1).approve(dZapStaking.address, 1);


            await expect(dZapStaking.connect(addr1).stakeNFT(1))
            .to.emit(dZapStaking, "staked")
            .withArgs(addr1.address, 1);


const stakedNFT = await dZapStaking.stakedNFTs(1);
expect(stakedNFT.owner).to.equal(addr1.address);
expect(stakedNFT.stakedBlock).to.be.gt(0);
expect(stakedNFT.claimedBlock).to.be.gt(0);

    });
});

describe("Unstaking", function() {
    it("Should allow a user to unstake NFTs", async function() {
        await expect(dZapStaking.connect(addr1).unstakeNFT(1))
        .to.emit(dZapStaking, "_unstaked")
        .withArgs(addr1.address, 1);

        await expect(dZapStaking.connect(addr1).withdrawNFT(1))
        .to.emit(dZapStaking, "rewardClaimed")
        .withArgs(addr1.address, ethers.utils.parseUnits("0", 18));
        

        
const stakedNFT = await dZapStaking.stakedNFTs(1);
expect(stakedNFT.owner).to.equal(ethers.constants.AddressZero);
expect(stakedNFT.stakedBlock).to.be.gt(0);
expect(stakedNFT.claimedBlock).to.be.gt(0);



    });
});


    });
