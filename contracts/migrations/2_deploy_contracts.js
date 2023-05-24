
var Election = artifacts.require("./Election_step2.sol");

module.exports = function(deployer) {
  deployer.deploy(Election);
};

