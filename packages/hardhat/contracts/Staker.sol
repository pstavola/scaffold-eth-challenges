// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "hardhat/console.sol";
import "./ExampleExternalContract.sol";

/**
 * @title Decentralized Staking App
 * @author patricius
 * @notice A decentralized application where users can coordinate a group funding effort. If the users cooperate, the money is collected in a second smart contract. If they defect, the worst that can happen is everyone gets their money back. The users only have to trust the code.
 * @dev Challenge 1 of SpeedRunEthereum.com
 */
contract Staker {

  /* ========== GLOBAL VARIABLES ========== */

  ExampleExternalContract public exampleExternalContract; // external contract to collect funding
  mapping ( address => uint256 ) public balances; // tracks individual donations
  uint256 public constant THRESHOLD = 1 ether; // threshold to consider the crowdfunding effort successfull
  uint256 public deadline = block.timestamp + 48 hours; // crowdfunding period final deadline
  bool public openForWithdraw = false; // allow withdrawals

  /* ========== MODIFIERS ========== */

  /**
   * @notice Checks that funding has already been collected by external contract.
   */
  modifier notCompleted{
    require(exampleExternalContract.completed() == false, "Crowdfund has already been completed!");
    _;
  }

  /* ========== EVENTS ========== */

  event Stake(address staker, uint256 amount);

  /* ========== CONSTRUCTOR ========== */

  constructor(address exampleExternalContractAddress) {
      exampleExternalContract = ExampleExternalContract(exampleExternalContractAddress);
  }

  /* ========== FUNCTIONS ========== */

  /**
   * @notice Collect funds and track individual `balances` with a mapping. Checks that crowdfunding period is still open.
   */
  function stake() public payable{
    require(timeLeft() > 0, "you can't stake after deadline");

    balances[msg.sender] += msg.value;
    emit Stake(msg.sender, msg.value);
  }

  /**
   * @notice Checks if the deadline has passed, if threshold is met then sends funds to external contract else enable withdrawals
   */
  function execute() public notCompleted {
    require(timeLeft() == 0, "deadline not reached yet");
    require(openForWithdraw == false, "Crowdfund has not completed successfully, you can withdraw your funds.");

    if(address(this).balance>=THRESHOLD){
      exampleExternalContract.complete{value: address(this).balance}();
    }
    else{
      openForWithdraw = true;
    }
  }

  /**
   * @notice Checks that withdrawls are open, than everybody can withdraw their own donations
   */
  function withdraw() public notCompleted {
    require(openForWithdraw==true, "withdraw not allowed");

    uint256 balanceToSend = balances[msg.sender];
    require(balanceToSend > 0, "nothing to withdraw");

    balances[msg.sender] -= balanceToSend;
    (bool sent, ) = payable(msg.sender).call{value: balanceToSend}("");
    require(sent, "Failed withdrawal");
  }

  /**
   * @notice returns the time left before the deadline to the frontend
   */
  function timeLeft() public view returns(uint256) {
    if (block.timestamp>=deadline)
      return 0;
    else
      return deadline-block.timestamp;
  }

  /**
   * @notice in order to receives eth. it calls stake() for tracking
   */
  receive() external payable{
    stake();
  }
}