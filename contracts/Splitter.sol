pragma solidity ^0.4.19;

contract Splitter {
    
    function sendEther(address bob, address carol) public payable returns(bool success) {
        if(!bob.send(msg.value/2)) {
            revert();
        }
        if(!carol.send(msg.value/2)) {
            revert();
        }
        return true;
    }

}
