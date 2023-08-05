// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.13;

contract notes{
    /*
    for the error that is out side of contract we need to name 
    it ContractName__errorName()

    we also need to install all the packages in the vs code as it just do not
    install it like remix

    forge build/compile -- for compiling the code

    TESTS
    its impotant and different from auditing as i know

    chisel -- is writing code inside the terminal 
    
    tx.gasprice(value) -- it will set a tranction gas
    gasleft() -- for knowing how much gas we used

    STORAGE
    storage is array where all *state* variable are store like a array with there hex
    initalied state varible have hex 0x0000
    private variable does not mean they are private
    reading and storing into storage are very gas expensive around 100
    but from memory it's 3

    immutable and constants are not store in storage it store in bytecode/opcodes

    object -- contract converted in bytecode
    opcodes -- bytecode converted in op opcode
    and there are low level/ assermbly level instractions 
    
    
    */
}