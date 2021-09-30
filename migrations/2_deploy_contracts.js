const ArtToken = artifacts.require("ARTToken.sol");

module.exports = function (deployer) {
    deployer.deploy(ArtToken, "ArtTokenFC", "artfc", "QmafLRm7EJBcEQjpjiNpT2gVZkyB1Vc6GLy4VbbzZNV7Zu","");
};
