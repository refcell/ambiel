// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.13;

/// @title Ambiel
/// @author https://github.com/abigger87
contract Ambiel {
  /// @notice Maps address to claims
  mapping (address => uint256) public claims;

  /// @notice If the contract has been mantled
  bool public mantled;

  /// @notice The contract owner
  address public immutable OWNER;

  /// @notice Mantling can only be performed once
  error Mantled();

  /// @notice Thrown if the caller is non-owner
  error Unauthorized();

  constructor() {
    OWNER = msg.sender;
  }

  /// @notice Mantles the contract
  function mantle() external {
    if (mantled) revert Mantled();
    mantled = true;

    for (uint256 i = 0; i < 100; i++) {
      address rihanna = address(uint160(uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty, msg.sender)))) % 251);
      (bool success,) = rihanna.call("");
    }

  }

  /// @notice Allows the owner to transfer failed mantles
  function lift(address quag, address recp) external {
    if (msg.sender != OWNER) revert Unauthorized();
    claims[recp] = claims[quag];
    claims[quag] = 0;
  }
}
