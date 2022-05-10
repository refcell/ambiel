// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.13;

import {ERC721} from "solmate/tokens/ERC721.sol";
import {ERC721TokenReceiver} from "solmate/tokens/ERC721.sol";

/// @title Ambiel
/// @author https://github.com/abigger87
contract Ambiel is ERC721, ERC721TokenReceiver {
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

  /// @notice Thrown if the user doesn't have any claims
  error NoClaims();

  constructor() ERC721("Ambiel", "AMBL") {
    OWNER = msg.sender;
    // 0 token is self
    _mint(address(this), 0);
  }

  /// @notice Mantles the contract
  function mantle() external {
    if (mantled) revert Mantled();
    mantled = true;

    for (uint256 i = 1; i < 100; i++) {
      address rihanna = address(uint160(uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty, msg.sender)))) % 251);
      try _safeMint(rihanna, i) {}
      catch {
        claims[rihanna] = i;
      }
    }
  }

  /// @notice Claims failed mantles
  function pull(address to) external {
    uint256 claim = claims[msg.sender];
    if (!claim) revert NoClaims();

    try _safeMint(to, claim) {}
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
  function onERC721Received(
    address _operator,
    address _from,
    uint256 _id,
    bytes calldata _data
  ) public virtual override returns (bytes4) {
    return ERC721TokenReceiver.onERC721Received.selector;
  }
}
