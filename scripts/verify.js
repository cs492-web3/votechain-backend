const { ethers } = require("hardhat");
require("dotenv").config({ path: ".env" });
require("@nomiclabs/hardhat-etherscan");
async function main() {
  // Verify the contract after deploying
  await hre.run("verify:verify", {
    address: "0xAA9b4C0d76ca19E350A1Be05A858d78096465E22",
    constructorArguments: [
      "0xB069bab759C093253E83E81C9eB6e47212660b43",
      "Which Singer Do You Want To See in the KAIST Festival?",
      1,
    ],
    // for example, if your constructor argument took an address, do something like constructorArguments: ["0xABCDEF..."],
  });
}
// Call the main function and catch if there is any error
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
