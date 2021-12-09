//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "./interface/IAirdrop.sol";
import "./interface/IEdition.sol";

contract Airdrop is IAirdrop {

    IEdition public immutable nftToken;
    IERC20 public immutable gnomeToken;
    address public constant GNOME = 0xE58Eb0Bb13a71d7B95c4C3cBE6Cb3DBb08f9cBFB;
    address public constant EDITION = 0xaf89C5E115Ab3437fC965224D317d09faa66ee3E;
    uint public constant TRNASFER_AMOUNT = 1000;
    mapping(uint16 => bool) claimStatus;
    constructor(address _nftToken) {
        nftToken = IERC721(_nftToken);
        gnomeToken = IERC20(GNOME);

    }

    function claimAirdrop(uint16[] calldata _tokenIds) override public {
        for(uint8 i = 0; i < _tokenIds.length; i++) {
            uint16 tokenId = _tokenIds[i];
            require(nftToken.ownerOf(tokenId) == msg.sender, "ERC721: not owner of token");
            require(nftToken.tokenToEdition(tokenId) == 184, "ERC721: not proper edition");
            require(!isTokenUsed(tokenId), "Airdrop: token is already claimed!");

            gnomeToken.transfer(msg.sender, TRNASFER_AMOUNT);
        }
    }

    function isTokenUsed(uint8 id) external view override returns (bool result) {
        return claimStatus[id];
    }

    function setTokenUsed(uint16 id) public view override {
        claimStatus[id] = true;
    }
}
