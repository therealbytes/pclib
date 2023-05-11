// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Caller} from "./Caller.sol";
import {MemLib} from "./MemLib.sol";

contract Debugger  {
    function debug(
        address to,
        uint256 _gas,
        bytes memory input,
        uint256 outSize
    ) public returns (bytes memory) {
        uint256 p0 = MemLib.getFmp();
        uint256 p1 = MemLib.putBytes(p0, input);
        Caller.call(_gas, to, 0, p0, p1 - p0, p0 + 0x20, outSize);
        MemLib.putUint(p0, outSize);
        bytes memory output;
        assembly {
            output := p0
        }
        return output;
    }
}
