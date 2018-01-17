pragma solidity ^0.4.19;

contract Splitter {
    
  address public owner;
  uint public amount;
  uint remainder;
  mapping (address => uint) public balances;
   
  event LogSplitSent(address sender, address recipient1, address recipient2, uint amountSent);
  event LogGetBalance(address recipient, uint amount);
   
   function Splitter(address recipient1, address recipient2)  payable {
      require(recipient1 != 0);
      require(recipient2 != 0);
      owner = msg.sender;
      remainder = msg.value % 2;
      amount = msg.value / 2;
   }
   
   modifier onlyOwner{
       require(msg.sender == owner);
       _;
   }
    modifier notNull(uint value){
        require(value > 0);
        _;
    }
   
  function sendMoney(address recipient1, address recipient2) 
  onlyOwner payable returns(bool success){
      balances[recipient1] += amount + remainder;
      balances[recipient2] += amount;
      LogSplitSent(owner, recipient1, recipient2, msg.value/2);
      return true;
  }
  
  function getBalance(address customerAddress) payable returns (uint){
      LogGetBalance(customerAddress, balances[customerAddress]);
      return balances[customerAddress];
  }
  
}
