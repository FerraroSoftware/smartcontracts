// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

/// @title The best smart contract
/// @author Tony
contract owned {
    address payable owner;
    // Contract constructor: set owner
    constructor() {
    owner = payable(msg.sender);
    }
    // Access control modifier
    modifier onlyOwner {
    require(msg.sender == owner);
    _;
    }
}

contract mortal is owned {
    // Contract destructor
    function destroy() public onlyOwner {
    require(msg.sender == owner);
    selfdestruct(payable(msg.sender));
    }
}

contract Faucet 
{
    event Withdrawal(address indexed to, uint amount);
    event Deposit(address indexed from, uint amount);


    // Gives out ether to anyone who asks
    function withdraw(uint withdraw_amount) public {
        // Limit withdrawl
        require(withdraw_amount <= 100000000000000000);
        // Send amount to address that requested it
        (bool success, ) = msg.sender.call{value:withdraw_amount}("");
        require(success, "Transfer failed.");
        emit Withdrawal(msg.sender, withdraw_amount);

        // msg.sender.transfer(withdraw_amount);
    }

    fallback() payable external{
        emit Deposit(msg.sender, msg.value);
    }
    
}
