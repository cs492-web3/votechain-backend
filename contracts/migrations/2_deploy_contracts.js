//var Election = artifacts.require("./Election_step2.sol");
var Election = artifacts.require("./admin_contract.sol");

module.exports = function (deployer) {
  deployer.deploy(Election);
};
