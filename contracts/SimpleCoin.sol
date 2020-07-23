// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.7.0;

import "./Ownable.sol";

contract SimpleCoin is Ownable {

    mapping (address => uint256) public coinBalance;
    mapping (address => mapping (address => uint256)) public allowance;
    mapping (address => bool) public frozenAccount;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event FrozenAccount(address _target, bool frozen);

    constructor (uint256 _initialSupply) public {
        owner = msg.sender;
        mint(owner, _initialSupply);
    }

    function mint (address _recipient, uint256 _mintedAmount) public onlyOwner {
        coinBalance[_recipient] += _mintedAmount;

        emit Transfer(owner, _recipient, _mintedAmount);
    }

    function authorize (address _authAccount, uint256 _allowance) public returns(bool success) {
        allowance[msg.sender][_authAccount] = _allowance;
        return true;
    }

    function freezeAccount (address _target, bool _freeze) public onlyOwner {
        frozenAccount[_target] = _freeze;

        emit FrozenAccount(_target, _freeze);
    }

    function transfer (address _to, uint256 _amount) public virtual {
        require (coinBalance[msg.sender] >= _amount, 'You do not have sufficient balance.');
        require (_amount > 0, 'Enter valid amount.');

        coinBalance[msg.sender] -= _amount;
        coinBalance[_to] += _amount;

        emit Transfer(msg.sender, _to, _amount);
    }

    function transferFrom (address _from, address _to, uint256 _amount) public virtual returns(bool) {
        require (_to != address(0), "Enter valid address.");
        require (coinBalance[_from] >= _amount, "Sender account has insufficient balance.");
        require (_amount > 0, "Enter valid amount.");
        require (_amount <= allowance[_from][msg.sender], "Authorized transfer limit exceeded.");

        coinBalance[_from] -= _amount;
        coinBalance[_to] += _amount;
        allowance[_from][msg.sender] -= _amount;

        emit Transfer(_from, _to, _amount);

        return true;
    }

}
