// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
// if we want to inhertainte the some other contract we just need to name import that contarct
// and write contract variableName is importedContractName {}

// inheritance is the property of getting property in anthoer contract

import {SimpleStorage} from "Lesson 3/SimpleStorage.sol";

contract AddFiveStorage is SimpleStorage{
    function store(uint256 _newNumber) public override {
        // +5
        // overrides
        // virual override into base function
        myFavoriteNumber = _newNumber + 5;
    }
}