# [Challenge 1](https://github.com/scaffold-eth/scaffold-eth-challenges/tree/challenge-1-decentralized-staking) of [SpeedRunEthereum.com](https://speedrunethereum.com)

## Decentralized Staking App

Challenge consists in building a decentralized application where users can coordinate a group funding effort. If the users cooperate, the money is collected in a second smart contract. If they defect, the worst that can happen is everyone gets their money back. The users only have to trust the code.  
  
The Solidity part consists in building a Staker.sol contract that collects ETH from numerous addresses using a payable stake() function and keeps track of balances. After some deadline if it has at least some threshold of ETH, it sends it to an ExampleExternalContract and triggers the complete() action sending the full balance. If not enough ETH is collected, allow users to withdraw().  
  
On the frontend part the goal is to display the contract information and to use Stake(address,uint256) event.  
The final deliverable is deploying a Dapp that lets users send ether to a contract and stake if the conditions are met, and upload the app to a public webserver.  
  
Deployed to Görli Testnet  
[Staker Contract](https://goerli.etherscan.io/address/0x22B2B9Eab36D236314c287a72Eae5CC830B0c558)  
[ExampleExternalContract](https://goerli.etherscan.io/address/0x918e45bf5491181BfE61F2428471e31767f0014f)  
[Frontend](https://lovely-ground.surge.sh/)  
