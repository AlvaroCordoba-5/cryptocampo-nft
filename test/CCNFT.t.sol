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

    uint256 public constant NFT_VALUE = 100 * 10 ** 18; 
    function setUp() public {
      
        busd = new BUSD();
        ccnft = new CCNFT();

        
        ccnft.setFundsToken(address(busd));
        ccnft.setFundsCollector(fundsCollector);
        ccnft.setFeesCollector(feesCollector);
        ccnft.setMaxValueToRaise(1000000 * 10 ** 18);
        ccnft.setMaxBatchCount(10);
        ccnft.setBuyFee(100);
        ccnft.addValidValues(NFT_VALUE);
        ccnft.setCanBuy(true);

       
        busd.transfer(buyer, 10000 * 10 ** 18);
    }

    function testBuyNFT() public {
        uint256 amount = 2;
        uint256 totalCost = NFT_VALUE * amount;
        uint256 fee = (totalCost * ccnft.buyFee()) / 10000; 

        vm.startPrank(buyer);

        
        busd.approve(address(ccnft), totalCost + fee);

  
        ccnft.buy(NFT_VALUE, amount);


        assertEq(ccnft.balanceOf(buyer), 2);
        assertEq(ccnft.ownerOf(1), buyer);
        assertEq(ccnft.ownerOf(2), buyer);

        
        assertEq(busd.balanceOf(fundsCollector), totalCost);
        assertEq(busd.balanceOf(feesCollector), fee);

        vm.stopPrank();
    }
}