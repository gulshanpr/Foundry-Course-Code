// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;


/*

its always a good idea to write down the things we want to do in 
the contracts
1. we want to get funds from users
2. withdraw funds
3. set a minimum funding value in USD

we want to do couples of things with fund function
1. allow users to send $
2. have a minimum $5 sent

payable keyword in function make a contract hold some funds
msg.value means no. of wei sent with the message
1e18 = 1000000000000000000 = 1*10**18
require is a checker it the if the first condition will not become true it will revert the tranction with the second condition/message

REVERTS
undo any actions that heve been done in the same contract, and send the remaining gas back
althrough sending a fail tranction still cost gas, because the prev. line has been and the remaining gas after the reverted line will be refunded

ORACLE
if we want to sent min $5 of crypto we need to convert the value to doller
for that we need to get price data that is outside of blockchain so for that 
we have oracle or chainlink that gives us data of price of ETH
Chainlink is a oracle network that gives external computation or data to smart contract and make them hybrid smart contracts
the popular use case of chainlink is for data feeds and it is empowering 50 Bill of de-fi 
exchanges + data providers go through --> chainlink nodes --> and that combines into a single reference contract ---> and that is what users like me can use

INTERFACES
we use interfaces(keyword) to get the ABI of that contract and use it
to getprice() we need to have contract address and the ABI 
will get ABI from interface that has a contract depolyed

address[] name this is how we create a array
mapping (address funder => uint256 amountFunded) addresstoAmountFunded this is how create mapping
name.push(address) adds address into name array
same for the mapping

to use the lirary of PriceConverter.sol we need to named import it
and also write (using PriceConverter for uint256) 
to use the function of  we can do
(msg.value.getConversionRate() ) the msg.value will be the first parameter to and if 
we need another parameter we can sepecify it is the brackets

SAFE MATH
in solidity 0.6, uint8 can hold maximum 255 number and be we try to hold one more 
it will overflow or warp the uint8 and start from 0
but in solidity 0.8 this thing will not happen, but if we ever want to add 1 it will give us error

WITHDRAW
all the msg.sender the address but to withdraw we need to make it payble that's why we have written payable(msg.sender)
there is 3 method or way
1. transfer
transfer has a default revert thing, if its failed than it just revert
2. send
send can not revert the transtion it just return a boolean valur that's why we have to make a require ourself
3. call
it is very similar to send but in ("") we sepecifi the tranction we want to call
call return 2 values a success bool and a byte data 
to revert we also need to make a require keyword

CONSTRUCTOR is a keyword that we used
when we want to excute a code only one time and the time is of time of depolyment
e.g owner == msg.sender it will be set to the address of depolyer and can not excuted again

MODIFIERS
modifiers are the code that we can used it into mulitple time
just by intitalizing with the function

CONSTANT
when we know a value is note going to be changed we use constant 
we write constant as CONSTANT all caps

IMMUTABLE
when we know a value is note going to be changed we use immutable 

COSTOUM ERROR
in the require revert message we need to spend lot of gas to show that message that's why we used custom error
it is decleared outside of contract

RECIVE
we somebody sent a tranction but not using the fund function and we still need to have that person count
we use recive 
when data is empty it will take recive

fallback
is same as recive but it will be used for data input


*/