//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract HkNFT is ERC721, ERC721URIStorage, ERC721Burnable, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    using Strings for uint256;
    string public baseURI = "";

    struct HkNFTValue {
        string name;
        uint256 id;
        uint256 dna;
        uint8 level;
        uint8 rarity;
    }

    HkNFTValue[] public nfts;

    event NewNFT(address indexed owner, uint256 id, uint256 dna);

    constructor() ERC721("HungKnow NFT", "HKNFT") {}

    /***
     * NFT CRUDs
     */
    function _mintNFT(string memory _name, uint256 _dna) internal {
        HkNFTValue memory newNFT = HkNFTValue(_name, _tokenIdCounter.current(), _dna, 1, 50);
        nfts.push(newNFT);
        // Mint to the same callee address
        _safeMint(msg.sender, _tokenIdCounter.current());
        _tokenIdCounter.increment();

        emit NewNFT(msg.sender, newNFT.id, newNFT.dna);
    }

    function getNft() public view returns(HkNFTValue[] memory) {
        return nfts;
    }

    /**
     * Helpers
     */
    function _genRandomDna(string memory _str) internal pure returns(uint256) {
        uint256 randomNum = uint256(keccak256(abi.encodePacked(_str)));
        return randomNum % 10**16;
    }

    function createRandomNft(string memory _name) public {
        uint256 randomDna = _genRandomDna(_name);
        _mintNFT(_name, randomDna);
    }

    function _burn(uint256 tokenId)
        internal
        override(ERC721, ERC721URIStorage)
    {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function currentCounter() public view returns (uint256) {
        return _tokenIdCounter.current();
    }

    function freeMint(address to, string memory nftTokenURI) public {
        _safeMint(to, _tokenIdCounter.current());
        _setTokenURI(_tokenIdCounter.current(), nftTokenURI);
        _tokenIdCounter.increment();
    }
}
