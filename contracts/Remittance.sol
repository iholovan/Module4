pragma solidity ^0.4.19;

contract Remittance {

    bytes32 beneficiaryHashedPassword;
    bytes32 remitterHashedPassword;
    address owner;
    uint deadline;
    uint amount;

    struct RemittanceBuilder{
        uint remittanceAmount;
        address moneyTransmitterAddress;
        uint remittanceDeadline;
    }

    function Remittance(uint _deadline) payable{
        deadline = _deadline;
        owner = msg.sender;
        amount = msg.value;
    }

    mapping(uint => RemittanceBuilder) remittanceMap;
    uint[] ids;
    mapping(address => uint ) balances;

    event LogRemittance(address from, address to, uint amount);
    event LogWithdrawl(bytes32 beneficiaryHashedPassword, bytes32 remitterHashedPassword, uint amount);



    modifier isOwned(){
        require(msg.sender == owner);
        _;
    }

    function getBeneficiaryPasswordHash(string beneficiaryPassword)  returns (bytes32){
        require(bytes(beneficiaryPassword).length != 0);
        beneficiaryHashedPassword = keccak256(beneficiaryPassword);
        return beneficiaryHashedPassword;
    }

    function getRemitterPasswordHash(string remitterPassword)  returns (bytes32){
        require(bytes(remitterPassword).length != 0);
        remitterHashedPassword = keccak256(remitterPassword);
        return remitterHashedPassword;
    }


    function withdraw(bytes32 beneficiaryHashedPw, bytes32 remitterHashedPw,
    uint commission, address moneyTransmitterAddress, uint withdrawDeadline)
    isOwned payable returns(bool success){
         require(msg.value > commission);
         require(deadline > withdrawDeadline);
         require(beneficiaryHashedPw != bytes32(0));
         require(remitterHashedPw != bytes32(0));
         require(commission != uint(0));
         require(withdrawDeadline != uint(0));

        require(moneyTransmitterAddress != address(0));
        require(beneficiaryHashedPassword == beneficiaryHashedPw);
        require(remitterHashedPassword == remitterHashedPw);
        moneyTransmitterAddress.send(msg.value + commission);
        balances[msg.sender] -= msg.value + commission;
        balances[moneyTransmitterAddress] += msg.value + commission;
        LogWithdrawl(beneficiaryHashedPw, remitterHashedPw, msg.value + commission);
        return true;
    }

    function remit(address beneficiaryAddress, uint id, address moneyTransmitter,
    uint remittanceDeadline, bytes32 beneficiaryHashedPw)
    payable returns (bool success){
        require(beneficiaryAddress != address(0));
        require(id != uint(0));
        require(moneyTransmitter != address(0));
        require(remittanceDeadline != uint(0));
        require(deadline > remittanceDeadline);
        require(beneficiaryHashedPassword == beneficiaryHashedPw);
        remittanceMap[id] = RemittanceBuilder(msg.value, moneyTransmitter, remittanceDeadline);
        ids.push(id);
        balances[moneyTransmitter] -= msg.value;
        balances[beneficiaryAddress] += msg.value;
        LogRemittance(moneyTransmitter, beneficiaryAddress, msg.value);
        return true;
    }

    function getBalance(address clientAddress) payable returns(uint amount){
        return balances[clientAddress];
    }

    function getRemittanceById(uint id) returns(uint remittanceAmount,
    address moneyTransmitterAddress, uint remittanceDeadline){
        RemittanceBuilder remittanceBuilder = remittanceMap[id];
        return (
            remittanceBuilder.remittanceAmount,
            remittanceBuilder.moneyTransmitterAddress,
            remittanceBuilder.remittanceDeadline
        );
    }

}