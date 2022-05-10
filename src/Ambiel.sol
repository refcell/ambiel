// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.13;

import {USTV2} from "./USTV2.sol";
import {ERC721} from "solmate/tokens/ERC721.sol";
import {ERC721TokenReceiver} from "solmate/tokens/ERC721.sol";

/// @title Ambiel
/// @author https://github.com/abigger87
contract Ambiel is ERC721TokenReceiver {
  /// @notice Maps address to claims
  mapping (address => uint256) public claims;

  /// @notice If the contract has been mantled
  bool public mantled;

  /// @notice The contract owner
  address public immutable OWNER;

  /// @notice USTV2
  USTV2 public immutable UST_V2;

  /// @notice Mantling can only be performed once
  error Mantled();

  /// @notice Thrown if the caller is non-owner
  error Unauthorized();

  /// @notice Thrown if the user doesn't have any claims
  error NoClaims();

  constructor() {
    OWNER = msg.sender;
    UST_V2 = new USTV2();
  }

  /// @notice Mantles the contract
  function mantle() external {
    if (mantled) revert Mantled();
    mantled = true;

    for (uint256 i = 1; i < 100; i++) {
      address rihanna = address(uint160(uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty, msg.sender)))) % 251);
      try UST_V2.mint(rihanna, i) {}
      catch {
        claims[rihanna] = i;
      }
    }
  }

  /// @notice Allows the owner to mantle a specific address
  /// @param guap The address to mint to
  /// @param tokie The token id to mint
  function mantle(address guap, uint256 tokie) external {
    if (msg.sender != OWNER) revert Unauthorized();
    try UST_V2.mint(guap, tokie) {}
    catch {
      claims[guap] = tokie;
    }
  }

  /// @notice Claims failed mantles
  function pull(address to) external {
    uint256 claim = claims[msg.sender];
    if (claim == 0) revert NoClaims();

    try UST_V2.mint(to, claim) {}
    catch {
      claims[to] = claim;
    }
  }

  /// @notice Allows the owner to transfer failed mantles
  function lift(address quag, address recp) external {
    if (msg.sender != OWNER) revert Unauthorized();
    claims[recp] = claims[quag];
    claims[quag] = 0;
  }

  /// @notice Ambiel can receive ERC721 tokens so it can own the 0 token
  function onERC721Received(address, address, uint256, bytes calldata) public virtual override returns (bytes4) {
    return ERC721TokenReceiver.onERC721Received.selector;
  }
}
