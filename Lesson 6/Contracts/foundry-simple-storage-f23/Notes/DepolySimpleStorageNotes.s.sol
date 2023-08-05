// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract DepolySimpleStorageNotes {
    /*
    we are importing script to inhertaince the in-built lib and
    and the imporated the SimpleStorage to deoply it

    the internal and external means
    external -- if we declear the in the fuction it can only be called by the other contract can not called by a contract inside the same contract
    internal -- opposite of external

    the first function we make is the run() function its a naming convention
    and the vm.startBroadcast and vm.stopBroadcast we the the code the depoly it
    vm can only define in foundry and it doesn't exists in others like hardhat
    in short when we import from lib folder there is some code written for it and we are taking its inhertaince

    through the new keyword we depoly the contract
    SimpleStorage simpleStorage = new SimpleStorage();
    its important 
    
    
    
    to use ()

    for depolying it into a on chain the command is

    forge script path(along with the file name) --rpc-url 000000.0. --broadcast --private-key
    broadcast is for saving it into a broadcast file

    
    
    
    */
}