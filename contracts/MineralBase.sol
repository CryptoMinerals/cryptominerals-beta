pragma solidity ^0.4.11;

import "./AccessControl.sol";
import "./Pausable.sol";

contract MineralBase is AccessControl, Pausable {

    bool public isPresale = true;

    uint16 public discounts = 10000;
    uint32 constant TOTAL_SUPPLY = 8888888;
    uint32 public oresLeft;
    uint32 gemsLeft;

    // Price of ORE (50 pieces in presale, only 1 afterwards)
    uint64 public orePrice = 1e16;

    mapping(address => uint) internal ownerOreCount;

    // Constructor
    function MineralBase() public {

        // Assign ownership to the creator
        owner = msg.sender;
        addressDev = owner;
        addressFin = owner;
        addressOps = owner;

        // Initializing counters
        oresLeft = TOTAL_SUPPLY;
        gemsLeft = TOTAL_SUPPLY;

        // Transfering ORES to the team
        ownerOreCount[msg.sender] += oresLeft / 2;
        oresLeft = oresLeft / 2;
    }

    function balanceOfOre(address _owner) public view returns (uint256 _balance) {
        return ownerOreCount[_owner];
    }

    function sendOre(address _recipient, uint amount) external payable {
        require(balanceOfOre(msg.sender) >= amount);
        ownerOreCount[msg.sender] -= amount;
        ownerOreCount[_recipient] += amount;
    }

    function endPresale() onlyTeamMembers external {
        isPresale = false;
        discounts = 0;
    }
}
