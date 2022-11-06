// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./interface/ILICENSEReceiver.sol";
import "./interface/LICENSE.sol";

contract ChannelVideo is ERC721, Ownable, ILICENSEReceiver, LICENSE {
    struct Licensee {
        address parent;
        uint256 parentId;
        uint256 licenseId;
    }

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;
    Counters.Counter private _licenseIdCounter;
    string private _baseTokenURI = "";

    // Mapping from id to Licensee object
    mapping(uint256 => Licensee[]) private _licensees;   

    constructor(string memory channel) ERC721(channel, "CVIDEO") {}

    function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721, LICENSE) returns (bool) {
        return interfaceId == type(IERC721).interfaceId ||
        super.supportsInterface(interfaceId);
    }

    function _baseURI() internal view override returns (string memory) {
        return _baseTokenURI;
    }
    
    function safeMint(address to) public onlyOwner {
        _tokenIdCounter.increment();
        uint256 tokenId = _tokenIdCounter.current();
        _safeMint(to, tokenId);
    }

    function createVideoLicense(
        string memory licenseUri,
        uint64 expiryTime,
        uint256 rate
    ) public onlyOwner returns(uint256) {
        _licenseIdCounter.increment();
        uint256 licenseId = _licenseIdCounter.current();
        createLicense(licenseId, licenseUri, expiryTime, rate);
        return (licenseId);
    }

    function licenseTo(uint256 id, address to, uint256 toId, uint256 licenseId) external override onlyOwner {
        _licenseTo(id, to, toId, licenseId);
    } 

    function setBaseURI(string memory newBaseURL) public onlyOwner {
        require(bytes(newBaseURL).length > 0, "wrong base uri");
        _baseTokenURI = newBaseURL;
    }

    function numberOfCredentials(uint256 id) public view override returns (uint256 number){
        return _licensees[id].length;
    }

    function getLicense(
        uint256 id,
        uint256 credentialId
    ) external view override returns (
        address parent,
        uint256 parentId,
        uint256 licenseId
    ) {
        require(numberOfCredentials(id) > credentialId, "invalid LICENSE");

        return (_licensees[id][credentialId].parent, _licensees[id][credentialId].parentId, _licensees[id][credentialId].licenseId);
    }

    function setLicense(
        uint256 id,
        address parent,
        uint256 parentId,
        uint256 licenseId
    ) external override payable onlyOwner  {
        require(parent != address(0), "invalid LICENSE");

        Licensee memory licensee = Licensee(parent, parentId, licenseId);
        _licensees[id].push(licensee);
    }
}