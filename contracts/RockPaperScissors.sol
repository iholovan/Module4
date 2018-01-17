pragma solidity ^0.4.19;

contract RockPaperScissors {
    
    address contractAddress = this;
    enum Actions {Paper, Scissors, Rock}
    Actions myaction;
    mapping(address => uint256) balances;
    event Transfer(address from, uint value);
    
    function depositEtherForEnrolment(uint amount) returns(bool success) {
     if(balances[msg.sender] < amount) return false;
       balances[msg.sender] -= amount;
        if(!contractAddress.send(msg.value)) {
        balances[msg.sender] += msg.value;      
            revert();
        }
        Transfer(msg.sender, amount);
        return true;
    }
    
    function setUniqueMove(uint256 value) {
     require(uint256(Actions.Rock) >= value);
     myaction = Actions(value);
    }
    
     function getUniqueMove() constant returns (uint256) {
         return uint256(myaction);
    }
    
    function rewardWinner(address winnerAddress) payable returns(bool success){
      uint reward = this.balance;
      balances[winnerAddress] += reward;
      if(!winnerAddress.send(reward)){
          balances[winnerAddress] -= reward;
          revert();
      }
        return true;
    }
 
}
