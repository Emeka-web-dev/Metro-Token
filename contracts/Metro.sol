// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

// import {IMetro} from "./IMetro.sol";

// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract Metro {
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 public _totalSupply;

    string public _name;
    string public _symbol;
    uint8 public _decimals;

    address public admin;

    error InvalidAddress(address _address);

    error InsuficientBalance(address _address, uint256 _balance);

    error InValidAmount(uint256 _amount);

    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
        _decimals = 18;
        _totalSupply = 100000 * 10**uint256(_decimals);
        _balances[msg.sender] = _totalSupply;
        admin = msg.sender;

    }

    modifier onlyOwner() {
        require(msg.sender == admin, "You are not the owner");
        _;
    }
  
    function balanceOf(address _owner) external view returns (uint256) {
        return _balances[_owner];
    }

    function transfer(address _to, uint256 value) public returns (bool) {
        address owner = msg.sender;

        if (owner == address(0)) {
            revert InvalidAddress(owner);
        }

        if (_to == address(0)) {
            revert InvalidAddress(_to);
        }

        uint256 balance = _balances[owner];

        if (balance < value) {
            revert InsuficientBalance(owner, balance);
        }

        unchecked {
            _balances[owner] = balance - value;
            _balances[_to] += value;
        }

        return true;
    }

    function allowance(
        address _owner,
        address _spender
    ) external view returns (uint256) {
        return _allowances[_owner][_spender];
    }

    function approve(address _spender, uint256 value) external returns (bool) {
        address owner = msg.sender;

        if (owner == address(0)) {
            revert InvalidAddress(owner);
        }

        if (_spender == address(0)) {
            revert InvalidAddress(_spender);
        }

        _allowances[owner][_spender] = value;

        return true;
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 value
    ) public returns (bool) {
        address spender = msg.sender;

        if (spender == address(0)) {
            revert InvalidAddress(spender);
        }

        if (_from == address(0)) {
            revert InvalidAddress(_from);
        }

        if (_to == address(0)) {
            revert InvalidAddress(_to);
        }

        uint256 allowanceBal = _allowances[_from][spender];
        uint256 balance = _balances[_from];

        if (balance < value) {
            revert InsuficientBalance(_from, balance);
        }

        if (allowanceBal < value) {
            revert InsuficientBalance(_from, allowanceBal);
        }

        unchecked {
            _balances[_from] = balance - value;
            _balances[_to] += value;
            _allowances[_from][spender] = allowanceBal - value;
        }

        return true;
    }

    function mint(address account, uint256 amount) external onlyOwner {
        if (account == address(0)) {
            revert InvalidAddress(account);
        }

        if (amount <= 0) {
            revert InValidAmount(amount);
        }

        _totalSupply += amount;
        _balances[account] += amount;
    }
}
