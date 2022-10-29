// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import {VRFv2Consumer} from "src/chainlinkVRF.sol";

contract ChainlinkScript is Script {
    function setUp() public {}

    // The two broadcast functions basically record any trxs happening between the two calls
    // and save them to a special file
    function run() public {
        vm.startBroadcast();
        VRFv2Consumer VRFv2 = new VRFv2Consumer(4177);
        vm.stopBroadcast();
    }

    // We now have a script ready to run, but we still need to set up our environment variables
    // to correctly deploy our smart contract
    // .env file
    // Then we want to run source .env - this allows us to load our
    // environment variables into the terminal
}
