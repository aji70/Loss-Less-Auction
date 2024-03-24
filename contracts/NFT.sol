// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MyNFT {
    uint256 private _tokenIds;
    mapping(uint256 => address) private _tokenOwners;
    mapping(address => uint256[]) private _ownedTokens;

    event Transfer(
        address indexed from,
        address indexed to,
        uint256 indexed tokenId
    );

    constructor() {}

    function mint(address recipient) public returns (uint256) {
        _tokenIds++;
        uint256 newTokenId = _tokenIds;
        _tokenOwners[newTokenId] = recipient;
        _ownedTokens[recipient].push(newTokenId);
        emit Transfer(address(0), recipient, newTokenId);
        return newTokenId;
    }

    function balanceOf(address owner) public view returns (uint256) {
        return _ownedTokens[owner].length;
    }

    function ownerOf(uint256 tokenId) public view returns (address) {
        return _tokenOwners[tokenId];
    }

    function transferFrom(address from, address to, uint256 tokenId) public {
        require(_tokenOwners[tokenId] == from, "Not the token owner");
        require(to != address(0), "Cannot transfer to zero address");

        _tokenOwners[tokenId] = to;
        _removeTokenFromOwnerEnumeration(from, tokenId);
        _ownedTokens[to].push(tokenId);

        emit Transfer(from, to, tokenId);
    }

    function _removeTokenFromOwnerEnumeration(
        address from,
        uint256 tokenId
    ) private {
        uint256 lastTokenIndex = _ownedTokens[from].length - 1;
        uint256 tokenIndex;
        for (uint256 i = 0; i < _ownedTokens[from].length; i++) {
            if (_ownedTokens[from][i] == tokenId) {
                tokenIndex = i;
                break;
            }
        }

        _ownedTokens[from][tokenIndex] = _ownedTokens[from][lastTokenIndex];
        _ownedTokens[from].pop();
    }
}
