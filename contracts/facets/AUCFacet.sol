// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {LibAppStorage} from "../libraries/LibAppStorage.sol";

contract AUCFacet {
    LibAppStorage.Layout internal l;
    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 _value
    );

    function name() external returns (string memory) {
        l.lastAUCUser = msg.sender;
        return l.name;
    }

    function symbol() external returns (string memory) {
        l.lastAUCUser = msg.sender;
        return l.symbol;
    }

    function decimals() external returns (uint8) {
        l.lastAUCUser = msg.sender;
        return l.decimals;
    }

    function totalSupply() public returns (uint256) {
        l.lastAUCUser = msg.sender;
        return l.totalSupply;
    }

    function balanceOf(address _owner) public returns (uint256 balance) {
        l.lastAUCUser = msg.sender;
        balance = l.balances[_owner];
    }

    function transfer(
        address _to,
        uint256 _value
    ) public returns (bool success) {
        LibAppStorage._transferFrom(msg.sender, _to, _value);
        success = true;
        l.lastAUCUser = msg.sender;
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) public returns (bool success) {
        uint256 l_allowance = l.allowances[_from][msg.sender];
        if (msg.sender == _from || l.allowances[_from][msg.sender] >= _value) {
            l.allowances[_from][msg.sender] = l_allowance - _value;
            LibAppStorage._transferFrom(_from, _to, _value);

            emit Approval(_from, msg.sender, l_allowance - _value);

            success = true;
        } else {
            revert("ERC20: Not enough allowance to transfer");
        }
        l.lastAUCUser = msg.sender;
    }

    function approve(
        address _spender,
        uint256 _value
    ) public returns (bool success) {
        l.allowances[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        success = true;
        l.lastAUCUser = msg.sender;
    }

    function allowance(
        address _owner,
        address _spender
    ) public returns (uint256 remaining_) {
        remaining_ = l.allowances[_owner][_spender];
        l.lastAUCUser = msg.sender;
    }

    function mintTo(address _user) external {
        uint256 amount = 100_000_000e18;
        l.balances[_user] += amount;
        l.totalSupply += uint96(amount);
        emit LibAppStorage.Transfer(address(0), _user, amount);
        l.lastAUCUser = msg.sender;
    }

    function burn(uint256 amount) external {
        // Ensure the user has enough balance to burn
        require(l.balances[msg.sender] >= amount, "Insufficient balance");

        // Deduct the tokens from the user's balance
        l.balances[msg.sender] -= amount;

        // Update the total supply
        l.totalSupply -= uint96(amount);

        // Emit the Transfer event
        emit LibAppStorage.Transfer(msg.sender, address(0), amount);
        l.lastAUCUser = msg.sender;
    }
}
