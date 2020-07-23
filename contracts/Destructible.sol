// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.7.0;

import "./Ownable.sol";

contract Destructible is Ownable {

	constructor () payable public {}

	function destroyAndSend (address payable _recipient) public onlyOwner {
		selfdestruct(_recipient);
	}

}