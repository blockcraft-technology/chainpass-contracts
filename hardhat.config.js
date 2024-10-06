require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

module.exports = {
  solidity: "0.8.27",
  defaultNetwork: "iexec",
  networks: {
    iexec: {
      url: "https://bellecour.iex.ec", 
      accounts: [process.env.PRIVATE_KEY]
    }
  }
};
