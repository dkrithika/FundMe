

FundMe 🚀


Minimal crowdfunding contract accepting ETH donations with USD minimum threshold enforced by Chainlink price feeds.

🛠️ Tech Stack

Solidity 0.8.26 + Foundry (forge build/test/deploy)

Chainlink ETH/USD Price Feeds

🧪 Quick Start

bash

git clone https://github.com/dkrithika/FundMe.git

cd FundMe

forge install

forge test

✨ Features

✅ ETH funding with USD minimum threshold

✅ Chainlink oracle price integration

✅ Owner-only withdrawals + refunds

✅ Gas-optimized Foundry test suite

How it works (technical):

// 1. User sends ETH function fund() public payable { require(getConversionRate(msg.value) >= MINIMUM_USD, "Below min threshold"); }

// 2. Chainlink gives price function getConversionRate(uint256 ethAmount) internal view returns (uint256) { (,int256 price,,,) = priceFeed.latestRoundData(); // ETH/USD = $2500 return uint256(price) * ethAmount / 1e18; // ETH → USD }

// 3. Owner withdraws when total ≥ $50 USD function withdraw() public onlyOwner { // Send all ETH to owner }

📁 Project Structure text src/ ├── FundMe.sol # Main crowdfunding contract

└── PriceConverter.sol # Chainlink price utils test/

└── FundMe.t.sol # Comprehensive tests script/

├── FundMe.s.sol # Deployment script

└── HelperConfig.s.sol # Network config

🚀 Run Tests

bash

forge test # All tests

forge test -vvv # Verbose output

📄 License MIT License - See LICENSE file

Built by Damshala Krithika | Solidity + Foundry + Chainlink
