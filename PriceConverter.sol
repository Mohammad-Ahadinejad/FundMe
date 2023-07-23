// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library PriceConverter{

    function getDecials() internal view returns(uint256){
        address sepoliaAddress_eth_USD = 0x694AA1769357215DE4FAC081bf1f309aDC325306;
        uint8 baseDecimals = AggregatorV3Interface(sepoliaAddress_eth_USD).decimals();
        return  uint256(baseDecimals);
    }

    function getLatestPrice() internal view returns(uint256){
        address sepoliaAddress_eth_USD = 0x694AA1769357215DE4FAC081bf1f309aDC325306;
        (,int256 answer,,,) = AggregatorV3Interface(sepoliaAddress_eth_USD).latestRoundData();
        uint256 decimals = getDecials();
        return uint256(answer)*10**(18-decimals);
    }

    function getConversionRate(uint256 _ETHamount) internal view returns(uint256){
        uint256 price = (getLatestPrice() * _ETHamount) / 1e18;
        return price;
    }

}