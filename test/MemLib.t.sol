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

    function testFuzz_PutRefBytes(bytes memory value) public {
        uint256 o = MemLib.getFmp();
        uint256 p1;
        uint256 p2;
        p1 = MemLib.putBytes(o, value);
        MemLib.setFmp(p1);
        assertEq(
            p1,
            o + 0x20 + 0x20 * ((value.length + 0x1f) / 0x20),
            "[put] pointer mismatch"
        );
        bytes memory v1;
        (v1, p2) = MemLib.refBytes(o);
        assertEq(value, v1, "value mismatch");
        assertEq(p1, p2, "[get] pointer mismatch");

        if (value.length == 0) return;
        
        bytes memory v2;
        (v2, ) = MemLib.refBytes(o);
        assertEq(v1, v2, "[2nd ref] value mismatch");
        v1[0] = ~v1[0];
        assertEq(v1, v2, "[mod ref] value mismatch");
    }

    function testFuzz_PutCopyBytes(bytes memory value) public {
        uint256 o = MemLib.getFmp();
        uint256 p1;
        uint256 p2;
        p1 = MemLib.putBytes(o, value);
        MemLib.setFmp(p1);
        assertEq(
            p1,
            o + 0x20 + 0x20 * ((value.length + 0x1f) / 0x20),
            "[put] pointer mismatch"
        );
        bytes memory v1;
        (v1, p2) = MemLib.copyBytes(o);
        assertEq(value, v1, "value mismatch");
        assertEq(p1, p2, "[get] pointer mismatch");

        if (value.length == 0) return;
        
        bytes memory v2;
        (v2, ) = MemLib.copyBytes(o);
        assertEq(v1, v2, "[2nd copy] value mismatch");
        v1[0] = ~v1[0];
        assertNotEq(v1[0], v2[0], "[mod copy] expected value mismatch");
    }
}
