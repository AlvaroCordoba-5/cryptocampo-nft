// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Script.sol";
import "../src/BUSD.sol";
import "../src/CCNFT.sol";

contract DeployScript is Script {
    function run() external {
        
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        
        vm.startBroadcast(deployerPrivateKey);

        BUSD busd = new BUSD();
        console.log("BUSD desplegado en:", address(busd));

        CCNFT ccnft = new CCNFT();
        console.log("CCNFT desplegado en:", address(ccnft));

        vm.stopBroadcast();
    }
}