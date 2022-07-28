// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "hardhat/console.sol";
import "./ExampleExternalContract.sol";

contract Staker {

  ExampleExternalContract public exampleExternalContract;

  mapping ( address => uint256 ) public balances;
  uint256 public constant threshold = 1 ether;
  uint256 public deadline = block.timestamp + 30 seconds;
  bool public openForWithdraw;

  event Stake(address staker, uint256 amount);

  constructor(address exampleExternalContractAddress) {
      exampleExternalContract = ExampleExternalContract(exampleExternalContractAddress);
  }

  // Collect funds in a payable `stake()` function and track individual `balances` with a mapping:
  function stake() public payable{
    require(msg.value > 0, "value cannot be 0");

    balances[msg.sender] += msg.value;
    emit Stake(msg.sender, msg.value);
  }


  // After some `deadline` allow anyone to call an `execute()` function
  // If the deadline has passed and the threshold is met, it should call `exampleExternalContract.complete{value: address(this).balance}()`
  function execute() public{
    require(block.timestamp>=deadline, "deadline not reached yet");

    if(address(this).balance>=threshold){
      exampleExternalContract.complete{value: address(this).balance}();
    }
    else{
      openForWithdraw = true;
    }
  }


  // If the `threshold` was not met, allow everyone to call a `withdraw()` function
  function withdraw() public{
    require(openForWithdraw==true, "withdraw not allowed");

    uint256 balanceToSend = balances[msg.sender];
    balances[msg.sender] = 0;
    payable(msg.sender).transfer(balanceToSend);
  }

  // `timeLeft()` view function that returns the time left before the deadline for the frontend
  function timeLeft() public view returns(uint256) {
    if (block.timestamp>=deadline)
      return 0;
    else
      return deadline-block.timestamp;
  }


  // Add the `receive()` special function that receives eth and calls stake()
  receive() external payable{
    stake();
  }
}