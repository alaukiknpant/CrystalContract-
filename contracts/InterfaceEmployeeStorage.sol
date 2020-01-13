pragma solidity ^0.4.23;

contract InterfaceEmployeeStorage {

    function addEmployee(string name, address employeeAddress) public;
    function getCount() public view returns(uint256);
    function getId(address _address) public view returns (uint256);
    function getEmployeeAddress(uint256 _id) public view returns(address);
    function remove(address _address) public;
    function getName(uint256 _id) public view returns (string);
    function isEmployee(address _address)  public returns (bool); 
}
