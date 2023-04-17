// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

library MemLib {
    function getFmp() internal pure returns (uint256) {
        uint256 p;
        assembly {
            p := mload(0x40)
        }
        return p;
    }

    function setFmp(uint256 p) internal pure {
        assembly {
            mstore(0x40, p)
        }
    }

    function putBytes32(uint256 p, bytes32 x) internal pure returns (uint256) {
        assembly {
            mstore(p, x)
        }
        return p + 0x20;
    }

    function getBytes32(uint256 p) internal pure returns (bytes32, uint256) {
        bytes32 x;
        assembly {
            x := mload(p)
        }
        return (x, p + 0x20);
    }

    function putUint(uint256 p, uint256 x) internal pure returns (uint256) {
        return putBytes32(p, bytes32(x));
    }

    function getUint(uint256 p) internal pure returns (uint256, uint256) {
        bytes32 x;
        (x, p) = getBytes32(p);
        return (uint256(x), p);
    }

    function putInt(uint256 p, int256 x) internal pure returns (uint256) {
        return putUint(p, uint256(x));
    }

    function getInt(uint256 p) internal pure returns (int256, uint256) {
        uint256 x;
        (x, p) = getUint(p);
        return (int256(x), p);
    }

    function putBool(uint256 p, bool x) internal pure returns (uint256) {
        return putUint(p, x ? 1 : 0);
    }

    function getBool(uint256 p) internal pure returns (bool, uint256) {
        uint256 x;
        (x, p) = getUint(p);
        return (x != 0, p);
    }

    function putAddress(uint256 p, address x) internal pure returns (uint256) {
        return putUint(p, uint256(uint160(x)));
    }

    function getAddress(uint256 p) internal pure returns (address, uint256) {
        uint256 x;
        (x, p) = getUint(p);
        return (address(uint160(x)), p);
    }

    function putBytes(
        uint256 p,
        bytes memory x
    ) internal pure returns (uint256) {
        uint256 wordCount = (x.length + 0x1f) / 0x20;
        bytes32 value;
        uint256 xp;
        assembly {
            xp := x
        }
        for (uint256 i = 0; i < wordCount + 1; i++) {
            (value, xp) = getBytes32(xp);
            p = putBytes32(p, value);
        }
        return p;
    }

    function getBytes(uint256 p) internal pure returns (bytes memory, uint256) {
        (uint256 length, ) = getUint(p);
        bytes memory x = new bytes(length);
        uint256 wordCount = (length + 0x1f) / 0x20;
        bytes32 value;
        uint256 xp;
        assembly {
            xp := x
        }
        for (uint256 i = 0; i < wordCount + 1; i++) {
            (value, p) = getBytes32(p);
            xp = putBytes32(xp, value);
        }
        return (x, p);
    }
}
