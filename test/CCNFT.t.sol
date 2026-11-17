// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../src/BUSD.sol";
import "../src/CCNFT.sol";

contract CCNFTTest is Test {
    BUSD public busd;
    CCNFT public ccnft;

    address public owner = address(this);
    address public buyer = address(0x123);
    address public fundsCollector = address(0x456);
    address public feesCollector = address(0x789);

    uint256 public constant NFT_VALUE = 100 * 10 ** 18; // 100 BUSD por NFT

    function setUp() public {
        //Desplegar BUSD y CCNFT
        busd = new BUSD();
        ccnft = new CCNFT();

        //Configurar los setters en CCNFT
        ccnft.setFundsToken(address(busd));
        ccnft.setFundsCollector(fundsCollector);
        ccnft.setFeesCollector(feesCollector);
        ccnft.setMaxValueToRaise(1000000 * 10 ** 18);
        ccnft.setMaxBatchCount(10);
        ccnft.setBuyFee(100); // 1% de comisión (100 / 10000)[cite: 4]
        ccnft.addValidValues(NFT_VALUE);
        ccnft.setCanBuy(true);

        //Transferir algunos BUSD al comprador de prueba
        busd.transfer(buyer, 10000 * 10 ** 18);
    }

    function testBuyNFT() public {
        uint256 amount = 2; // Comprar 2 NFTs
        uint256 totalCost = NFT_VALUE * amount; // 200 BUSD
        uint256 fee = (totalCost * ccnft.buyFee()) / 10000; // Comisión de compra[cite: 4]

        // Simular acciones desde la perspectiva del comprador
        vm.startPrank(buyer);

        //El comprador aprueba al contrato CCNFT para gastar sus BUSD[cite: 4]
        busd.approve(address(ccnft), totalCost + fee);

        // Ejecutar la compra (buy)[cite: 4]
        ccnft.buy(NFT_VALUE, amount);

        // Verificaciones (Assertions)
        assertEq(ccnft.balanceOf(buyer), 2);
        assertEq(ccnft.ownerOf(1), buyer);
        assertEq(ccnft.ownerOf(2), buyer);

        // Verificar que los fondos llegaron a las direcciones recolectoras correspondientes
        assertEq(busd.balanceOf(fundsCollector), totalCost);
        assertEq(busd.balanceOf(feesCollector), fee);

        vm.stopPrank();
    }
}