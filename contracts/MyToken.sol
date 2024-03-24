// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;

// import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
// import "./interfaces/IERC721.sol";
// import "@openzeppelin/contracts/access/Ownable.sol";
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract MyToken is ERC721 {
    uint256 private _nextTokenId;
    address DIAMOND;

    constructor() ERC721("MyToken", "MTK") {
        DIAMOND = msg.sender;
    }

    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://QmZCD9T14Rrbi2rfsbFbinZLH6UaSwGtkDeuokvLvALxif/";
    }

    function safeMint() public {
        uint256 tokenId = _nextTokenId++;
        _safeMint(msg.sender, tokenId);
    }
}
