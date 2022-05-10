// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.13;

import {ERC721} from "solmate/tokens/ERC721.sol";

/// @title USTV2
/// @author https://github.com/abigger87
contract USTV2 is ERC721 {

  /// @notice The owner of the contract
  address public immutable OWNER;

  error Unauthorized();

  constructor() ERC721("USTV2", "USTV2") {
    OWNER = msg.sender;
    _mint(OWNER, 0);
  }

  function tokenURI(uint256) public pure virtual override returns (string memory) {}

  /// @notice The owner can mint
  function mint(address to, uint256 tokenId) external {
    if (msg.sender != OWNER) revert Unauthorized();
    _safeMint(to, tokenId);
  }
}