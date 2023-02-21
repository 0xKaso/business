// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.12;

// Uncomment this line to use console.log
// import "hardhat/console.sol";
import "@solvprotocol/erc-3525/ERC3525.sol";

contract MyERC3525 is ERC3525 {

constructor()
    ERC3525("MyERC3525", "MY3525", 18) {
    }
}