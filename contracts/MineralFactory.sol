pragma solidity ^0.4.11;

import "./MineralBase.sol";

contract MineralFactory is MineralBase {

    uint8 constant CATEGORY_COUNT = 50;
    uint8 constant MODULUS = 100;
    uint64 constant EXTRACT_PRICE = 1e16;

    uint32[] mineralCounts = [
        8880, 9768, 10744, 11819, 13001,
        19304, 21234, 23358, 25694, 28263,
        28956, 31852, 35037, 38541, 42395,
        43434, 47778, 52556, 57811, 63592,
        65152, 71667, 78834, 86717, 95389,
        97728, 107501, 118251, 130076, 143084,
        146592, 161251, 177377, 195114, 214626,
        219888, 241877, 266065, 292672, 321939,
        329833, 362816, 399098, 439008, 482909,
        494750, 544225, 598647, 658512, 724385];

    uint64[] polishingPrice = [
        200e16, 180e16, 160e16, 130e16, 100e16,
        80e16, 60e16, 40e16, 20e16, 5e16];

    mapping(address => uint) internal ownerGemCount;
    mapping (uint256 => address) public gemIndexToOwner;
    mapping (uint256 => address) public gemIndexToApproved;

    Gemstone[] public gemstones;

    struct Gemstone {
        uint category;
        string name;
        uint256 colour;
        uint64 extractionTime;
        uint64 polishedTime;
        uint256 price;
    }

    function _getRandomMineralId() private view returns (uint32) {
        return uint32(uint256(keccak256(block.timestamp, block.difficulty))%oresLeft);
    }

     function _getPolishingPrice(uint _category) private view returns (uint) {
        return polishingPrice[_category / 5];
    }

    function _generateRandomHash(string _str) private view returns (uint) {
        uint rand = uint(keccak256(_str));
        return rand % MODULUS;
    }

    function _getCategoryIdx(uint position) private view returns (uint8) {
        uint32 tempSum = 0;
        //Chosen category index, 255 for no category selected - when we are out of minerals
        uint8 chosenIdx = 255;

        for (uint8 i = 0; i < mineralCounts.length; i++) {
            uint32 value = mineralCounts[i];
            tempSum += value;
            if (tempSum > position) {
                //Mineral counts is 50, so this is safe to do
                chosenIdx = i;
                break;
            }
        }
        return chosenIdx;
    }

    function extractOre(string _name) external payable returns (uint8, uint256) {
        require(gemsLeft > 0);
        require(msg.value >= EXTRACT_PRICE);
        require(ownerOreCount[msg.sender] > 0);

        uint32 randomNumber = _getRandomMineralId();
        uint8 categoryIdx = _getCategoryIdx(randomNumber);

        require(categoryIdx < CATEGORY_COUNT);

        //Decrease the mineral count for the category
        mineralCounts[categoryIdx] = mineralCounts[categoryIdx] - 1;
        //Decrease total mineral count
        gemsLeft = gemsLeft - 1;

        Gemstone memory _stone = Gemstone({
            category : categoryIdx,
            name : _name,
            colour : _generateRandomHash(_name),
            extractionTime : uint64(block.timestamp),
            polishedTime : 0,
            price : 0
        });

        uint256 newStoneId = gemstones.push(_stone) - 1;

        ownerGemCount[msg.sender]++;
        ownerOreCount[msg.sender]--;
        gemIndexToOwner[newStoneId] = msg.sender;

        return (categoryIdx, _stone.colour);
    }

    function polishRoughStone(uint256 _gemId) external payable {
        uint gainedWei = msg.value;
        require(gemIndexToOwner[_gemId] == msg.sender);

        Gemstone storage gem = gemstones[_gemId];
        require(gem.polishedTime == 0);
        require(gainedWei >= _getPolishingPrice(gem.category));

        gem.polishedTime = uint64(block.timestamp);
    }
}
