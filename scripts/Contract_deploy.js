const hre = require("hardhat");

async function main() {
	const NFTContract_ = await hre.ethers.getContractFactory("NFTToken");
	const Contract = await hre.ethers.getContractFactory("Election_step2");

	const description = "Which one is the KAIST best restaurant?";
	const randomSeed = 111;
	const maxTokenToMint = 32;
	const metadataURI = 'https://gateway.pinata.cloud/ipfs/QmfT1SF7fx9vZ1Vy8BygiReKMbqo1YHGuiFgyWrRDHjpw8';
	const isShowResultImm = 1; //1이면 바로 보임

	// description, symbol, randomSeed, maxTokenToMint, metadataURI
	const NFTContract = await NFTContract_.deploy(description, "Nupjuk", randomSeed, maxTokenToMint, metadataURI);
	await NFTContract.deployed();

	// CA, description, isShowResultImm
	const contract = await Contract.deploy(NFTContract.address, description, isShowResultImm);
	await contract.deployed();

	console.log("Contract deployed to:", contract.address);
	console.log("NFT Contract deployed to:", NFTContract.address);
}

main().catch((error) => {
	console.error(error);
	process.exitCode = 1;
});