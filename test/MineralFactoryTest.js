// Specifically request an abstraction for MetaCoin
var MineralFactory = artifacts.require("MineralFactory");

var mineralsCount = 8879997;
var categoriesCount = 50;
var mineralCounts = [
        8880, 9768, 10745, 11819, 13001,
        19304, 21235, 23358, 25694, 28264,
        28957, 31852, 35037, 38541, 42395,
        43435, 47778, 52556, 57812, 63593,
        65152, 71668, 78834, 86718, 95389,
        97728, 107501, 118251, 130077, 143084,
        146593, 161252, 177377, 195115, 214626,
        219889, 241878, 266066, 292672, 321939,
        329833, 362817, 399098, 439008, 482909,
        494750, 544225, 598648, 658512, 724364];

contract('MineralFactory', function(accounts) {
  it("Minerals count should match", function() {
    return MineralFactory.deployed().then(function(instance) {
      return instance.mineralsLeft.call();
    }).then(function(mineralsLeft) {
      assert.equal(mineralsLeft.valueOf(), mineralsCount, "There are not 8879997 minerals.");
    });
  }),
  it("Categories count should match", function() {
    return MineralFactory.deployed().then(function(instance) {
      return instance.categoryCount.call();
    }).then(function(categoryCount) {
      assert.equal(categoryCount.valueOf(), categoriesCount, "There are not 50 categories.");
    });
  }),
  it("Extraction should work", function() {
    var count = 100;
    return MineralFactory.deployed().then(function(instance) {
        return extractMany(instance, count);
      }).then(function(idx) {
          assert.equal(idx.valueOf(), mineralsCount - count, "Minerals extracted count does not match");
      })
  });
});

async function extractMany(contract, count) {
    for (let i=0;i<count;i++) {
        let idx = await contract.extract();
    }
    return contract.mineralsLeft();
}
