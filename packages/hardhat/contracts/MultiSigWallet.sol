pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT

import "hardhat/console.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract MultiSigWallet {

  using ECDSA for bytes32;

  mapping (address => bool) public isOwner;
  mapping (address => bool) public hasSigned;
  uint256 public signaturesRequired;
  uint256 public nonce = 0;
  uint256 public ownerCounter = 0;
  string public purpose = "Building Unstoppable Apps!!!";

  event SetPurpose(address sender, string purpose);

  modifier onlyOwner() {
    require(isOwner[msg.sender], "not an owner");
    _;
  }

  modifier onlySelf() {
    require(msg.sender == address(this), "only MultiSigWallet contract can invoke this function");
    _;
  }

  constructor(address[] memory _owners, uint256 _sigsRequired) payable {
    require(_owners.length > 0, "MetaMultiSigWallet must have at least 1 owner");
    require(_sigsRequired <= _owners.length, "Number of signatures must be less or equal to number of owners");

    for(uint256 i; i < _owners.length; i++){
      require(_owners[i] != address(0), "owner cannot be address(0)");
      require(!isOwner[_owners[i]], "duplicated owner");
      isOwner[_owners[i]] = true;
      ownerCounter++;
    }
    signaturesRequired = _sigsRequired;
  }

  function getHash(uint256 _nonce, address to, uint256 value) public view returns (bytes32) {
    return keccak256(abi.encodePacked(address(this), purpose, _nonce, to, value));
  }

  function executeTransaction(address payable _to, uint256 _value, bytes[] memory _signatures) public onlyOwner {
    bytes32 hash = getHash(nonce, _to, _value);
    address[] memory listOfSigners;
    uint256 validSignatures;
    
    for(uint256 i; i < _signatures.length; i++){
      address signer = recover(hash, _signatures[i]);
      require(isOwner[signer], "One of the signers is not an Owners");
      require(!hasSigned[signer], "One of the signers signed more than once");
      hasSigned[signer] = true;
      listOfSigners[i] = signer;
      validSignatures++;
    }

    require(validSignatures >= signaturesRequired, "Not enough valid signatures");
    
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
    emit SetPurpose(msg.sender, purpose);
  }

  function addSigner(address _newSigner, uint256 _sigsReq) public onlyOwner {
    require(_newSigner != address(0), "New signer cannot be address(0)");
    require(!isOwner[_newSigner], "Signer already exists");
    isOwner[_newSigner] = true;
    ownerCounter++;
    updateSignaturesRequried(_sigsReq);
  }

  function removeSigner(address _oldSigner, uint256 _sigsReq) public onlyOwner {
    require(isOwner[_oldSigner], "Signer you want to remove is not an owner");
    isOwner[_oldSigner] = false;
    ownerCounter--;
    updateSignaturesRequried(_sigsReq);
  }

  function updateSignaturesRequried(uint256 _sigsReq) public onlyOwner {
    require(_sigsReq > 0, "Signatures required cannot be 0.");
    require(_sigsReq <= ownerCounter, "Number of signatures required cannot be more than number of owners.");
    signaturesRequired = _sigsReq;
  }

  receive() external payable {}
  fallback() external payable {}
}
