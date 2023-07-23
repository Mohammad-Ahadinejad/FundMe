// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {PriceConverter} from "./PriceConverter.sol";

error NotOwner();

contract FundMe{
    using PriceConverter for uint256;
    address[] public funders;
    mapping(address=>uint256) public fundersTotalDeposite;
    address immutable public OWNER;
    uint256 constant public minimumUSD = 5*10**18;

    constructor(){
        OWNER = msg.sender;
    }
    modifier onlyOwner{
        if(msg.sender != OWNER){
            revert NotOwner();
        }
        _;
    }

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }

    function fund() public payable {
        require(msg.value.getConversionRate()>=minimumUSD, "Not enough deposite!");
        funders.push(msg.sender);
        fundersTotalDeposite[msg.sender] += msg.value;
    }

    function withdraw() public onlyOwner{
        for(uint i=0; i<funders.length; i++){
            address funder = funders[i];
            fundersTotalDeposite[funder] = 0;
        }
        funders = new address[](0);
        (bool sent, ) = payable(OWNER).call{value: address(this).balance}("");
        require(sent, "Failed Transaction");
    }
}