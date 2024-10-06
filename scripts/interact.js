const { ethers } = require("hardhat");

const main = async () => {
    const FileSharing = await ethers.getContractFactory("FileSharing");
    const contract = await FileSharing.attach("0x58B19940498f1a15993C6FDC6897BA7b72A71162");
    
    // Create user settings file (random address)
    const randomSettingsFile = ethers.Wallet.createRandom().address;
    console.log("Random Settings File Address: ", randomSettingsFile);

    let tx = await contract.updateSettingsPointer(randomSettingsFile);
    await tx.wait();
    console.log("User settings file created. Transaction ID:", tx.hash);

    // Create user's data file (random address)
    const randomDataFile = ethers.Wallet.createRandom().address;
    console.log("Random Data File Address: ", randomDataFile);

    tx = await contract.addDataItem(randomDataFile);
    await tx.wait();
    console.log("User's data file created. Transaction ID:", tx.hash);

    // // Share data file with the recipient
    const recipient = "0xB2997558719738AA79eB03b975F13590aE2a7898";
    tx = await contract.shareDataItem(randomDataFile, recipient);
    await tx.wait();
    console.log("Data file shared with recipient. Transaction ID:", tx.hash);

    // Log the contract state after sharing to ensure the file is shared properly
    const sharedFilesForRecipient = await contract.getDataSharedWithMe(recipient);
    console.log("Files shared with recipient: ", sharedFilesForRecipient);

    // Remove sharing with recipient
    tx = await contract.removeSharedDataItem(recipient, randomDataFile);
    await tx.wait();
    console.log("Removed sharing with recipient. Transaction ID:", tx.hash);

    // Update user's settings file (use another random address)
    const newRandomSettingsFile = ethers.Wallet.createRandom().address;
    console.log("New Random Settings File Address: ", newRandomSettingsFile);

    tx = await contract.updateSettingsPointer(newRandomSettingsFile);
    await tx.wait();
    console.log("User settings file updated. Transaction ID:", tx.hash);
};

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
