pragma solidity ^0.8;

import "../aa/aa.sol";

interface IAccount {
  function validateUserOp
      (UserOperation calldata userOp, bytes32 userOpHash, uint256 missingAccountFunds)
      external returns (uint256 validationData);
}