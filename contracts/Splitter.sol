pragma solidity ^0.4.13;

contract Splitter {
    
  address public recipient1Address;
  address public recipient2Address;
  address public owner;
  uint public amount;

  event LogSplit(
  address sender,
  address recipient,
  uint amountSent,
  uint totalAmout);


    function Splitter(
        address recipient1,
        address recipient2)
        payable
        {
            require(recipient1 != 0);
            require(recipient2 != 0);
            require(msg.value > 0);
            require(msg.value % 2 == 0);
            recipient1Address = recipient1;
            recipient2Address = recipient2;
            owner = msg.sender;
            amount = msg.value / 2;

        }

    modifier onlyOwner{
            require(msg.sender == owner);
             _;
        }

    function sendMoneyToFirstAddress()
        payable
        public
        returns(bool success){
            require(amount > 0);
            recipient1Address.transfer(amount);
            LogSplit(msg.sender, recipient1Address, amount, msg.value);
            return true;
        }

    function sendMoneyToSecondAddress()
        payable
        public
        returns(bool success){
            require(amount > 0);
            recipient2Address.transfer(amount);
            LogSplit(msg.sender, recipient2Address, amount, msg.value);
            return true;
        }

    function kill()
        public
        onlyOwner(){
            selfdestruct(owner);
        }
}