// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;


import {Test} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/FundMe.s.sol";
contract FundMeTest is Test{
    FundMe fundMe;
    DeployFundMe deployFundMe;
    address public USER = makeAddr("user");
    uint256 public constant USER_BALANCE = 10 ether;
    function setUp() external{
        deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER,USER_BALANCE);
    }
    function testMinimumIsFive() public{
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }
    function testOwner() public{
        assertEq(fundMe.getOwner(),msg.sender);
    }
    function testPriceFeedVersion() public{
        uint256 version =  fundMe.getVersion();
        assertEq(version,4);
    }
    function testFundFails() public{
        vm.expectRevert();
        fundMe.fund{value: 0}();
    }
    function testFundUpdates() public{
        vm.prank(USER);
        fundMe.fund{value: USER_BALANCE}();
        uint256 amountFunded =  fundMe.getAddressToAmountFunded(USER);
        assertEq(amountFunded, USER_BALANCE);
    }
    function testGetFundersToArray() public{
        vm.prank(USER);
        fundMe.fund{value: USER_BALANCE}();
        address funder = fundMe.getFunders(0);
        assertEq(funder,USER);
    }
    modifier funded(){
       vm.prank(USER);
        fundMe.fund{value: USER_BALANCE}();
        _; 
    }
    function testOnlyOwnerCanWithdraw() public funded{
        
        vm.prank(USER);
        vm.expectRevert();
        fundMe.withdraw();
    }
    function testWithdrawSingleFunder() public funded{
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();
        uint endingFundMeBalance = address(fundMe).balance;
        uint endingOwnerBalance = fundMe.getOwner().balance;
        assertEq(endingFundMeBalance, 0);
        assertEq(endingOwnerBalance, startingOwnerBalance + startingFundMeBalance);
    }
    function testWithdrawFromMultipleFunders() public funded{
        uint160 numberOfFunders = 10;
        for(uint160 i =1;i<numberOfFunders;i++){
           hoax(address(i),USER_BALANCE);
            fundMe.fund{value: USER_BALANCE}();

        }
         uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;
        vm.startPrank(fundMe.getOwner());
        fundMe.withdraw();
        vm.stopPrank();
        uint endingFundMeBalance = address(fundMe).balance;
        assertEq(endingFundMeBalance, 0);
        assertEq(startingFundMeBalance + startingOwnerBalance,fundMe.getOwner().balance);

    }
}