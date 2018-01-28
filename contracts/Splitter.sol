pragma solidity ^0.4.13;

contract Splitter {
    
  address public recipient1Address;
  address public recipient2Address;
  address public owner;
  uint public amount;
  uint remainder;
  mapping (address => uint) public balances;

  event LogSplitSent(
  address sender,
  address recipient1,
  address recipient2,
  uint amountSent,
  uint totalAmout);

   function Splitter(
        address recipient1,
        address recipient2)
        {
            require(recipient1 != 0);
            require(recipient2 != 0);
            recipient1Address = recipient1;
            recipient2Address = recipient2;
            owner = msg.sender;
        }

   modifier onlyOwner{
            require(msg.sender == owner);
             _;
        }

  function sendMoney()
    onlyOwner
    payable
    returns(bool success){
            require(msg.value % 2 == 0);
            amount = msg.value / 2;
            recipient1Address.transfer(amount);
            recipient2Address.transfer(amount);
            LogSplitSent(owner, recipient1Address, recipient2Address, amount, msg.value);
            return true;
        }
}