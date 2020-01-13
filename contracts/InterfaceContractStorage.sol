pragma solidity ^0.4.23;

contract InterfaceContractStorage {

    function addContract( string name,  address _employerAddress, address _employeeAddress, address _MediatorAddress,
    uint salary, uint startdate, uint durationInWeeks, string jobType, string description) public;
    function remove(uint256 _contractID) public;
    function getContractCount() public constant returns(uint256);
    function EmployeeBelongstoContract(uint256 _contractID, address _address) public returns (bool);
    function EmployerBelongstoContract(uint256 _contractID, address _address) public returns (bool);
    function MediatorBelongstoContract(uint256 _contractID, address _address) public returns (bool);
    
    function EmployersignContract(uint256 _contractID) public;
    function EmployeesignContract(uint256 _contractID) public;
    function MediatorsignContract(uint256 _contractID) public;
    
    function CheckExpired(uint256 _contractID) public returns (bool);
    function getCompanyAddress(uint256 _contractID) public view returns (address);
    // function getContractStartdate(uint256 _id) public returns(string);
    // function getContractCompany(uint256 _id) public returns(string);
    // function getContractEmployee(uint256 _id) public returns(string);
    // function getContractMediator(uint256 _id) public returns(string);
    // function getAllContractsCompany(uint256 _id) public returns(string);
}
