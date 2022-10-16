# [Challenge 3](https://github.com/scaffold-eth/scaffold-eth-challenges/tree/challenge-3-dice-game) of [SpeedRunEthereum.com](https://speedrunethereum.com/challenge/token-vendor)

## Dice game

Challenge consists in implementing a contract that can predict the randomness of DiceGame.sol ahead of time and only roll the dice when the win is guaranteed.  
  
On the Solidity side I created a riggedRoll function that predicts the outcome by generating random numbers in the exact same way as the DiceGame contract. Then RiggedRoll contract has been extended with receive() and withdraw() functions.  
  
The final deliverable is a smart contract that can rig the Dice Game by predicting its weak form of randomness (using block hashes to create random numbers).  
  
  
Deployed to Görli Testnet  
[RiggedRoll Contract](https://goerli.etherscan.io/address/0x3392d96AE7d98Adc720099Ad147E4f79aA5274c4)  
[Frontend](https://grubby-journey.surge.sh/)