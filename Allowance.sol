pragma solidity ^0.8.7;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract Allowance is Ownable {
    using SafeMath for uint;

    event AllowanceChanged(address _forWho, address _fromWhom, uint _oldAmount, uint _newAmount);

    mapping(address => uint) allowance;

    function isOwner() private view returns(bool) {
        return owner() == msg.sender;
    }

    modifier ownerOrAllowed(uint _amount) {
        require(
            isOwner() || allowance[msg.sender] >= _amount,
            "You are not allowed"
        );
        _;
    }

    function getAllowance(address _who) public view returns(uint) {
        if (msg.sender == owner() || msg.sender == _who) {
            return allowance[_who];
        } else {
            revert("You are not allowed");
        }
    }

    function setAllwoance(address _to, uint _amount) public onlyOwner {
        emit AllowanceChanged(_to, msg.sender, allowance[_to], _amount);
        allowance[_to] = _amount;
    }

    function reduceAllowance(address _who, uint _amount) internal {
        require(
            address(this).balance >= _amount,
            "No enough funds into this contract"
        );
        emit AllowanceChanged(_who, msg.sender, allowance[_who], allowance[_who].sub(_amount));
        if (!isOwner()) {
            allowance[_who] = allowance[_who].sub(_amount);
        }
    }

}
