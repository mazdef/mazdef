// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
/* SCROLL CATS FREE NFT COLLECTION SUPPLU:3000 */

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyFreeNFTCollection is ERC721Enumerable, Ownable {
    uint256 public constant MAX_SUPPLY = 3000;
    uint256 public constant RESERVED_SUPPLY = 300;
    uint256 public constant FREE_SUPPLY = MAX_SUPPLY - RESERVED_SUPPLY;
    string private _baseTokenURI;
    mapping(address => bool) private _hasMinted;

    constructor(string memory baseTokenURI) ERC721("MyFreeNFTCollection", "MFNC") {
        _baseTokenURI = baseTokenURI;
        /* Reserve the first 300 NFTs for the owner/*/
        for (uint256 i = 1; i <= RESERVED_SUPPLY; i++) {
            _safeMint(msg.sender, i);
        }
    }

    function mint() public {
        require(totalSupply() < MAX_SUPPLY, "Exceeds MAX_SUPPLY");
        require(!_hasMinted[msg.sender], "Address has already minted an NFT");
        require(totalSupply() - RESERVED_SUPPLY < FREE_SUPPLY, "No more free NFTs available");

        uint256 tokenId = totalSupply() + 1;
        _safeMint(msg.sender, tokenId);
        _hasMinted[msg.sender] = true;
    }

    function setBaseURI(string memory baseTokenURI) public onlyOwner {
        _baseTokenURI = baseTokenURI;
    }

    function _baseURI() internal view override returns (string memory) {
        return _baseTokenURI;
    }

    function withdraw() public onlyOwner {
        uint256 balance = address(this).balance;
        payable(msg.sender).transfer(balance);
    }
}
