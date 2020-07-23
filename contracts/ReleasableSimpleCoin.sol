// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.7.0;

import "./SimpleCoin.sol";
import "./Pausable.sol";
import "./Destructible.sol";

contract ReleasableSimpleCoin is SimpleCoin, Pausable, Destructible {

    bool public released = false;

    modifier isReleased () {
        require (released);
        _;
    }

    constructor (uint256 _initialSupply) SimpleCoin (_initialSupply) public {}

    function release () public onlyOwner {
        released = true;
    }

    function transfer (address _to, uint256 _amount) public override virtual isReleased {
        SimpleCoin.transfer(_to, _amount);
    }

    function transferFrom (address _from, address _to, uint256 _amount) public override virtual isReleased returns(bool) {
        SimpleCoin.transferFrom(_from, _to, _amount);
    }

}
