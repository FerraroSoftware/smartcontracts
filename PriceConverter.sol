// SPDX-License-Identifier: MIT
pragma solidity 0.8.8;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

// library to attach to uint256
// no state variables and cant send ether
library PriceConverter {

    function getPrice() internal view returns (uint256) {
        // ABI: just need to know functions, not implementation details, comes from importing
        // Address: eth usd rinkby: 	0x8A753747A1Fa494EC906cE90E9f37563A8AF630e
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        (, int price,,,)= priceFeed.latestRoundData();
        // Eth in terms of USD, 8 decimals in price feed
        // Need to change 18 to 8
        return uint256(price * 1e10);
    }

    function getVersion() internal view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        return priceFeed.version();
    }

    function getConversionRate(uint256 ethAmount) internal view returns (uint256) {
        uint256 ethPrice = getPrice();
        // lets say price is 3000_000000000000000000 = ETH / USD price
        // 1_000000000000000000 ETH
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18; // if no divide, would be 1e36
        return ethAmountInUsd;
    }

}