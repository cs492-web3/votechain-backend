const { ethers } = require("hardhat");
require("dotenv").config({ path: ".env" });
require("@nomiclabs/hardhat-etherscan");
async function main() {
  // Verify the contract after deploying
  await hre.run("verify:verify", {
    address: "0x79A0534e0F2fE5Ce741CF65E35BcaBa3f9fdBdd2",
    constructorArguments: [
      "0x03985299ECB2E27e7076A52165FB4A7ebbEe5655",
      "Which one is the KAIST best restaurant?",
      1
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
