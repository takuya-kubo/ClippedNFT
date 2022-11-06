// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
import "./ILICENSE.sol";
import "./ILICENSEAgrement.sol";
import "@openzeppelin/contracts/utils/introspection/IERC165.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract LICENSE is IERC165, ILicensingAgreement, ILICENSE {
  struct License {
    bool _active;
    uint64 _timeOfSignature;
    uint64 _expiryTime;
    string _licenseUri;
    uint256 _rate;
  }

  // Mapping from id to address to addressID to license ID
  mapping(uint256 => mapping(address => mapping(uint256 => uint256))) private _licenseIds; 

  // Mapping from license ID to license
  mapping(uint256 => License) private _licenses;

  // Mapping from license ID to approved address
  mapping(uint256 => address) private _licenseApprovals;

  constructor() {}

  function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165) returns (bool) {
  }

  function isLicensed(
    uint256 id,
    address to,
    uint256 toId,
    uint256 licenseId
  ) external view virtual override returns (bool licensed) {
    return _exists(id, to, toId) && _existsLicense(licenseId);
  }

  function _licenseId(uint256 id, address to, uint256 toId) internal view virtual returns (uint256) {
    return _licenseIds[id][to][toId];
  }

  function _exists(uint256 id, address to, uint256 toId) internal view virtual returns (bool) {
    return _licenseId(id, to, toId) != 0;
  }

  function _licence(uint256 licenseId) internal view virtual returns (License memory) {
    return _licenses[licenseId];
  }

  function _existsLicense(uint256 licenseId) internal view virtual returns (bool) {
    return _licence(licenseId)._timeOfSignature != 0;
  }

  // compare with current time
  function createLicense(
    uint256 licenseId,
    string memory licenseUri,
    uint64 expiryTime,
    uint256 rate
  ) internal virtual {
    require(!_existsLicense(licenseId), "LICENSE: Already created");
    require(uint256(expiryTime) > block.timestamp, "LICENSE: invalid license ID");

    License memory license = License(true, uint64(block.timestamp), expiryTime, licenseUri, rate);
    _licenses[licenseId] = license;
  }

  function licenseTo(uint256 id, address to, uint256 toId, uint256 licenseId) external virtual override {
    require(getApprovedLicensor(licenseId) == msg.sender || address(this) == msg.sender, "LICENSE: caller is not contract or approved");

    _licenseIds[id][to][toId] = licenseId;
  } 

  function _licenseTo(uint256 id, address to, uint256 toId, uint256 licenseId) internal virtual {
    require(_existsLicense(licenseId), "LICENSE: invalid license ID");
    require(uint256(_licenses[licenseId]._expiryTime) >= block.timestamp, "LICENSE: Expired");

    _licenseIds[id][to][toId] = licenseId;
    emit LicenseTo(id, to, toId, licenseId);
  } 

  function approveLicensor(address approved, uint256 licenseId) external virtual override {
    require(getApprovedLicensor(licenseId) == msg.sender || address(this) == msg.sender, "LICENSE: caller is not contract or approved");
    require(_existsLicense(licenseId), "LICENSE: invalid license ID");

    _licenseApprovals[licenseId] = approved;
    emit ApprovalLicensor(approved, licenseId);
  }
  
  function getApprovedLicensor(uint256 licenseId) public view virtual override returns (address) {
    require(_existsLicense(licenseId), "LICENSE: invalid license ID");

    return _licenseApprovals[licenseId];
  }

  function licensingInfo(uint256 licenseId) external view virtual override returns (
      bool active,
      uint64 timeOfSignature,
      uint64 expiryTime,
      string memory licenseUri
  ) {
    require(_existsLicense(licenseId), "LICENSE: invalid license ID");
    License memory license = _licenses[licenseId];
    return (license._active, license._timeOfSignature, license._expiryTime, license._licenseUri); 
  }

  // The decimals is 9, means to divide the rate by 1,000,000,000
  function royaltyRate(uint256 licenceId) external view virtual override returns (uint256 rate){ 
    require(_existsLicense(licenceId), "LICENSE: invalid license ID");
    return _licenses[licenceId]._rate;
  }

  function getLiceseUri(uint256 licenceId) external view virtual override returns (string memory _liceseUri) {
    require(_existsLicense(licenceId), "LICENSE: invalid license ID");
    return _licenses[licenceId]._licenseUri;
  }
}






  