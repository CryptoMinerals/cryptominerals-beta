var MineralMarket = artifacts.require("./MineralMarket.sol");

module.exports = function(deployer) {
  deployer.deploy(MineralMarket);
};
