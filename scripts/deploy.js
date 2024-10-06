const { ethers } = require("hardhat");
async function main() {
    const contractFactory = await ethers.getContractFactory("FileSharing");
    const contract = await contractFactory.deploy({
        gasLimit: 6700000,
    });
    console.log(contract.deploymentTransaction());
    console.log("Contract deployed to address:", contract.address);
 }
 
 main()
   .then(() => process.exit(0))
   .catch(error => {
     console.error(error);
     process.exit(1);
  });