// SPDX-License-Identifier: MIT

pragma solidity ^0.8.30;

import {Script,console} from "forge-std/Script.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/FundMe.sol";
contract FundFundMe is Script{
    function fundFundMe(address mostrecentlyDeployed) public{
        vm.startBroadcast();
        FundMe(payable(mostrecentlyDeployed)).fund{value: 0.01 ether}();
        vm.stopBroadcast();
        console.log("Funded fundMe with 0.01 ether");
    }
    function run() external{
      address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("FundMe",block.chainid);
    fundFundMe(
        mostRecentlyDeployed
    );
    }
}
contract WithdrawFundMe is Script{
    function withdrawFundMe(address mostrecentlyDeployed) public{
        vm.startBroadcast();
        FundMe(payable(mostrecentlyDeployed)).withdraw();
        vm.stopBroadcast();
    }
    function run() external{
         address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("FundMe",block.chainid);
    WithdrawFundMe(
        mostRecentlyDeployed
    );
    }
}