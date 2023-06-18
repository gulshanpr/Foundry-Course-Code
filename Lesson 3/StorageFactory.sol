// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// we can paste the entire SimpleStorageL3 code here but it's not a good practice but still for now will do it
// i can do this also

// import "Lesson 3/SimpleStorage.sol"; this will import every contract that is present in SimpleStorage and if we import
// all the contract it will cost us a lot of gas, so the solution is to import named contract like this

// import {SimpleStorage, SimpleStorage2} from "Lesson 3/SimpleStorage.sol";

import {SimpleStorage} from "Lesson 3/SimpleStorage.sol";

contract StorageFacotry{

    SimpleStorage[] public listOfSimpleStorageContracts;


    // this function is same as below just to get rid out of error i commmented is out;
    // function createSimpleStorageContract() public {
    //     //this new keyword will know to depoly the new contract
    //     SimpleStorage newSimpleStorageContract = new SimpleStorage();
    //     listOfSimpleStorageContracts.push(newSimpleStorageContract);
    // }

    function createSimpleStorageContract() public {
        SimpleStorage simpleStorageContractVariable = new SimpleStorage();
        // SimpleStorage simpleStorage = new SimpleStorage();
        listOfSimpleStorageContracts.push(simpleStorageContractVariable);
    }

    function sfStore(uint256 _simpleStorageIndex, uint256 _simpleStorageNumber) public {
        // Address
        // ABI
        // SimpleStorage(address(simpleStorageArray[_simpleStorageIndex])).store(_simpleStorageNumber);
        listOfSimpleStorageContracts[_simpleStorageIndex].store(_simpleStorageNumber);
    }

    function sfGet(uint256 _simpleStorageIndex) public view returns (uint256) {
        // return SimpleStorage(address(simpleStorageArray[_simpleStorageIndex])).retrieve();
        return listOfSimpleStorageContracts[_simpleStorageIndex].retrieve();
    }
}