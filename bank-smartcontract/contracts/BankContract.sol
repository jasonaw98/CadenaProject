// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract Bank {
    uint totalDonations;
    address public bankOwner;
    string public bankName;
    mapping(address => uint256) public customerBalance;
    mapping(address => uint256) public ownerBalance;

    constructor() {
        bankOwner = payable(msg.sender);
    }

    function depositMoney() public payable {
        require(msg.value != 0, "You need to deposit some amount of money!");
        customerBalance[msg.sender] += msg.value;
    }

    function donate() public payable{
        require(msg.value != 0, "You need to donate some amount of money!");
        payable(bankOwner).transfer(msg.value);
        // ownerBalance[bankOwner] += msg.value;
    }

    function setBankName(string memory _name) external {
        require(
            msg.sender == bankOwner,
            "You must be the owner to set the name of the bank"
        );
        bankName = _name;
    }

    function withDrawMoney(address payable _to, uint256 _total) public payable {
        require(
            _total <= customerBalance[msg.sender],
            "You have insuffient funds to withdraw"
        );

        customerBalance[msg.sender] -= _total;
        _to.transfer(_total);
    }

    function getCustomerBalance() external view returns (uint256) {
        return customerBalance[msg.sender];
    }

    function getOwnerBalance() external view returns (uint256) {
        return ownerBalance[bankOwner];
    }

    function getBankBalance() public view returns (uint256) {
        require(
            msg.sender == bankOwner,
            "You must be the owner of the bank to see all balances."
        );
        return address(this).balance;
    }
}