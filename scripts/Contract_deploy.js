const hre = require("hardhat");

async function main() {
  const NFTContract_ = await hre.ethers.getContractFactory("NFTToken");
  const Contract = await hre.ethers.getContractFactory("Election_step2");

  const NFTContract = await NFTContract_.deploy("Vote Name", "Nupjuk_symbol");
  await NFTContract.deployed();

  console.log("NFTContract.address: ", NFTContract.address);
  const contract = await Contract.deploy(NFTContract.address);
  await contract.deployed();

  console.log("Contract deployed to:", contract.address);
}
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
