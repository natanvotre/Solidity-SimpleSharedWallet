pragma solidity ^0.8.7;

import "./Allowance.sol";

contract SharedWallet is Allowance {

    event MoneySent(address indexed _beneficiary, uint _amount);
    event MoneyReceived(address indexed _from, uint _amount);

    // Deposit function
    receive () external payable {
        emit MoneyReceived(msg.sender, msg.value);
    }

    // Withdraw function
    function withdraw(address payable _to, uint _amount) public ownerOrAllowed(_amount) {
        reduceAllowance(msg.sender, _amount);
        emit MoneySent(_to, _amount);
        _to.transfer(_amount);
    }

    function renounceOwnership() override public pure {
        revert("No can do!");
    }
}
