pragma solidity 0.8.15;
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

contract Vendor is Ownable {

  uint256 public constant tokensPerEth = 100;

  event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);

  YourToken public yourToken;

  constructor(address tokenAddress) {
    yourToken = YourToken(tokenAddress);
  }

  function buyTokens() public payable {

    require(msg.value > 0, "send more ETH!!");

    uint256 amount = msg.value * tokensPerEth;

    yourToken.transfer(msg.sender, amount);

    emit BuyTokens(msg.sender, msg.value, amount);

  }

  function withdraw() public onlyOwner returns(bool){

    address payable owner = payable(owner());

    (bool sent, ) = owner.call{value: address(this).balance}("");
    
    return sent;
  }

  // ToDo: create a sellTokens(uint256 _amount) function:

}
