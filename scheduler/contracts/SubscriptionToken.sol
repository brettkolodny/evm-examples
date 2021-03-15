pragma solidity ^0.6.0;

import "./Scheduler.sol";

contract SubscriptionToken {
    uint period;
    address[] subscribers;
    mapping(address => uint) public balanceOf;
    Scheduler constant scheduler = Scheduler(0x0000000000000000000000000000000000000802);

    constructor(uint _period) public payable {
        period = _period;

        scheduler.scheduleCall(address(this), 0, 50000, 100, period, abi.encodeWithSignature("paySubscribers()"));
    }

    function subscribe() public {
        subscribers.push(msg.sender);
    }

    function paySubscribers() public {
        require(msg.sender == address(this));

        for (uint256 i = 0; i < subscribers.length; i++) {
            address subscriber = subscribers[i];
            balanceOf[subscriber] += 1;
        }

        scheduler.scheduleCall(address(this), 0, 50000, 100, period, abi.encodeWithSignature("paySubscribers()"));
    }
}