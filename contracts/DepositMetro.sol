// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "./Metro.sol";

contract MetroSavings {
    Metro public metroToken;

    mapping(address => uint256) public deposits;

    constructor(address _metroToken) {
        metroToken = Metro(_metroToken);
    }

    function deposit(uint256 _amount) public {
        require(_amount > 21000, "Insufficient balance");
        require(metroToken.transferFrom(msg.sender, address(this), _amount), "Transfer failed");
        deposits[msg.sender] += _amount;
    }

    function withdraw(uint256 _amount) public {
        require(deposits[msg.sender] >= _amount, "Insufficient balance");
        require(metroToken.transfer(msg.sender, _amount), "Transfer failed");
        deposits[msg.sender] -= _amount;
    }

    function getBalance() public view returns (uint256) {
        return deposits[msg.sender];
    }


}