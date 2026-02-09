//SPDX-License-Identifier : MIT;
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;
//0x694AA1769357215DE4FAC081bf1f309aDC325306
import {AggregatorV3Interface} from "@chainlink/shared/interfaces/AggregatorV3Interface.sol";

library PriceConverter{
    function getPrice(AggregatorV3Interface priceFeed) internal view returns(uint256){
      (,int256 price,,,)= priceFeed.latestRoundData();
       require(price > 0); // Safety check
      return uint256(price * 1e18);
   }
  
   function getConversionRate(uint ethAmount, AggregatorV3Interface priceFeed) internal view returns(uint256){
      
      uint256 ethPrice = getPrice(priceFeed);
      uint256 ethAmountInUSD= (ethPrice * ethAmount)/1e18;
      return ethAmountInUSD;
   }
}