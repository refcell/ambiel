// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.13;

import {USTV2} from "../USTV2.sol";
import {Ambiel} from "../Ambiel.sol";

import "forge-std/Test.sol";

contract AmbielTest is Test {
    using stdStorage for StdStorage;

    Ambiel ambiel;
    USTV2 ustV2;
    NonRecipient nonrecp;
    address public constant warden = address(0x420);

    /// @notice Sets up the testing suite
    function setUp() public {
        vm.prank(warden);
        ambiel = new Ambiel();
        nonrecp = new NonRecipient();
        ustV2 = ambiel.UST_V2();
    }

    /// @notice THE MEGA TEST
    function testAmbiel() public {
        // Can mantle to an invalid recipient - results in a claim
        vm.prank(warden);
        ambiel.mantle(address(nonrecp), 1);
        assertEq(ambiel.claims(address(nonrecp)), 1);
        assertEq(ustV2.balanceOf(address(nonrecp)), 0);

        // Can mantle a valid recipient
        vm.prank(warden);
        ambiel.mantle(address(ambiel), 2);
        assertEq(ambiel.claims(address(ambiel)), 0);
        assertEq(ustV2.balanceOf(address(ambiel)), 2); // since ambiel also owns the 0 token

        // warden can lift the claim
        address pon_de_replay = address(0x1337);
        vm.prank(warden);
        ambiel.lift(address(nonrecp), address(pon_de_replay));
        assertEq(ambiel.claims(address(nonrecp)),0);
        assertEq(ambiel.claims(address(pon_de_replay)), 1);

        // The lifted address can now pull
        vm.prank(pon_de_replay);
        ambiel.pull(address(ambiel));
        assertEq(ustV2.balanceOf(address(ambiel)), 3);
    }
}

contract NonRecipient {
    string public constant HEADLINE = "UST_DEPEGGED_HELLO_FBI_FEMBOYS";
}
