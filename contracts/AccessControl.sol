pragma solidity ^0.4.23;

contract AccessControl {

    /*** AccessControl functionality adapted from CryptoKitties ***/
    event ContractUpgrade(address newContract);

    // The addresses of the accounts (or contracts) that can execute actions within each roles.
    address public addressDev;
    address public addressFin;
    address public addressOps;

    /// @dev Access modifier for Developer-only functionality
    modifier onlyDeveloper() {
        require(msg.sender == addressDev);
        _;
    }

    /// @dev Access modifier for Finance-only functionality
    modifier onlyFinance() {
        require(msg.sender == addressFin);
        _;
    }

    /// @dev Access modifier for Operation-only functionality
    modifier onlyOperation() {
        require(msg.sender == addressOps);
        _;
    }

    modifier onlyTeamMembers() {
        require(
            msg.sender == addressDev ||
            msg.sender == addressFin ||
            msg.sender == addressOps
        );
        _;
    }

    /// @dev Assigns a new address to act as the Developer. Only available to the current Developer.
    /// @param _newDeveloper The address of the new Developer
    function setDeveloper(address _newDeveloper) external onlyDeveloper {
        require(_newDeveloper != address(0));

        addressDev = _newDeveloper;
    }

    /// @dev Assigns a new address to act as the Finance. Only available to the current Developer.
    /// @param _newFinance The address of the new Finance
    function setFinance(address _newFinance) external onlyDeveloper {
        require(_newFinance != address(0));

        addressFin = _newFinance;
    }

    /// @dev Assigns a new address to act as the Operation. Only available to the current Developer.
    /// @param _newOperation The address of the new Operation
    function setOperation(address _newOperation) external onlyDeveloper {
        require(_newOperation != address(0));

        addressOps = _newOperation;
    }
}
