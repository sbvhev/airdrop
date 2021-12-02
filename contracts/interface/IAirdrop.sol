// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IAirdrop {
    function claimAirdrop(uint16[] calldata) external;
    function isTokenUsed(uint8) external view returns (bool);
    function setTokenUsed(uint16) external view;
}