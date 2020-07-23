// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.7.0;

abstract contract FundingLimitStrategy {

	uint256 public fundingCap;

	function isFullInvestmentWithinLimit (uint256 _investment, uint256 fullInvestmentReceived) public view virtual returns(bool);

}