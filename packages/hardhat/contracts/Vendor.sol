// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

/**
 * @title Token vendor
 * @author patricius
 * @notice A custom ERC20 token and an unstoppable vending machine that will buy and sell the currency.
 * @dev Challenge 2 of SpeedRunEthereum.com
 */
contract Vendor is 
    Ownable
{
   /* ========== GLOBAL VARIABLES ========== */

  uint256 public constant tokensPerEth = 100; // token/eth fixed exchange rate
  YourToken public yourToken; // token instance

   /* ========== EVENTS ========== */

  event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);
  event SellTokens(address seller, uint256 amountOfETH, uint256 amountOfTokens);

  /* ========== CONSTRUCTOR ========== */

  constructor(address tokenAddress) {
    yourToken = YourToken(tokenAddress);
  }

  /* ========== FUNCTIONS ========== */

  /**
   * @notice allows users to buy tokens at fixed rate. Value must be more than 0
   */
  function buyTokens() public payable {
    require(msg.value > 0, "send more ETH!!");

    uint256 amount = msg.value * tokensPerEth;
    yourToken.transfer(msg.sender, amount);
    emit BuyTokens(msg.sender, msg.value, amount);
  }

  /**
   * @notice allows owner to withdraw Ethers from contract balance
   */
  function withdraw() public onlyOwner returns(bool sent){
    address payable owner = payable(owner());
    (sent, ) = owner.call{value: address(this).balance}("");
  }

  /**
   * @notice allows users to sell tokens back to the contract given enought Ethers in contract balance. Users must manually approve transfer by contract beforehand
   */
  function sellTokens(uint256 _amount) public returns(bool sent){
    require(_amount > 0, "not enough tokens!!");

    uint256 ethAmount = _amount / tokensPerEth;
    require(ethAmount <= address(this).balance, "not enough ETH in the contract!!");

    yourToken.transferFrom(msg.sender, address(this), _amount);
    (sent, ) = payable(msg.sender).call{value: ethAmount}("");
    emit SellTokens(msg.sender, ethAmount, _amount);
  }

  /**
   * @notice contract can receive funds. Allows owner to refund contract at any time
   */
  receive() external payable {}
}
