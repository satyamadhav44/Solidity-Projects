const PublicFundRaise = artifacts.require("PublicFundRaise");

module.exports = function(deployer) {
  deployer.deploy(PublicFundRaise);
};
