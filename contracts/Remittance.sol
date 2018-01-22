pragma solidity 0.4.19;

contract Remittance {

    bytes32 private beneficiaryHashedPassword = 0xd533f44a496ce998e51ca2c0bbe9445fa36bd71ab9d39735f92339b368a617f1;
    bytes32 private remitterHashedPassword = 0xffae97a8a972adf9bb9c72f22db8d7d687bcf1ed466105c78dccd16ac22d84ca;
    address public owner;
    uint public amount;
    uint public deadline;


    struct RemittanceBuilder{
        uint remittanceAmount;
        address moneyTransmitterAddress;
    }

    function Remittance(uint durationInMinutes)
        public
        {
            owner = msg.sender;
            deadline = now + durationInMinutes * 1 minutes;
        }

    mapping(uint => RemittanceBuilder) public remittanceMap;

    uint[] ids;

    mapping(address => uint) public balances;

    event LogRemittance(address from, address to, uint amount);

    event LogWithdrawl(uint sum);

    modifier isOwned()
        {
            require(msg.sender == owner);
            _;
        }

    modifier afterDeadline()
        {
            require(deadline >= now);
            _;
        }

    function setBeneficiaryPasswordHash(
        string beneficiaryPassword)
        private
        returns (bytes32 hash)
        {
            beneficiaryHashedPassword = keccak256(beneficiaryPassword);
            return beneficiaryHashedPassword;
        }

    function setRemitterPasswordHash(
        string remitterPassword)
        private
        returns (bytes32 hash)
        {
            remitterHashedPassword = keccak256(remitterPassword);
            return remitterHashedPassword;
        }

    function deposit()
        isOwned
        public
        payable
        returns (bool success){
            require(msg.value > 0);

            amount = msg.value;

            balances[msg.sender] -= msg.value;

            return true;
        }


    function withdraw(
        string beneficiaryPassword,
        string remitterPassword,
        address moneyTransmitterAddress)
            afterDeadline
            public
            payable
            returns(bool success)
            {
                require(beneficiaryHashedPassword == keccak256(beneficiaryPassword));
                require(remitterHashedPassword == keccak256(remitterPassword));
                require(moneyTransmitterAddress != 0);

                moneyTransmitterAddress.transfer(amount);

                balances[moneyTransmitterAddress] += amount;

                LogWithdrawl(amount);

                return true;
            }


    function remit(
        address beneficiaryAddress,
        address moneyTransmitter,
        uint id,
        string beneficiaryPw)
        public
        payable
        returns (bool success){
            require(beneficiaryAddress != address(0));
            require(moneyTransmitter != address(0));
            require(id != uint(0));
            require(beneficiaryHashedPassword == setBeneficiaryPasswordHash(beneficiaryPw));

            remittanceMap[id] = RemittanceBuilder(amount, moneyTransmitter);

            ids.push(id);

            balances[beneficiaryAddress] += amount;
            balances[moneyTransmitter] -= amount;

            LogRemittance(moneyTransmitter, beneficiaryAddress, amount);

            return true;
    }

  }