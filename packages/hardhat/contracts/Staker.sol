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
    require(timeLeft() > 0, "you can't stake after deadline");

    balances[msg.sender] += msg.value;
    emit Stake(msg.sender, msg.value);
  }


  // After some `deadline` allow anyone to call an `execute()` function
  // If the deadline has passed and the threshold is met, it should call `exampleExternalContract.complete{value: address(this).balance}()`
  function execute() public notCompleted {
    require(timeLeft() == 0, "deadline not reached yet");
    require(openForWithdraw == false, "Crowdfund has not completed successfully, you can withdraw your funds.");

    if(address(this).balance>=threshold){
      exampleExternalContract.complete{value: address(this).balance}();
    }
    else{
      openForWithdraw = true;
    }
  }


  // If the `threshold` was not met, allow everyone to call a `withdraw()` function
  function withdraw() public notCompleted {
    require(openForWithdraw==true, "withdraw not allowed");

    uint256 balanceToSend = balances[msg.sender];
    require(balanceToSend > 0, "nothing to withdraw");

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

  modifier notCompleted{
    require(exampleExternalContract.completed() == false, "Crowdfund has already been completed!");
    _;
  }
}