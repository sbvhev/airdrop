//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "./interface/IAirdrop.sol";

contract Airdrop is IAirdrop {

    IERC721 public immutable nftToken;
    IERC20 public immutable gnomeToken;
    address public constant GNOME = 0xE58Eb0Bb13a71d7B95c4C3cBE6Cb3DBb08f9cBFB;
    uint public constant TRNASFER_AMOUNT = 1000;
    mapping(uint16 => bool) claimStatus;
    constructor(address _nftToken) {
        nftToken = _nftToken;
        gnomeToken = IERC20(GNOME);
    }

    function claimAirdrop(uint16[] calldata _tokenIds) override public {
        for(uint8 i = 0; i < _tokenIds.length; i++) {
            uint16 tokenId = _tokenIds[i];
            require(nftToken.ownerOf(tokenId) == msg.sender, "ERC721: not owner of token");

            if(!isTokenUsed(tokenId)) {
                gnomeToken.transfer(msg.sender, TRNASFER_AMOUNT);
            }
        }
    }

    function isTokenUsed(uint8 id) external view override returns (bool result) {
        return claimStatus[id];
    }

    function setTokenUsed(uint16 id) public view override {
        claimStatus[id] = true;
    }
}