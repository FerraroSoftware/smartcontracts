// SPDX-License-Identifier: MIT
pragma solidity 0.8.8;
import "./PriceConverter.sol";

// Get funds from users
// Withdraw funds
// Set min funding value in usd

// current tx cost: 837,033, changing minusd to const: 817,479

// constant, immuntable -> help lower gas, gas optimizations 5 hours in
// immutable if not on same line, i.e constructor called
// these get put in byte code of contract instead

error NotOwner();

contract FundMe {
    using PriceConverter for uint256;

    // no longer in storage
    uint256 public constant MINDUSD = 50 * 1e18;

    address[] public funders;
    mapping(address => uint256) public addressToAmountFunded;

    address public immutable i_owner;

    constructor() {
        // Set owner to who deployed the contract
        i_owner = msg.sender;
    }

    // payable makes function red
    function fund() public payable {
        // Want to be able to set min funds
        // 1. how do we send eth to this contract
        // 1 ETH required
        // msg.value.getConversionRate(msg.value);
        // msg.value is considered the param (first param) for the library function call. if another param, pass to function next
        require(msg.value.getConversionRate() > MINDUSD, "Didnt send enough");
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
        for (
            uint256 funderIndex = 0;
            funderIndex < funders.length;
            funderIndex++
        ) {
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
        (bool callSucess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(callSucess, "Call failed");
    }

    modifier onlyOwner() {
        // require(msg.sender == i_owner, "sender is not owner");
        if (msg.sender != i_owner) {
            revert NotOwner();
        } // gas optimization because not sending full string, doing function call meant for it
        _;
    }

    // what happens if someone sends this contract eth without calling the fund function?
    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }
}
