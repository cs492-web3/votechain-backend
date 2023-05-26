/*
var Election = artifacts.require("./Election_step2.sol");

module.exports = function(deployer) {
  deployer.deploy(Election);
};
*/

/*
var NFTToken = artifacts.require("NFTToken.sol");

module.exports = async (deployer) => {
  // 이름, 심볼, 메타데이터 URI
  await deployer.deploy(NFTToken, "Nupjuk_name", "Nupjuk_symbol");
  // NFTToken 배포를 진행하고 배포 완료된 인스턴스 가져오기
  //const token = await NFTToken.deployed();
};
*/

const NFTToken = artifacts.require("./NFTToken.sol");
const Election = artifacts.require("./Election_step2.sol");

module.exports = async (deployer) => {
  await deployer.deploy(NFTToken, "Nupjuk_name", "Nupjuk_symbol");
  const token = await NFTToken.deployed();

  await deployer.deploy(Election, token.address);
  const election = await Election.deployed();
};