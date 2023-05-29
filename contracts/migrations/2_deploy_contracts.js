const NFTToken = artifacts.require("./NFTToken.sol");
const Election = artifacts.require("./Election_step2.sol");

module.exports = async (deployer) => {
  const description = "Which one is the KAIST best restaurant?";
  const randomSeed = 111;
  const maxTokenToMint = 32;
  const metadataURI = 'https://gateway.pinata.cloud/ipfs/QmfT1SF7fx9vZ1Vy8BygiReKMbqo1YHGuiFgyWrRDHjpw8';
  const isShowResultImm = 1;
  
  await deployer.deploy(NFTToken, description, "Nupjuk", randomSeed, maxTokenToMint, metadataURI);
  const token = await NFTToken.deployed();
  
  await deployer.deploy(Election, token.address, description, isShowResultImm);
  const election = await Election.deployed();
};