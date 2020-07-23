// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.7.0;

import "./SimpleCrowdsale.sol";

contract FixedPricingCrowdsale is SimpleCrowdsale {

	constructor (uint256 _startTime, uint256 _endTime, uint256 _etherInvestmentObjective) SimpleCrowdsale (uint256 _startTime, uint256 _endTime, uint256 _etherInvestmentObjective) public payable {}

	function claculateNumberOfTokens (uint256 _investment) internal returns(uint256) {
		return _investment / weiTokenPrice;
	}	

}