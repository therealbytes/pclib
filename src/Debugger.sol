// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {MemLib} from "./MemLib.sol";

contract Debugger {
    function call(
        uint256 _gas,
        address to,
        uint256 value,
        uint256 inOffset,
        uint256 inSize,
        uint256 outOffset,
        uint256 outSize
    ) internal {
        assembly {
            if iszero(
                call(_gas, to, value, inOffset, inSize, outOffset, outSize)
            ) {
                revert(0, 0)
            }
        }
    }

    function debug(
        address to,
        uint256 _gas,
        bytes memory input,
        uint256 outSize
    ) public returns (bytes memory) {
        uint256 p0 = MemLib.getFmp();
        uint256 p1 = MemLib.putBytes(p0, input);
        call(_gas, to, 0, p0, p1 - p0, p0 + 0x20, outSize);
        MemLib.putUint(p0, outSize);
        bytes memory output;
        assembly {
            output := p0
        }
        return output;
    }
}
