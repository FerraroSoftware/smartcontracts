// SPDX-License-Identifier: MIT
pragma solidity 0.8.8;

contract FallbackExample {
    uint256 public result;

    // if we send not through send function, i.e using calldata low level interactions, calldata is blank. 
    // looks for function that matches if you put data in call data, need fallback
    receive() external payable {
        result = 1;
    }

    fallback() external payable {
        result = 2;
    }
}