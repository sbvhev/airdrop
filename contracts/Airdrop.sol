//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

import "./interface/IAirdrop.sol";
import "./interface/IEdition.sol";

contract Airdrop is IAirdrop {

    using SafeMath for uint256;

    IEdition public immutable nftToken;
    IERC20 public immutable gnomeToken;
    address public constant GNOME = 0xE58Eb0Bb13a71d7B95c4C3cBE6Cb3DBb08f9cBFB;
    address public constant EDITION = 0xaf89C5E115Ab3437fC965224D317d09faa66ee3E;
    mapping(uint16 => bool) claimStatus;
    constructor(address _nftToken) {
        nftToken = IERC721(_nftToken);
        gnomeToken = IERC20(GNOME);

    }

    function claimAirdrop(uint16[] calldata _tokenIds) override public {
        uint256 balance;
        for(uint8 i = 0; i < _tokenIds.length; i++) {
            uint16 tokenId = _tokenIds[i];
            require(nftToken.ownerOf(tokenId) == msg.sender, "ERC721: not owner of token");
            require(nftToken.tokenToEdition(tokenId) == 184, "ERC721: not proper edition");
            require(!isTokenUsed(tokenId), "Airdrop: token is already claimed!");

            setTokenUsed(i);
            balance = balance.add(1000);
        }
        gnomeToken.transfer(msg.sender, balance.mul(1e18));
    }

    function isTokenUsed(uint16 id) external view override returns (bool result) {
        return claimStatus[id];
    }

    function setTokenUsed(uint16 id) override {
        claimStatus[id] = true;
    }
}
