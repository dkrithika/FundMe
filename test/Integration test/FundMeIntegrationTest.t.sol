// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;


import {Test} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/FundMe.s.sol";

import {FundFundMe, WithdrawFundMe} from "../../script/Interactions.s.sol";
contract FundMeIntegrationTest is Test{
     FundMe fundMe;
    DeployFundMe deployFundMe;
    address public USER = makeAddr("user");
    uint256 public constant USER_BALANCE = 10 ether;
    function setUp() external{
        deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER,USER_BALANCE);
    }
    function testUserCanFund() public {
        FundFundMe fundFundMe = new FundFundMe();
        fundFundMe.fundFundMe(address(fundMe)); 

        WithdrawFundMe withdrawFundMe = new WithdrawFundMe();
        withdrawFundMe.withdrawFundMe(address(fundMe));
         assert(address(fundMe).balance == 0);
    }
}