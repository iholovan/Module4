pragma solidity 0.4.19;

contract Remittance {

    bytes32 public hashedInfo;
    address public owner;
    uint public amount;
    uint public deadline;

    function Remittance(uint durationInSeconds)
        public
        {
            owner = msg.sender;
            deadline = durationInSeconds;
        }

    event LogWithdrawl(uint sum, bytes32 hashedInfo);

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

    function hashInfo(
        address receiver1,
        bytes32 receiver1Password,
        address receiver2,
        bytes32 receiver2Password)
        constant
        public
        returns(bytes32 hash)
        {
            return keccak256(receiver1, receiver1Password, receiver2, receiver2Password);
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
        address beneficiaryAddress,
        bytes32 beneficiaryPassword,
        address remitterAddress,
        bytes32 remitterPassword)
            afterDeadline
            public
            payable
            returns(bool success)
            {

                hashedInfo = hashInfo(beneficiaryAddress, beneficiaryPassword, remitterAddress, remitterPassword);

                msg.sender.transfer(amount);

                LogWithdrawl(amount, hashedInfo);

                return true;
            }
}