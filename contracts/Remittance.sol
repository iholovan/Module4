pragma solidity 0.4.19;

contract Remittance {

    bytes32 private beneficiaryHashedPassword = 0xd533f44a496ce998e51ca2c0bbe9445fa36bd71ab9d39735f92339b368a617f1;
    bytes32 private remitterHashedPassword = 0xffae97a8a972adf9bb9c72f22db8d7d687bcf1ed466105c78dccd16ac22d84ca;
    address public owner;
    uint public amount;
    uint public deadline;


    function Remittance(uint durationInMinutes)
        public
        {
            owner = msg.sender;
            deadline = now + durationInMinutes * 1 minutes;
        }

    uint[] ids;

    mapping(address => uint) public balances;

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

            return true;
        }


    function withdraw(
        string beneficiaryPassword,
        string remitterPassword)
            afterDeadline
            public
            payable
            returns(bool success)
            {
                require(this.balance > 0);
                require(beneficiaryHashedPassword == keccak256(beneficiaryPassword));
                require(remitterHashedPassword == keccak256(remitterPassword));

                msg.sender.transfer(amount);

                LogWithdrawl(amount);

                return true;
            }
