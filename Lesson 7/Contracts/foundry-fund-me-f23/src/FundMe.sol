// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
// this AggregatorV3Interface gives use the ABI to use 

import {PriceConverter} from "./PriceConverter.sol";


// 817242
// 774539
error FundMe__NotOwner();

contract FundMe{

    using PriceConverter for uint256;
    //all the function from priceConverter will use uint256;
    address public immutable i_owner;
    AggregatorV3Interface private s_priceFeed; 

    constructor (address priceFeed){
        i_owner = msg.sender;
        s_priceFeed = AggregatorV3Interface(priceFeed);
    }

    uint256 public constant MINIMUMUSD = 5e18;
    address[] private s_funders;
    mapping (address  => uint256 ) private s_addressToAmountFunded;

    function fund() public payable    {
        require(msg.value.getConversion(s_priceFeed) >= MINIMUMUSD, "come on bro send some enough money");
        s_funders.push(msg.sender);
        s_addressToAmountFunded[msg.sender] = s_addressToAmountFunded[msg.sender ]+ msg.value; 
    }

    function getVersion() public view returns (uint256){
        return s_priceFeed.version();
    }

    function cheaperWithdraw() public ownerOfTheContract{
        uint256 funderLength = s_funders.length;
        for (uint256 funderIndex; funderIndex < funderLength; funderIndex++){
            address funder = s_funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }
        s_funders = new address[](0);
        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call Failed");
    }

    function withdraw() public ownerOfTheContract{
        // this for loop will reset the amount founded
        for (uint256 funderIndex; funderIndex < s_funders.length; funderIndex++){
            address funder = s_funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }
        // reset the address array
        s_funders = new address[](0);

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
            revert FundMe__NotOwner();
        }
        _;
    }
    /*
    pure and view 
    are getter function
    */

    function getFunder(uint256 index) public view returns (address) {
        return s_funders[index];
    }

    function getAddressToAmountFunded(address fundingAddress) public view returns (uint256) {
        return s_addressToAmountFunded[fundingAddress];
    }

    function getOwner()public view returns (address) {
        return i_owner;
    }

    receive() external payable {
        fund();
    }
    
    fallback() external payable {
        fund();
    }

}