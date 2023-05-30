const hre = require("hardhat");
require("dotenv").config({ path: ".env" });
require("@nomiclabs/hardhat-etherscan");

async function main() {
  const NFTContract_ = await hre.ethers.getContractFactory("NFTToken");
  const Contract = await hre.ethers.getContractFactory("Election_step2");

  const description = "Who do you want to see in KAIST Festival?";
  // const description = "Would you recommand your friend KAIST WEB3 course?";
  // const description = "Where is your favorite KAIST Cafeteria";
  const randomSeed = 235;
  const maxTokenToMint = 100;
  const register = "QmUwoLzkNcCvronS4fAGfncZVPJ8r5MWg9i1k7aCVYMt3A";
  const vote1 = "Qmc4D3vjLTzbABykFaDGVF4eXXM6z8bJhBHtDCpZhdTNq3";
  const vote2 = "QmXbRAQQmPUtXNDZKGeHyXMN2Jj7ciqBdRYjh4nJrVsCMC";
  const metadataURI = "https://gateway.pinata.cloud/ipfs/" + register;
  const isShowResultImm = 1; //1이면 바로 보임

  const NFTContract = await NFTContract_.deploy(
    description,
    "Nupjuk",
    randomSeed,
    maxTokenToMint,
    metadataURI
  );
  await NFTContract.deployed();

  const contract = await Contract.deploy(
    NFTContract.address,
    description,
    isShowResultImm
  );
  await contract.deployed();

  console.log("Contract deployed to:", contract.address);
  console.log("NFT Contract deployed to:", NFTContract.address);

  const wait = (timeToDelay) =>
    new Promise((resolve) => setTimeout(resolve, timeToDelay));
  console.log("waiting 1 minute ...");

  await wait(20000);
  console.log("Verify Start!");

  // const ContractAddress = "0xeF1AA4215eFA8bA8161e6929a2022cef06484A2a";
  // const NFTContractAddress = "0x01C0240B27dbf5d52fB9f71E0CF347692694270c";

  await hre.run("verify:verify", {
    address: contract.address,
    constructorArguments: [NFTContract.address, description, isShowResultImm],
    address: ContractAddress,
    constructorArguments: [NFTContractAddress, description, isShowResultImm],
  });
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });
