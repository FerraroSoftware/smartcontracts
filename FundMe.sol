// SPDX-License-Identifier: MIT
pragma solidity 0.8.8;
import "./PriceConverter.sol";

// Get funds from users
// Withdraw funds
// Set min funding value in usd

contract FundMe {

    using PriceConverter for uint256;

    uint256 public minUsd = 50 * 1e18;

    address[] public funders;
    mapping(address => uint256) public addressToAmountFunded;

    address public owner;

    constructor() {

        // Set owner to who deployed the contract
        owner = msg.sender;
    }

    // payable makes function red
    function fund() public payable{
        // Want to be able to set min funds
        // 1. how do we send eth to this contract
        // 1 ETH required
        // msg.value.getConversionRate(msg.value);
        // msg.value is considered the param (first param) for the library function call. if another param, pass to function next
        require(msg.value.getConversionRate() > minUsd, "Didnt send enough");
        // 18 decimals: 1000000000000000000 wei 
        // what is reverting?
        // undo any action before and send remaining gas back

        // sender is address , value is amount 
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] = msg.value;
    }

    function withdraw() public onlyOwner {

        // require(msg.sender == owner, "sender is not owner");

        // Clean out map
        for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++){
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        // reset array, create new empty array
        funders = new address[](0);

        // https://solidity-by-example.org/sending-ether
        // withdraw funds
        // transfer
        // msg.sender = address
        // payable(msg.sender) = payable address
        // payable(msg.sender).transfer(address(this).balance);

        // send
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "Send failed");
        
        // call - recommended way atm
        (bool callSucess,) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSucess, "Call failed");
    }

    modifier onlyOwner {
        require(msg.sender == owner, "sender is not owner");
        _;
    }

}