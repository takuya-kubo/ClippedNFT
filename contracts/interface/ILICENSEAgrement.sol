// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
import "@openzeppelin/contracts/utils/introspection/IERC165.sol";

interface ILicensingAgreement is IERC165 {

  function licensingInfo(
      uint256 licenceId
  ) external view returns (
      bool active,
      uint64 timeOfSignature,
      uint64 expiryTime,
      string memory licenseUri
  );

  function getLiceseUri(uint256 licenceId) external view returns (string memory liceseUri);
  
  // The decimals is 9, means to divide the rate by 1,000,000,000
  function royaltyRate(uint256 licenceId) external view returns (uint256 rate);
}
