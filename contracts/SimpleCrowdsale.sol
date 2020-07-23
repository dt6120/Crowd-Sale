// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.7.0;

import "./ReleasableSimpleCoin.sol";
import "./Pausable.sol";
import "./Destructible.sol";

// Hollow-headed arrow: 'inherited from' - to use its functions and avoid duplicate code
// Filled arrow: 'depends on' - to be used as a class and make its objects

contract SimpleCrowdsale is Pausable, Destructible {

    uint256 public startTime;
    uint256 public endTime;
    uint256 public weiTokenPrice;
    uint256 public weiInvestmentObjective;

    mapping (address => uint256) public investmentAmountOf;
    uint256 public investmentReceived;
    uint256 public investmentRefunded;

    bool public isFinalized;
    bool public isRefundingAllowed;

    ReleasableSimpleCoin public crowdsaleToken;

    constructor (uint256 _startTime, uint256 _endTime, uint256 _weiTokenPrice, uint256 _etherInvestmentObjective) public payable {
        require (_startTime >= now, "");
        require (_endTime >= _startTime, "");
        require (_weiTokenPrice != 0, "");
        require (_etherInvestmentObjective != 0, "");

        startTime = _startTime;
        endTime = _endTime;
        weiTokenPrice = _weiTokenPrice;
        weiInvestmentObjective = _etherInvestmentObjective * 1e18;

        crowdsaleToken = new ReleasableSimpleCoin(0);
        isFinalized = false;
        isRefundingAllowed = false;
        owner = msg.sender;
    }

    event LogInvestment(address indexed investor, uint256 value);
    event LogTokenAssignment(address indexed investor, uint256 numTokens);
    event Refund(address investor, uint256 value);

    function invest () public payable {
        require (isValidInvestment(msg.value));

        address investor = msg.sender;
        uint256 investment = msg.value;

        investmentAmountOf[investor] += investment;
        investmentReceived += investment;

        assignTokens(investor, investment);
        emit LogInvestment(investor, investment);
    }

    function isValidInvestment (uint256 _investment) internal view returns(bool) {
        bool nonZeroInvestment = _investment != 0;
        bool withinCrowdsalePeriod = now >= startTime && now <= endTime;

        return nonZeroInvestment && withinCrowdsalePeriod;
    }

    function assignTokens (address _beneficiary, uint256 _investment) internal {
        uint256 _numberOfTokens = calculateNumberOfTokens(_investment);
        crowdsaleToken.mint(_beneficiary, _numberOfTokens);
    }

    function calculateNumberOfTokens (uint256 _investment) internal virtual returns(uint256) {
        return _investment / weiTokenPrice;
    }

    function finalize () public onlyOwner {
        require (!isFinalized);

        bool isCrowdsaleComplete = now > endTime;
        bool investmentObjectiveMet = investmentReceived >= weiInvestmentObjective;

        if (isCrowdsaleComplete) {
            if (investmentObjectiveMet) {
                crowdsaleToken.release();
            }
            else {
                isRefundingAllowed = true;
            }

            isFinalized = true;
        }
    }

    function refund () public {
        require (isRefundingAllowed);

        address payable investor = msg.sender;
        uint256 investment = investmentAmountOf[investor];

        require (investment != 0);

        investmentAmountOf[investor] = 0;
        investmentRefunded += investment;

        investor.transfer(investment);

        emit Refund(msg.sender, investment);
    }

}
