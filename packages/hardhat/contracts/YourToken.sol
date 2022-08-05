pragma solidity 0.8.15;
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
// learn more: https://docs.openzeppelin.com/contracts/3.x/erc20

contract YourToken is ERC20 {
    constructor() ERC20("Platinum", "PLT") {
        _mint( 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 , 1000 * 10 ** 18);
        //_mint(msg.sender, initialSupply);
    }
}
