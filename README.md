# [Challenge 2](https://github.com/scaffold-eth/scaffold-eth-challenges/tree/challenge-2-token-vendor) of [SpeedRunEthereum.com](https://speedrunethereum.com/challenge/token-vendor)

## Token vendor

Challenge consists in building a custom ERC20 token and an unstoppable vending machine that will buy and sell the currency.  
  
On the Solidity side I created a smart contract that inherits the ERC20 token standard from OpenZeppelin. Set token to _mint() 1000 (* 10 ** 18) tokens to the msg.sender. Then create a Vendor.sol contract that sells tokens using a payable buyTokens() function.  
  
On the frontend side I edited a template to allow the user to input an amount of tokens they want to buy. We'll display a preview of the amount of ETH (or USD) it will cost with a confirm button.  
  
The final deliverable is an app that lets users purchase the ERC20 token, transfer it, and sell it back to the vendor. Contracts is deployed to a Görli and verified on Etherscan, webapp is deployed to a public web server.  
  
  
Deployed to Görli Testnet  
[Vendor Contract](https://goerli.etherscan.io/address/0x54B7576F1f8d72397ab89C4c770B9c1bCD3FFcc5)  
[Token Contract](https://goerli.etherscan.io/address/0x7ec5ec137ae6b08e9cb6ffa7ffa011e8ab5e18cd)  
[Frontend](https://overjoyed-apparel.surge.sh/)
