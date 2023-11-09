// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;

import {ERC20} from "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

import {ERC721} from "openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";

contract StudentNft is ERC721 {
    address public constant EvaluatorToken =
        0x5cd93e3B0afBF71C9C84A7574a5023B4998B97BE;

    constructor() ERC721("AntoineSNft", "ASN") {
    // I modified the constructor trying to to the ex9. To complete exercices before The constructor should be empty
        _mint(EvaluatorToken, 1);
        _mint(msg.sender, 2);
        setApprovalForAll(EvaluatorToken, true);
    }

    function mint(uint256 tokenIdToMint) external {
        require(
            ERC20(EvaluatorToken).allowance(EvaluatorToken, address(this)) ==
                10 * 10 ** 18,
            "cannot mint nft without collateral"
        );
        _mint(msg.sender, tokenIdToMint);
    }

    function burn(uint256 tokenIdToBurn) external {
        if (msg.sender != ownerOf(tokenIdToBurn)) {
            require(
                isApprovedForAll(ownerOf(tokenIdToBurn), msg.sender),
                "cannot burn nft"
            );
        }
        _burn(tokenIdToBurn);
    }
}
