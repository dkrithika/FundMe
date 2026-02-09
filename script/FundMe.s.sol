// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;
 import {Script} from "forge-std/Script.sol";
 import {FundMe} from "../src/FundMe.sol";
 import {HelperConfig} from "../script/HelperConfig.s.sol";

contract DeployFundMe is Script{
    function run() external returns(FundMe){
        //Before startBroadcast -> Not a "real" tnx
        HelperConfig helperConfig = new HelperConfig();
       address ethUsdPriceFeed = helperConfig.activeNetworkConfig();
        //After startBradcast -> Real txn
    vm.startBroadcast();
   FundMe fundMe = new FundMe(ethUsdPriceFeed);
    vm.stopBroadcast();
    return fundMe;
    }
}