pragma solidity 0.8.15;
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

contract Vendor is Ownable {

  uint256 public constant tokensPerEth = 100;

  event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);
  event SellTokens(address seller, uint256 amountOfETH, uint256 amountOfTokens);

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

  function withdraw() public onlyOwner returns(bool sent){

    address payable owner = payable(owner());

    (sent, ) = owner.call{value: address(this).balance}("");
  }

  function sellTokens(uint256 _amount) public returns(bool sent){
    require(_amount > 0, "not enough tokens!!");

    uint256 ethAmount = _amount / tokensPerEth;

    require(ethAmount <= address(this).balance, "not enough ETH in the contract!!");

    yourToken.transferFrom(msg.sender, address(this), _amount);
    (sent, ) = payable(msg.sender).call{value: ethAmount}("");

    emit SellTokens(msg.sender, ethAmount, _amount);
  }

  receive() external payable {}
}
