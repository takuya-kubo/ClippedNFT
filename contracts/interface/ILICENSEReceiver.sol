// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
import "@openzeppelin/contracts/utils/introspection/IERC165.sol";

interface ILICENSEReceiver is IERC165 {

  function numberOfCredentials(
    uint256 id
  ) external view returns (
    uint256 number
  );

  function getLicense(
    uint256 id,
    uint256 credentialId
  ) external view returns (
    address parent,
    uint256 parentId,
    uint256 licenseId
  );

  function setLicense(
    uint256 id,
    address parent,
    uint256 parentId,
    uint256 licenseId
  ) external payable; 
}