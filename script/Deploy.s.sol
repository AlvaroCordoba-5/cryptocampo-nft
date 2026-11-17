// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Script.sol";
import "../src/BUSD.sol";
import "../src/CCNFT.sol";

contract DeployScript is Script {
    function run() external {
        // Lee la clave privada desde las variables de entorno (.env)
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        
        vm.startBroadcast(deployerPrivateKey);

        // Desplegar el token BUSD (ERC-20 con 10 millones de suministro inicial)
        BUSD busd = new BUSD();
        console.log("BUSD desplegado en:", address(busd));

        // Desplegar el contrato del mercado de NFTs (CCNFT)
        CCNFT ccnft = new CCNFT();
        console.log("CCNFT desplegado en:", address(ccnft));

        vm.stopBroadcast();
    }
}