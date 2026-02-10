//funds to be collected from users
//withdraw funds only owner
//funding
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.30;
import {PriceConverter} from "./PriceConverter.sol";
import {AggregatorV3Interface} from "../interfaces/AggregatorV3Interface.sol";
contract FundMe{
   using PriceConverter for uint256;
   uint public constant MINIMUM_USD = 5e18;
   AggregatorV3Interface private s_priceFeed;
   
   address[] private funders;
   mapping (address funders => uint256 amountFunded) private addressToAmountFunded;
   address private immutable i_owner;
   constructor(address priceFeed){
      i_owner = msg.sender;
      s_priceFeed  = AggregatorV3Interface(priceFeed);
   }
   modifier onlyOwner(){
     require(msg.sender == i_owner,"Only owner is allowed");
      _;
   }
   function fund() public payable{
       require(msg.value.getConversionRate(s_priceFeed) >= MINIMUM_USD,"Not enough Eth");
       funders.push(msg.sender);
       addressToAmountFunded[msg.sender] = addressToAmountFunded[msg.sender] + msg.value;
    }
      function getVersion() public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(s_priceFeed);
        return priceFeed.version();
    }
   function withdraw() public onlyOwner{
     
      for(uint i =0; i<funders.length;i++){
         address funder = funders[i];
         addressToAmountFunded[funder] = 0;
      }
      funders = new address[](0);
      (bool s, ) = payable(msg.sender).call{value : address(this).balance}("");
      require(s);
   }
   receive() external payable{
      fund();
   }
   fallback() external payable { 
      fund();
   }
   function getAddressToAmountFunded(address funderAddress) external view returns(uint256){
      return addressToAmountFunded[funderAddress];
   }
   function getFunders(uint256 index) external view returns(address){
      return funders[index];
   }
   function getOwner() external view returns(address){
      return i_owner;
   }
}