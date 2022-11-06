// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
import "@openzeppelin/contracts/utils/introspection/IERC165.sol";
import "./ILICENSEAgrement.sol";

interface ILICENSE is IERC165, ILicensingAgreement {
    event LicenseTo(uint256 id, address to, uint256 toId, uint256 licenseId);

    event ApprovalLicensor(address indexed approved, uint256 indexed licenseId);
    
    function isLicensed(uint256 id, address to, uint256 toId, uint256 licenseId) external view returns (bool licensed);

    function licenseTo(uint256 id, address to, uint256 toId, uint256 licenseId) external;

    function approveLicensor(address approved, uint256 licenseId) external;
    
    function getApprovedLicensor(uint256 licenseId) external view returns (address);
}