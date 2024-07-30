const hre = require("hardhat");

async function main() {
    const DZapStaking = await hre.ethers.getContractFactory("DZapStaking");
    console.log("Deploying DZapStaking....");

    const dZapStaking = await DZapStaking.deploy();
    await dZapStaking.deployed();
    console.log(`DZapStaking deployed to: ${dZapStaking.address}`);


    const MockERC721 = await hre.ethers.getContractFactory("MockERC721");
    console.log("Deploying MockERC721....");
    
    const mockERC721 = await MockERC721.deploy();
    await MockERC721.deployed();
    console.log(`MockERC721 deployed to: ${mockERC721.address}`);



    const MockERC20 = await hre.ethers.getContractFactory("MockERC20");
    console.log("Deploying MockERC20....");
    
    const mockERC20 = await MockERC20.deploy();
    await MockERC20.deployed();
    console.log(`MockERC20 deployed to: ${mockERC20.address}`);


    console.log("Initialize DzapStaking...");
    await dZapStaking.initialize(mockERC20.address,
        mockERC20.address,
        hre.ethers.utils.parseUnits("1",
            18
        ),
        100,
        10
    );
    console.log("DZapStaking initialized");
    

}

main().catch((error) => {
    console.error(error);
  
    processexitCode =1;

});