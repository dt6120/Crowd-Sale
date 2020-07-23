// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.7.0;

import "./FundingLimitStrategy.sol";

contract UnlimitedFundingStrategy is FundingLimitStrategy {

	function isFullInvestmentWithinLimit (uint256 _investment, uint256 _fullInvestmentReceived) public view returns(bool) {
		return true;
	}

}
