pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT

import "hardhat/console.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract MultiSigWallet {

  using ECDSA for bytes32;

  mapping (address => bool) public isOwner;
  mapping (address => bool) public hasSigned;
  uint256 public approvalsRequired;

  uint256 public nonce = 0;

  // event SetPurpose(address sender, string purpose);

  string public purpose = "Building Unstoppable Apps!!!";

  constructor(address[] memory _owners, uint256 _approvalsRequired) payable {
    require(_owners.length > 0, "MetaMultiSigWallet must have at least 1 owner");
    require(_approvalsRequired <= _owners.length, "number of approvals must be less or equal to number of owners");

    for(uint256 i; i < _owners.length; i++){
      require(_owners[i] != address(0), "owner cannot be address(0)");
      require(!isOwner[_owners[i]], "duplicated owner");

      isOwner[_owners[i]] = true;
    }
    approvalsRequired = _approvalsRequired;
  }

  function getHash( uint256 _nonce, address to, uint256 value ) public view returns (bytes32) {
    return keccak256(abi.encodePacked(address(this),_nonce,to,value));
  }

  function executeTransaction( address payable _to, uint256 _value, bytes[] memory _signatures) public {
    require(_signatures.length >= approvalsRequired, "not enough approvals");

    bytes32 hash = getHash(nonce, _to, _value);
    address[] memory listOfSigners;
    
    for(uint256 i; i < _signatures.length; i++){
      address signer = recover(hash, _signatures[i]);
      require(isOwner[signer], "Signer must be one of the Owners");
      require(!hasSigned[signer], "Signed more than once by the same owner");
      hasSigned[signer] = true;
      listOfSigners[i] = signer;
    }
    
    nonce++;
    ( bool success, ) = _to.call{value: _value}("");
    require( success, "TX FAILED");

    for(uint256 i; i < listOfSigners.length; i++){
      hasSigned[listOfSigners[i]] = false;
    }
  }

  function recover(bytes32 hash, bytes memory signature) public pure returns (address) {
    return hash.toEthSignedMessageHash().recover(signature);
  }

  function setPurpose(string memory newPurpose) public {
      purpose = newPurpose;
      console.log(msg.sender,"set purpose to",purpose);
      // emit SetPurpose(msg.sender, purpose);
  }

/*   function call() public {}
  function addSigner() public {}
  function removeSigner() public {}
  function transferFunds() public {}
  function updateSignaturesRequried() public {} */
}
