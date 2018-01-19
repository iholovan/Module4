pragma solidity ^0.4.19;

contract RockPaperScissors {
    
  address player1;
  address player2;
  uint playerScore1 = 0;
  uint playerScore2 = 0;
  uint score;
  uint[] ids;

  struct PlayersChoice{
    string playerchoice1;
    string playerchoice2;

  }

  mapping(uint => PlayersChoice) playersChoices;
  mapping(uint => uint) scores;

  event LogMakingChoices(string playerchoice1, string playerchoice2);
  event LogReward(uint playerScore1,  uint playerScore2, uint balance);

  function makeChoice(string playerchoice1, string playerchoice2, uint choiceNumber)
  returns (bool success){
     require(bytes(playerchoice1).length != 0);
     require(bytes(playerchoice2).length != 0);
     playersChoices[choiceNumber] = PlayersChoice(playerchoice1, playerchoice2);
     ids.push(choiceNumber);
     LogMakingChoices(playerchoice1, playerchoice2);
     return true;
  }

  function identifyScore(string playerchoice1, string playerchoice2, uint game_id) {
      require(bytes(playerchoice1).length != 0);
      require(bytes(playerchoice2).length != 0);
      require(game_id != uint(0));
      if(sha3(playerchoice1) == sha3("paper") &&
        sha3(playerchoice2) == sha3("paper")){
            scores[game_id] = 0;
        }
        if(sha3(playerchoice1) == sha3("rock") &&
        sha3(playerchoice2) == sha3("rock")){
           scores[game_id] = 0;

        }
        if(sha3(playerchoice1) == sha3("scissor") &&
         sha3(playerchoice2) == sha3("scissor")){
            scores[game_id] = 0;
        }
        if(sha3(playerchoice1) == sha3("rock") &&
        sha3(playerchoice2) == sha3("paper")){
            scores[game_id] = 0;
            playerScore2 = 1;
        }
        if(sha3(playerchoice1) == sha3("paper") &&
        sha3(playerchoice2) == sha3("rock")){
            scores[game_id] = 0;
            playerScore1 = 1;
        }
        if(sha3(playerchoice1) == sha3("rock") &&
        sha3(playerchoice2) == sha3("scissors")){
            scores[game_id] = 0;
            playerScore1 = 1;
        }
        if(sha3(playerchoice1) == sha3("scissors") &&
        sha3(playerchoice2) == sha3("rock")){
            scores[game_id] = 0;
            playerScore2 = 1;
        }
        if(sha3(playerchoice1) == sha3("paper") &&
        sha3(playerchoice2) == sha3("scissors")){
            scores[game_id] = 0;
            playerScore1 = 1;
        }
        if(sha3(playerchoice1) == sha3("scissors") &&
        sha3(playerchoice2) == sha3("paper")){
            scores[game_id] = 0;
            playerScore2 = 1;
        }
  }

  function rewardWinner() payable returns (bool success){
      if(playerScore1 == 1){
          player1.send(this.balance);
      }else if(playerScore2 == 1){
          player2.send(this.balance);
      }
      LogReward(playerScore1, playerScore2, this.balance);
      playerScore1 = 0;
      playerScore2 = 0;
      return true;
  }
 }