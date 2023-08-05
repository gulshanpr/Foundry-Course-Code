// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/Mocks/MockV3Aggregator.sol";

contract HelperConfig is Script{
    // if we are on local anvil, we depoly on mocks
    // otherwise, grab the existing address from the live network 

    // created struct because what if we need more value into the config fuctiion
    NetworkConfig public activeConfig;
    uint8 public constant DECIMAL = 8;
    int256 public constant INITIAL_PRICE = 2000e8;

    struct NetworkConfig {
        address priceFeed;
    }

    constructor() {
        if(block.chainid ==11155111){
            activeConfig = getSepoilaETHConfig();
        } else if(block.chainid ==1){
            activeConfig = getMainNetETHConfig();
        } else {
            activeConfig = getOrCreateAnvilETHConfig();
        }
    }

    function getSepoilaETHConfig() public pure returns (NetworkConfig memory){
        // price feed address
        NetworkConfig memory sepoliaConfig = NetworkConfig({ priceFeed : 0x694AA1769357215DE4FAC081bf1f309aDC325306});
        // priceFeed is inside {} because it can take multiple value

        return sepoliaConfig;
        // we are doing this
        // otherwise, grab the existing address from the live network
    }

    function getMainNetETHConfig() public pure returns (NetworkConfig memory){
        NetworkConfig memory ETHConfig = NetworkConfig({ priceFeed : 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419});
        return ETHConfig;
    }

    function getOrCreateAnvilETHConfig() public returns (NetworkConfig memory){
        if(activeConfig.priceFeed != address(0)){
            return activeConfig;
        }
        // price feed address

        //1. Deploy the mocks that is a mock contract created by us
        //2. and then return the mock address

        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(
            DECIMAL, 
            INITIAL_PRICE);
        vm.stopBroadcast();

        NetworkConfig memory anvilConfig = NetworkConfig({priceFeed: address(mockPriceFeed)});

        return anvilConfig;
    }
    
}