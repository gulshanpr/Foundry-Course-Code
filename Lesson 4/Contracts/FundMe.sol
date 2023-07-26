// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
// this AggregatorV3Interface gives use the ABI to use 

import {PriceConverter} from "Lesson4/Contracts/PriceConverter.sol";


// 817242
// 774539
error NotOwner();

contract FundMe{

    using PriceConverter for uint256;
    //all the function from priceConverter will use uint256;
    address public immutable i_owner;
    constructor (){
        i_owner = msg.sender;
    }

    uint256 public constant MINIMUMUSD = 5e18;
    address[] public funders;
    mapping (address  => uint256 ) public addressToAmountFunded;

    function fund() public payable    {
        require(msg.value.getConversion() >= MINIMUMUSD, "come on bro send some enough money");
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value; 
    }

    function withdraw() public ownerOfTheContract{
        // this for loop will reset the amount founded
        for (uint256 funderIndex; funderIndex < funders.length; funderIndex++){
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        // reset the address array
        funders = new address[](0);

        // actual withdraw the funds

        //transfer
        //all the msg.sender the address but to withdraw we need to make it payble that's why we have written payable(msg.sender)
        // payable(msg.sender).transfer(address(this).balance);
        // //send
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "Send Failed");
        // call is enough for sending or recevinigng money  that why we have commented it
        
        //call
        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call Failed");
    }

    modifier ownerOfTheContract{
        // require(msg.sender == i_owner, "Hey, you are not owner");
        if (msg.sender != i_owner){
            revert NotOwner();
        }
        _;
    }

    receive() external payable {
        fund();
    }
    
    fallback() external payable {
        fund();
    }

}