// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "lib/forge-std/src/Test.sol";
import "../src/MemLib.sol";

contract GatewayTest is Test {

    function setUp() public {}

    function testFuzz_PutGetUint(uint256[] memory values) public {
        if (values.length == 0) return;
        uint256 p1 = MemLib.getFmp();
        uint256 p2 = p1;
        for (uint256 i = 0; i < values.length; i++) {
            p1 = MemLib.putUint(p1, values[i]);
        }
        MemLib.setFmp(p1);
        uint256 v;
        for (uint256 i = 0; i < values.length; i++) {
            (v, p2) = MemLib.getUint(p2);
            assertEq(values[i], v, "value mismatch");
        }
        assertEq(p1, p2, "pointer mismatch");
    }

    function testFuzz_PutGetBytes(bytes memory value) public {
        uint256 p1 = MemLib.getFmp();
        uint256 p2 = p1;
        p1 = MemLib.putBytes(p1, value);
        MemLib.setFmp(p1);
        assertEq(p2 + 0x20 + 0x20 * ((value.length + 0x1f) / 0x20), p1, "[put] pointer mismatch");
        bytes memory v;
        (v, p2) = MemLib.getBytes(p2);
        assertEq(value, v, "value mismatch");
        assertEq(p1, p2, "[get] pointer mismatch");
    }
}
