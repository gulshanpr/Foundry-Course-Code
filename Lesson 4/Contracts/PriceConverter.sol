// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";


library PriceConverter {
    // thus this is a library we need to make public, internal but we have to depoly it
    function getPrice() internal  view returns (uint256) {
        // Address get from chainlink (0x694AA1769357215DE4FAC081bf1f309aDC325306) this is only for the sepolia the contract address
        // ABI from interface
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        (,int256 answer,,,) = priceFeed.latestRoundData();
        return uint256 (answer * 1e10);
    }

    function getDec() internal  view returns(uint256){
       return AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306).decimals(); 
    }

    function getConversion(uint256 ethAmount) internal view returns(uint256){
        uint256 ethPrice = getPrice();
        uint256 ethAmoundInUSD = (ethPrice*ethAmount)/1e18;
        return ethAmoundInUSD;
    }
}