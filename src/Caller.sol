// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

library Caller {
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

    function staticcall(
        uint256 _gas,
        address to,
        uint256 inOffset,
        uint256 inSize,
        uint256 outOffset,
        uint256 outSize
    ) internal {
        assembly {
            if iszero(
                staticcall(_gas, to, inOffset, inSize, outOffset, outSize)
            ) {
                revert(0, 0)
            }
        }
    }
}
