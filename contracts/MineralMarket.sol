pragma solidity ^0.4.11;

import "./MineralOwnership.sol";

contract MineralMarket is MineralOwnership {

    function buyOre() external payable {
        require(msg.value >= orePrice);
        require(oresLeft > 0);
        uint8 amount;
        if (isPresale) {
            require(discounts > 0);
            amount = 50;
            discounts--;
        } else {
            amount = 1;
        }
        ownerOreCount[msg.sender] += amount;
        oresLeft -= amount;
    }

    function buyGem(uint _gemId) external payable {
        uint gainedWei = msg.value;
        require(_gemId < gemstones.length);
        require(gemIndexToOwner[_gemId] == address(this));

        Gemstone storage gem = gemstones[_gemId];
        require(gainedWei >= gem.price);

        _transfer(address(this), msg.sender, _gemId);
    }

   function mintGem(uint _categoryIdx, string _name, uint256 _colour, bool _polished, uint256 _price) onlyTeamMembers external {

        require(gemsLeft > 0);
        require(_categoryIdx < CATEGORY_COUNT);

        //Decrease the mineral count for the category if not PROMO gem
        if (_categoryIdx < CATEGORY_COUNT){
             mineralCounts[_categoryIdx] = mineralCounts[_categoryIdx] - 1;
        }

        uint64 stamp = 0;
        if (_polished) {
            stamp = uint64(block.timestamp);
        }

        //Decrease total mineral count
        gemsLeft = gemsLeft - 1;

        Gemstone memory _stone = Gemstone({
            category : _categoryIdx,
            name : _name,
            colour : _colour,
            extractionTime : uint64(block.timestamp),
            polishedTime : stamp,
            price : _price
        });

        uint256 newStoneId = gemstones.push(_stone) - 1;

        ownerGemCount[address(this)]++;
        gemIndexToOwner[newStoneId] = address(this);
        oresLeft--;
    }

    function setPrice(uint256 _gemId, uint256 _price) onlyTeamMembers external {
        require(_gemId < gemstones.length);
        Gemstone storage gem = gemstones[_gemId];
        gem.price = uint64(_price);
    }

    function withdrawBalance() onlyTeamMembers external {
        //require(msg.sender == owner);
        bool res = owner.send(this.balance);
    }
}
