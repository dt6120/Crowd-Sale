// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.7.0;

import "./SimpleCrowdsale.sol";

contract TranchePricingCrowdsale is SimpleCrowdsale {

	struct Tranche {
		uint256 weiHighLimit;
		uint256 weiTokenPrice;
	}

	mapping (uint256 => Tranche) public trancheStructure;
	uint256 public trancheCurrentLevel;

	constructor (uint256 _startTime, uint256 _endTime, uint256 _etherInvestmentObjective) SimpleCrowdsale (_startTime, _endTime, 0, _etherInvestmentObjective) payable public {
		trancheStructure[0] = Tranche(25 ether, 0.002 ether);
		trancheStructure[1] = Tranche(50 ether, 0.003 ether);
		trancheStructure[2] = Tranche(75 ether, 0.004 ether);
		trancheStructure[3] = Tranche(100 ether, 0.005 ether);

		trancheCurrentLevel = 0;
	}

	function calculateNumberOfTokens (uint256 _investment) internal override virtual returns(uint256) {
		updateCurrentTrancheAndPrice();
		return _investment / weiTokenPrice;
	}

	function updateCurrentTrancheAndPrice () internal {
		uint256 i = trancheCurrentLevel;

		while(trancheStructure[i].weiHighLimit < investmentReceived) {
			i++;
		}

		trancheCurrentLevel = i;
		weiTokenPrice = trancheStructure[trancheCurrentLevel].weiTokenPrice;
	}

}