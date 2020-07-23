// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.7.0;

import "./Ownable.sol";

contract Pausable is Ownable {

	bool public paused = false;

	modifier whenNotPaused() { 
		require (!paused); 
		_; 
	}

	modifier whenPaused() { 
		require (paused); 
		_; 
	}
	
	function pause () public onlyOwner whenNotPaused {
		paused = true;
	}

	function unpause () public onlyOwner whenPaused {
		paused = false;
	}
	

}