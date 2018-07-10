pragma solidity ^0.4.11;

import "./ERC721.sol";
import "./MineralFactory.sol";

contract MineralOwnership is MineralFactory, ERC721 {

    string public constant name = "CryptoMinerals";
    string public constant symbol = "GEM";

    function _owns(address _claimant, uint256 _gemId) internal view returns (bool) {
        return gemIndexToOwner[_gemId] == _claimant;
    }

    // Assigns ownership of a specific gem to an address.
    function _transfer(address _from, address _to, uint256 _gemId) internal {
        ownerGemCount[_from]--;
        ownerGemCount[_to]++;
        gemIndexToOwner[_gemId] = _to;
        Transfer(_from, _to, _gemId);
    }

    function _approvedFor(address _claimant, uint256 _gemId) internal view returns (bool) {
        return gemIndexToApproved[_gemId] == _claimant;
    }

    function _approve(uint256 _gemId, address _approved) internal {
        gemIndexToApproved[_gemId] = _approved;
    }

    // Required for ERC-721 compliance
    function balanceOf(address _owner) public view returns (uint256 count) {
        return ownerGemCount[_owner];
    }

    // Required for ERC-721 compliance.
    function transfer(address _to, uint256 _gemId) external whenNotPaused {
        require(_to != address(0));
        require(_to != address(this));

        require(_owns(msg.sender, _gemId));
        _transfer(msg.sender, _to, _gemId);
    }

    // Required for ERC-721 compliance.
    function approve(address _to, uint256 _gemId) external whenNotPaused {
        require(_owns(msg.sender, _gemId));
        _approve(_gemId, _to);
        Approval(msg.sender, _to, _gemId);
    }

    // Required for ERC-721 compliance.
    function transferFrom(address _from, address _to, uint256 _gemId) external whenNotPaused {
        require(_to != address(0));
        require(_to != address(this));

        require(_approvedFor(msg.sender, _gemId));
        require(_owns(_from, _gemId));

        _transfer(_from, _to, _gemId);
    }

    // Required for ERC-721 compliance.
    function totalSupply() public view returns (uint) {
        return TOTAL_SUPPLY - gemsLeft;
    }

    // Required for ERC-721 compliance.
    function ownerOf(uint256 _gemId) external view returns (address owner) {
        owner = gemIndexToOwner[_gemId];
        require(owner != address(0));
    }

    // Required for ERC-721 compliance.
    function implementsERC721() public view returns (bool implementsERC721) {
        return true;
    }

    function gemsOfOwner(address _owner) external view returns(uint256[] ownerGems) {
        uint256 gemCount = balanceOf(_owner);

        if (gemCount == 0) {
            return new uint256[](0);
        } else {
            uint256[] memory result = new uint256[](gemCount);
            uint256 totalGems = totalSupply();
            uint256 resultIndex = 0;
            uint256 gemId;

            for (gemId = 0; gemId <= totalGems; gemId++) {
                if (gemIndexToOwner[gemId] == _owner) {
                    result[resultIndex] = gemId;
                    resultIndex++;
                }
            }

            return result;
        }
    }
}
